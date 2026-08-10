import "package:flutter/material.dart";
import "package:camera/camera.dart";
import "../services/brightness_service.dart";
import "../services/vlc_decoder.dart";
import "../services/id_extractor.dart";
import "../services/location_service.dart";
import "../services/test_result.dart";
import "../services/results_store.dart";
import "results_screen.dart";

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
  String _bitstream = "";
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

  void _logReading() {
    if (_detectedId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No ID detected yet")),
      );
      return;
    }
    ResultsStore.addResult(TestResult(
      id: _detectedId!,
      location: _locationName ?? "Unknown",
      brightness: _brightness,
      timestamp: DateTime.now(),
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Reading logged")),
    );
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
      appBar: AppBar(
        title: const Text("VLC Indoor Positioning"),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ResultsScreen()),
              );
            },
          ),
        ],
      ),
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
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Text(
                "Brightness: ${_brightness.toStringAsFixed(1)}\nBits: $_bitstream",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.black54,
              child: Text(
                _locationName != null
                    ? "Location: $_locationName"
                    : "Location: Scanning...",
                style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _logReading,
        label: const Text("Log Reading"),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
