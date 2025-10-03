/// Common validation helpers for user input and configuration.
class Validators {
  /// Ensures [value] is not empty.
  static bool isNotEmpty(String? value) => value != null && value.trim().isNotEmpty;

  /// Checks whether [value] falls within [min] and [max] inclusive.
  static bool inRange(num value, num min, num max) => value >= min && value <= max;
}
