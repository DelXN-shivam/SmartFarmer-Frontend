// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/services.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:image/image.dart' as img;
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;
// import 'package:permission_handler/permission_handler.dart';

// class CameraScreen extends StatefulWidget {
//   final CameraDescription camera;
//   final double latitude;
//   final double longitude;

//   const CameraScreen({
//     super.key,
//     required this.camera,
//     required this.latitude,
//     required this.longitude,
//   });

//   @override
//   State<CameraScreen> createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//   File? _finalImageFile;
//   bool _isCapturing = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     try {
//       _controller = CameraController(
//         widget.camera,
//         ResolutionPreset.medium,
//         enableAudio: false,
//       );
//       _initializeControllerFuture = _controller.initialize();
//       await _requestPermissions();
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Camera initialization failed: $e')),
//         );
//       }
//     }
//   }

//   Future<void> _requestPermissions() async {
//     await Permission.camera.request();
//     await Permission.storage.request();
//   }

//   Future<void> _captureAndOverlay() async {
//     if (_isCapturing) return;

//     setState(() => _isCapturing = true);

//     try {
//       final image = await _controller.takePicture();
//       final overlayedImage = await _addOverlayToImage(image.path);

//       setState(() => _finalImageFile = overlayedImage);
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error capturing image: $e')));
//       }
//     } finally {
//       setState(() => _isCapturing = false);
//     }
//   }

//   Future<File> _addOverlayToImage(String imagePath) async {
//     final imageBytes = await File(imagePath).readAsBytes();
//     final capturedImage = img.decodeImage(imageBytes)!;

//     // Get location information
//     final locationInfo = await _getLocationInfo();

//     // Draw overlays
//     _drawOverlays(capturedImage, locationInfo);

//     // Save the new image
//     final outputPath = await _getOutputPath();
//     return File(outputPath)..writeAsBytesSync(img.encodeJpg(capturedImage));
//   }

//   Future<Map<String, String>> _getLocationInfo() async {
//     final lat = widget.latitude;
//     final lng = widget.longitude;
//     String address = '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}';

//     try {
//       final placemarks = await placemarkFromCoordinates(lat, lng);
//       if (placemarks.isNotEmpty) {
//         final place = placemarks.first;
//         address = [
//           if (place.name?.isNotEmpty ?? false) place.name,
//           if (place.street?.isNotEmpty ?? false) place.street,
//           if (place.subLocality?.isNotEmpty ?? false) place.subLocality,
//           if (place.locality?.isNotEmpty ?? false) place.locality,
//           if (place.administrativeArea?.isNotEmpty ?? false)
//             place.administrativeArea,
//           if (place.country?.isNotEmpty ?? false) place.country,
//         ].where((e) => e != null).join(', ');
//       }
//     } catch (e) {
//       debugPrint("Reverse geocoding failed: $e");
//     }

//     return {
//       'coordinates': '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}',
//       'timestamp': DateTime.now().toString(),
//       'address': address,
//     };
//   }

//   void _drawOverlays(img.Image image, Map<String, String> info) {
//     final textColor = img.ColorRgb8(255, 255, 255);
//     final shadowColor = img.ColorRgb8(0, 0, 0);
//     const fontSize = 24.0;
//     const padding = 10;

//     // Draw coordinates
//     _drawTextWithShadow(
//       image,
//       'Coordinates: ${info['coordinates']}',
//       x: padding,
//       y: padding,
//       color: textColor,
//       shadowColor: shadowColor,
//       fontSize: fontSize,
//     );

//     // Draw timestamp
//     _drawTextWithShadow(
//       image,
//       'Time: ${info['timestamp']}',
//       x: padding,
//       y: padding + 40,
//       color: textColor,
//       shadowColor: shadowColor,
//       fontSize: fontSize,
//     );

//     // Draw address (with line wrapping)
//     final addressLines = _splitText(info['address']!, 40);
//     var yOffset = padding + 80;
//     for (final line in addressLines) {
//       _drawTextWithShadow(
//         image,
//         line,
//         x: padding,
//         y: yOffset,
//         color: textColor,
//         shadowColor: shadowColor,
//         fontSize: fontSize,
//       );
//       yOffset += 30;
//     }
//   }

