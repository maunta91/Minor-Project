class LocationService {
  // Maps decoded 8-bit IDs to real-world location names.
  // These must match exactly what each Arduino LED node transmits.
  static const Map<String, String> _locationDb = {
    '00001010': 'Room 101',
    '00001011': 'Library Entrance',
    '00001100': 'Lab 3',
  };

  static String? getLocation(String? id) {
    if (id == null) return null;
    return _locationDb[id];
  }
}
