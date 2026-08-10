import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/brightness_service.dart';
import '../services/vlc_decoder.dart';
import '../services/id_extractor.dart';
import '../services/location_service.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({super.key, required this.cameras});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  bool _isInitialized = false;
  double _brightness = 0;
  final VlcDecoder _decoder = VlcDecoder();
  String _bitstream = '';
  String? _detectedId;
  String? _locationName;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras[0], ResolutionPreset.low);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() => _isInitialized = true);
      _controller.startImageStream((image) {
        final brightness = BrightnessService.computeRoiBrightness(image);
        _decoder.addSample(brightness);
        final bits = _decoder.getBitstream();
        final id = IdExtractor.extractId(bits);
        setState(() {
          _brightness = brightness;
          _bitstream = bits;
          if (id != null) {
            _detectedId = id;
            _locationName = LocationService.getLocation(id);
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Text(
                'Brightness: ${_brightness.toStringAsFixed(1)}',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Text(
                'Bits: $_bitstream',
                style: const TextStyle(color: Colors.greenAccent, fontSize: 14),
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Text(
                'ID: ${_detectedId ?? "Scanning..."}',
                style: const TextStyle(color: Colors.yellowAccent, fontSize: 18),
              ),
            ),
          ),
          Positioned(
            top: 160,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Text(
                _locationName != null ? 'Location: $_locationName' : 'Location: Unknown',
                style: const TextStyle(color: Colors.cyanAccent, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