//   void _drawTextWithShadow(
//     img.Image image,
//     String text, {
//     required int x,
//     required int y,
//     required img.Color color,
//     required img.Color shadowColor,
//     required double fontSize,
//     int shadowOffset = 1,
//   }) {
//     img.drawString(
//       image,
//       text,
//       font: img.arial24,
//       x: x + shadowOffset,
//       y: y + shadowOffset,
//       color: shadowColor,
//     );
//     img.drawString(image, text, font: img.arial24, x: x, y: y, color: color);
//   }

//   Future<String> _getOutputPath() async {
//     final dir = await getApplicationDocumentsDirectory();
//     return p.join(
//       dir.path,
//       'crop_photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
//     );
//   }

//   List<String> _splitText(String text, int maxLineLength) {
//     final words = text.split(' ');
//     final lines = <String>[];
//     var currentLine = '';

//     for (final word in words) {
//       if ((currentLine.length + word.length + 1) <= maxLineLength) {
//         currentLine += '$word ';
//       } else {
//         lines.add(currentLine.trim());
//         currentLine = '$word ';
//       }
//     }

//     if (currentLine.trim().isNotEmpty) {
//       lines.add(currentLine.trim());
//     }

//     return lines;
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 70, 65, 65),
//       appBar: AppBar(
//         title: const Text('Capture Crop Photo'),
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.close, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.check, color: Colors.white),
//             onPressed: _finalImageFile == null
//                 ? null
//                 : () => Navigator.pop(context, _finalImageFile!.path),
//             tooltip: 'Done',
//           ),
//         ],
//       ),
//       body: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Stack(
//           children: [
//             _buildCameraPreview(),
//             if (_finalImageFile == null) _buildCameraControls(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCameraPreview() {
//     if (_finalImageFile != null) {
//       return Image.file(_finalImageFile!, fit: BoxFit.cover);
//     }

//     return FutureBuilder(
//       future: _initializeControllerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return CameraPreview(_controller);
//         }
//         return const Center(child: CircularProgressIndicator());
//       },
//     );
//   }

