/// State controller driving the AR vocabulary experience.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/errors/failure.dart';
import '../../../data/repositories/content_repository.dart';
import '../../../data/repositories/session_repository.dart';
import '../../../domain/entities/session_entity.dart';
import '../../../domain/entities/vocab_entity.dart';
import '../../../domain/usecases/log_session_event.dart';

/// Describes the AR vocabulary state.
class ArVocabState {
  /// Builds the state with content, selection, and fallback flag.
  const ArVocabState({
    required this.items,
    required this.currentIndex,
    required this.isArSupported,
    required this.isLoading,
    this.failure,
  });

  /// Loaded vocabulary items.
  final List<VocabEntity> items;

  /// Index of the currently selected item.
  final int currentIndex;

  /// Whether AR mode is available.
  final bool isArSupported;

  /// Whether data is loading.
  final bool isLoading;

  /// Optional failure message.
  final Failure? failure;

  /// Returns the current vocabulary item.
  VocabEntity? get current => items.isEmpty ? null : items[currentIndex];

  /// Copies state with overrides.
  ArVocabState copyWith({
    List<VocabEntity>? items,
    int? currentIndex,
    bool? isArSupported,
    bool? isLoading,
    Failure? failure,
  }) {
    return ArVocabState(
      items: items ?? this.items,
      currentIndex: currentIndex ?? this.currentIndex,
      isArSupported: isArSupported ?? this.isArSupported,
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
    );
  }
}

/// Controller managing AR vocabulary logic.
class ArVocabController extends StateNotifier<ArVocabState> {
  /// Creates the controller with dependencies.
  ArVocabController(this._contentRepository, this._logSession)
      : super(const ArVocabState(items: [], currentIndex: 0, isArSupported: false, isLoading: true)) {
    _initialise();
  }

  final ContentRepository _contentRepository;
  final LogSessionEvent _logSession;

  Future<void> _initialise() async {
    state = state.copyWith(isLoading: true);
    final permission = await Permission.camera.request();
    final arSupported = permission.isGranted;
    final packs = await _contentRepository.loadLocalPacks();
    packs.fold(
      (failure) => state = state.copyWith(isLoading: false, failure: failure),
      (values) {
        final items = values.expand((pack) => pack.items).toList();
        state = state.copyWith(items: items, isArSupported: arSupported, isLoading: false, currentIndex: 0);
      },
    );
  }

  /// Moves to the next vocabulary item.
  void next() {
    if (state.items.isEmpty) return;
    final index = (state.currentIndex + 1) % state.items.length;
    state = state.copyWith(currentIndex: index);
  }

  /// Moves to the previous vocabulary item.
  void previous() {
    if (state.items.isEmpty) return;
    final index = (state.currentIndex - 1) < 0 ? state.items.length - 1 : state.currentIndex - 1;
    state = state.copyWith(currentIndex: index);
  }

  /// Logs a viewing session for analytics.
  Future<void> logView() async {
    final current = state.current;
    if (current == null) return;
    await _logSession(
      SessionEntity(
        id: '',
        date: DateTime.now().toUtc(),
        feature: 'ar_vocab:${current.id}',
        durationSec: 60,
        notes: 'view',
      ),
    );
  }
}

/// Provides the controller to the widget tree.
final arVocabControllerProvider = StateNotifierProvider<ArVocabController, ArVocabState>((ref) {
  final contentRepository = ref.read(contentRepositoryProvider);
  final sessionRepository = ref.read(sessionRepositoryProvider);
  final logger = LogSessionEvent(sessionRepository);
  return ArVocabController(contentRepository, logger);
});
