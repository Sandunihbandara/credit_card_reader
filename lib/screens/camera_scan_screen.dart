import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../models/card_model.dart';
import '../services/card_storage.dart';

class CameraScanScreen extends StatefulWidget {
  const CameraScanScreen({super.key});

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen> {
  CameraController? _cameraController;
  late Future<void> _initializeControllerFuture;

  bool _isProcessing = false;
  String? _detectedNumber;
  String? _detectedName;
  String? _detectedExpiry;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController!.initialize();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _captureAndScan() async {
    if (_cameraController == null || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      await _initializeControllerFuture;

      final XFile imageFile = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(imageFile.path);

      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);

      await textRecognizer.close();

      final parsed = _extractCardDetails(recognizedText.text);

      if (!mounted) return;

      setState(() {
        _detectedNumber = parsed['number'];
        _detectedName = parsed['name'];
        _detectedExpiry = parsed['expiry'];
      });

      if (_detectedNumber != null ||
          _detectedName != null ||
          _detectedExpiry != null) {
        _showDetectedDataDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not detect card details clearly. Try again.'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Scan failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Map<String, String?> _extractCardDetails(String text) {
    final normalized = text
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final numberMatch = RegExp(r'(\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4})')
        .firstMatch(normalized);

    final expiryMatch =
    RegExp(r'(0[1-9]|1[0-2])\/?([0-9]{2})').firstMatch(normalized);

    String? number = numberMatch?.group(0);
    if (number != null) {
      number = number.replaceAll('-', ' ').replaceAll(RegExp(r'\s+'), ' ');
    }

    String? expiry;
    if (expiryMatch != null) {
      final mm = expiryMatch.group(1);
      final yy = expiryMatch.group(2);
      expiry = '$mm/$yy';
    }

    String? name;
    final lines = text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    for (final line in lines) {
      final upper = line.toUpperCase();
      final isPossibleName = RegExp(r'^[A-Z ]{5,}$').hasMatch(upper) &&
          !upper.contains('VALID') &&
          !upper.contains('THRU') &&
          !upper.contains('CARD') &&
          !RegExp(r'\d').hasMatch(upper);

      if (isPossibleName) {
        name = upper;
        break;
      }
    }

    return {
      'number': number,
      'expiry': expiry,
      'name': name,
    };
  }

  void _showDetectedDataDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Detected Card Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _detailRow('Number', _detectedNumber ?? 'Not found'),
            _detailRow('Name', _detectedName ?? 'Not found'),
            _detailRow('Expiry', _detectedExpiry ?? 'Not found'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Scan Again'),
          ),
          ElevatedButton(
            onPressed: () {
              CardStorage.addCard(
                CardModel(
                  number: _detectedNumber ?? 'Unknown',
                  name: _detectedName ?? 'Unknown',
                  expiry: _detectedExpiry ?? 'Unknown',
                  type: 'CAMERA',
                ),
              );

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Card saved successfully')),
              );
            },
            child: const Text('Save Card'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF112D6B);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Scan with Camera'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (_cameraController == null ||
              !_cameraController!.value.isInitialized) {
            return const Center(
              child: Text(
                'Camera not available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Stack(
            children: [
              CameraPreview(_cameraController!),

              Container(
                color: Colors.black.withOpacity(0.25),
              ),

              Center(
                child: Container(
                  width: 320,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),

              Positioned(
                top: 110,
                left: 24,
                right: 24,
                child: Column(
                  children: const [
                    Text(
                      'Align your card inside the frame',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Make sure the card text is clear and well lit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 36,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _isProcessing ? null : _captureAndScan,
                    child: Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isProcessing ? Colors.grey : primaryBlue,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: _isProcessing
                          ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}