//   Widget _buildCameraControls() {
//     return Positioned(
//       bottom: 40,
//       left: 0,
//       right: 0,
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: _isCapturing ? null : _captureAndOverlay,
//             child: Container(
//               width: 72,
//               height: 72,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: _isCapturing ? Colors.grey : Colors.white,
//                   width: 4,
//                 ),
//               ),
//               child: Container(
//                 margin: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: _isCapturing
//                       ? Colors.grey
//                       : Colors.white.withOpacity(0.5),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             'Tap to capture',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               shadows: [
//                 Shadow(
//                   color: Colors.black.withOpacity(0.8),
//                   blurRadius: 4,
//                   offset: const Offset(1, 1),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({
    super.key,
    required this.camera,
    required double latitude,
    required double longitude,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  File? _finalImageFile;
  bool _isCapturing = false;
  Position? _currentPosition;
  String _currentAddress = '';
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _startLiveLocationTracking();
  }

  Future<void> _initializeCamera() async {
    try {
      _controller = CameraController(
        widget.camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      _initializeControllerFuture = _controller.initialize();
      await _requestPermissions();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera initialization failed: $e')),
        );
      }
    }
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.storage.request();
    await Geolocator.requestPermission();
  }

  void _startLiveLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    _positionStreamSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((Position position) async {
          setState(() => _currentPosition = position);
          try {
            final placemarks = await placemarkFromCoordinates(
              position.latitude,
              position.longitude,
            );
            if (placemarks.isNotEmpty) {
              final place = placemarks.first;
              final addressParts = [
                place.name,
                place.street,
                place.locality,
                place.administrativeArea,
                place.country,
              ].where((part) => part != null && part.isNotEmpty).toList();
              setState(() {
                _currentAddress = addressParts.join(', ');
              });
            }
          } catch (e) {
            setState(() {
              _currentAddress = 'Location error';
            });
          }
        });
  }

  Future<void> _captureAndOverlay() async {
    if (_isCapturing) return;

    setState(() => _isCapturing = true);

    try {
      final image = await _controller.takePicture();
      final overlayedImage = await _addOverlayToImage(image.path);

      setState(() => _finalImageFile = overlayedImage);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error capturing image: $e')));
      }
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  Future<File> _addOverlayToImage(String imagePath) async {
    final imageBytes = await File(imagePath).readAsBytes();
    final capturedImage = img.decodeImage(imageBytes)!;

    final info = {
      'coordinates': _currentPosition != null
          ? '${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}'
          : 'Unknown',
      'timestamp': DateTime.now().toString(),
      'address': _currentAddress,
    };

    _drawOverlays(capturedImage, info);

    final outputPath = await _getOutputPath();
    return File(outputPath)..writeAsBytesSync(img.encodeJpg(capturedImage));
  }

  void _drawOverlays(img.Image image, Map<String, String> info) {
    final textColor = img.ColorRgb8(255, 255, 255);
    final shadowColor = img.ColorRgb8(0, 0, 0);
    const fontSize = 24.0;
    const padding = 10;

    _drawTextWithShadow(
      image,
      'Coordinates: ${info['coordinates']}',
      x: padding,
      y: padding,
      color: textColor,
      shadowColor: shadowColor,
      fontSize: fontSize,
    );
    _drawTextWithShadow(
      image,
      'Time: ${info['timestamp']}',
      x: padding,
      y: padding + 40,
      color: textColor,
      shadowColor: shadowColor,
      fontSize: fontSize,
    );

    final addressLines = _splitText(info['address']!, 40);
    var yOffset = padding + 80;
    for (final line in addressLines) {
      _drawTextWithShadow(
        image,
        line,
        x: padding,
        y: yOffset,
        color: textColor,
        shadowColor: shadowColor,
        fontSize: fontSize,
      );
      yOffset += 30;
    }
  }

  void _drawTextWithShadow(
    img.Image image,
    String text, {
    required int x,
    required int y,
    required img.Color color,
    required img.Color shadowColor,
    required double fontSize,
    int shadowOffset = 1,
  }) {
    img.drawString(
      image,
      text,
      font: img.arial24,
      x: x + shadowOffset,
      y: y + shadowOffset,
      color: shadowColor,
    );
    img.drawString(image, text, font: img.arial24, x: x, y: y, color: color);
  }

  Future<String> _getOutputPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(
      dir.path,
      'crop_photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
  }

  List<String> _splitText(String text, int maxLineLength) {
    final words = text.split(' ');
    final lines = <String>[];
    var currentLine = '';

    for (final word in words) {
      if ((currentLine.length + word.length + 1) <= maxLineLength) {
        currentLine += '$word ';
      } else {
        lines.add(currentLine.trim());
        currentLine = '$word ';
      }
    }

    if (currentLine.trim().isNotEmpty) {
      lines.add(currentLine.trim());
    }

    return lines;
  }

  @override
  void dispose() {
    _controller.dispose();
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 70, 65, 65),
      appBar: AppBar(
        title: const Text('Capture Crop Photo'),
        backgroundColor: Colors.black,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.close, color: Colors.white),
        //   onPressed: () => Navigator.pop(context),
        // ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.check, color: Colors.white),
        //     onPressed: _finalImageFile == null
        //         ? null
        //         : () => Navigator.pop(context, _finalImageFile!.path),
        //     tooltip: 'Done',
        //   ),
        // ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            _finalImageFile != null
                ? Image.file(_finalImageFile!, fit: BoxFit.cover)
                : FutureBuilder(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(_controller);
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
            if (_finalImageFile == null && _currentAddress.isNotEmpty)
              Positioned(
                top: 30,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _currentAddress,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            if (_finalImageFile == null)
              _buildCameraControls()
            else
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.blueGrey,
                          size: 40,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.check,
                          color: Colors.blueGrey,
                          size: 40,
                        ),
                        onPressed: _finalImageFile == null
                            ? null
                            : () =>
                                  Navigator.pop(context, _finalImageFile!.path),
                        tooltip: 'Done',
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraControls() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Column(
        children: [
          GestureDetector(
            onTap: _isCapturing ? null : _captureAndOverlay,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isCapturing ? Colors.grey : Colors.white,
                  width: 4,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isCapturing
                      ? Colors.grey
                      : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tap to capture',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 4,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
