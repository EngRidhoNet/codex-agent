/// Data model representing a persisted session log entry.
import '../../domain/entities/session_entity.dart';

/// Serializable session log model.
class SessionLogModel {
  /// Constructs a log model instance.
  SessionLogModel({
    required this.id,
    required this.date,
    required this.feature,
    required this.durationSec,
    required this.notes,
  });

  /// Unique identifier for the log.
  final String id;

  /// UTC timestamp string.
  final DateTime date;

  /// Feature name.
  final String feature;

  /// Duration in seconds.
  final int durationSec;

  /// Optional notes or metadata.
  final String notes;

  /// Builds model from map data.
  factory SessionLogModel.fromMap(Map data) {
    return SessionLogModel(
      id: data['id'] as String,
      date: DateTime.parse(data['date'] as String),
      feature: data['feature'] as String,
      durationSec: data['durationSec'] as int,
      notes: data['notes'] as String? ?? '',
    );
  }

  /// Serialises model into map form.
  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'date': date.toIso8601String(),
        'feature': feature,
        'durationSec': durationSec,
        'notes': notes,
      };

  /// Converts to domain entity.
  SessionEntity toEntity() => SessionEntity(
        id: id,
        date: date,
        feature: feature,
        durationSec: durationSec,
        notes: notes,
      );
}
