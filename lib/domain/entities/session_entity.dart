/// Domain entity capturing a tracked session event.
class SessionEntity {
  /// Constructs a session entity.
  const SessionEntity({
    required this.id,
    required this.date,
    required this.feature,
    required this.durationSec,
    required this.notes,
  });

  /// Unique identifier.
  final String id;

  /// Time when the session occurred.
  final DateTime date;

  /// Feature associated with the session.
  final String feature;

  /// Duration in seconds.
  final int durationSec;

  /// Additional notes.
  final String notes;
}
