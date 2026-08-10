class VlcDecoder {
  final List<double> _samples = [];
  final int windowSize;

  VlcDecoder({this.windowSize = 60});

  void addSample(double brightness) {
    _samples.add(brightness);
    if (_samples.length > windowSize) {
      _samples.removeAt(0);
    }
  }

  String getBitstream() {
    if (_samples.length < 10) return '';

    final maxVal = _samples.reduce((a, b) => a > b ? a : b);
    final minVal = _samples.reduce((a, b) => a < b ? a : b);
    final threshold = (maxVal + minVal) / 2;

    return _samples.map((s) => s > threshold ? '1' : '0').join();
  }

  double getRange() {
    if (_samples.isEmpty) return 0;
    final maxVal = _samples.reduce((a, b) => a > b ? a : b);
    final minVal = _samples.reduce((a, b) => a < b ? a : b);
    return maxVal - minVal;
  }
}
