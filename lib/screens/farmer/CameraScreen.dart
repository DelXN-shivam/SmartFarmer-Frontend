import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:geocoding/geocoding.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  final double latitude; // Add these parameters
  final double longitude;

  const CameraScreen({
    super.key,
    required this.camera,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  File? _finalImageFile;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.storage.request();
  }

  Future<void> _captureAndOverlay() async {
    await _initializeControllerFuture;

    final image = await _controller.takePicture();
    final Uint8List imageBytes = await File(image.path).readAsBytes();

    final img.Image capturedImage = img.decodeImage(imageBytes)!;

    // Use the coordinates passed from CropDetailsForm
    final double latitude = widget.latitude;
    final double longitude = widget.longitude;
    String location =
        "${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}";

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        location = [
          if (place.name != null && place.name!.isNotEmpty) place.name,
          if (place.street != null && place.street!.isNotEmpty) place.street,
          if (place.subLocality != null && place.subLocality!.isNotEmpty)
            place.subLocality,
          if (place.locality != null && place.locality!.isNotEmpty)
            place.locality,
          if (place.administrativeArea != null &&
              place.administrativeArea!.isNotEmpty)
            place.administrativeArea,
          if (place.postalCode != null && place.postalCode!.isNotEmpty)
            place.postalCode,
          if (place.country != null && place.country!.isNotEmpty) place.country,
        ].where((e) => e != null && e.isNotEmpty).join(', ');
      }
    } catch (e) {
      print("Reverse geocoding failed: $e");
    }

    // Info to overlay
    final String timestamp = DateTime.now().toString();

    // Draw text onto image
    img.drawString(
      capturedImage,
      'Coordinates: ${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}',
      font: img.arial24,
      x: 10,
      y: 10,
    );
    img.drawString(
      capturedImage,
      'Time: $timestamp',
      font: img.arial24,
      x: 10,
      y: 40,
    );

    // Wrap long location text into multiple lines
    List<String> locationLines = _splitText(location, 40);
    int yPosition = 70;
    for (String line in locationLines) {
      img.drawString(
        capturedImage,
        line,
        font: img.arial24,
        x: 10,
        y: yPosition,
      );
      yPosition += 30;
    }

    // Save image
    final Directory dir = await getApplicationDocumentsDirectory();
    final String filePath = p.join(
      dir.path,
      'overlayed_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    final File file = File(filePath)
      ..writeAsBytesSync(img.encodeJpg(capturedImage));

    setState(() {
      _finalImageFile = file;
    });
  }

  List<String> _splitText(String text, int maxLineLength) {
    List<String> lines = [];
    while (text.length > maxLineLength) {
      int splitIndex = text.lastIndexOf(' ', maxLineLength);
      if (splitIndex == -1) splitIndex = maxLineLength;
      lines.add(text.substring(0, splitIndex).trim());
      text = text.substring(splitIndex).trim();
    }
    if (text.isNotEmpty) {
      lines.add(text);
    }
    return lines;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capture Crop Photo')),
      body: Column(
        children: [
          Expanded(
            child: _finalImageFile != null
                ? Image.file(_finalImageFile!)
                : FutureBuilder(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(_controller);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _captureAndOverlay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'CAPTURE PHOTO',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_finalImageFile != null) {
                        Navigator.pop(context, _finalImageFile!.path);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('DONE', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
