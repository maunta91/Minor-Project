class IdExtractor {
  static const String preamble = '1010101';
  static const int idLength = 8;

  static String? extractId(String bitstream) {
    final index = bitstream.indexOf(preamble);
    if (index == -1) return null;

    final idStart = index + preamble.length;
    final idEnd = idStart + idLength;

    if (idEnd > bitstream.length) return null;

    return bitstream.substring(idStart, idEnd);
  }
}
