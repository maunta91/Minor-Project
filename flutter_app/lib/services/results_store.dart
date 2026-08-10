import "test_result.dart";

class ResultsStore {
  static final List<TestResult> _results = [];

  static void addResult(TestResult result) {
    _results.add(result);
  }

  static List<TestResult> getAll() {
    return List.unmodifiable(_results);
  }

  static void clear() {
    _results.clear();
  }
}
