import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';

class EngagementState {
  /// Null until the first read lands. The buttons render disabled rather than
  /// guessing at zero, which would flash a wrong count and then correct it.
  final Engagement? data;

  final bool failed;

  /// The kind a tap is in flight for, so only that button goes quiet.
  final String? pending;

  const EngagementState({this.data, this.failed = false, this.pending});

  EngagementState copyWith({
    Engagement? data,
    bool? failed,
    String? pending,
    bool clearPending = false,
  }) {
    return EngagementState(
      data: data ?? this.data,
      failed: failed ?? this.failed,
      pending: clearPending ? null : (pending ?? this.pending),
    );
  }
}

/// Follows and hearts on one shop or product.
///
/// The count is never adjusted here: the server answers every tap with the
/// figure it counted, so two people tapping at once cannot leave the screen
/// showing a total nobody has.
class EngagementCubit extends Cubit<EngagementState> with CloseSafeEmit {
  final AppRepositories _repositories;
  final String targetType;
  final String targetId;

  EngagementCubit({
    required this.targetType,
    required this.targetId,
    AppRepositories? repositories,
  }) : _repositories = repositories ?? AppRepositories.instance,
       super(const EngagementState());

  RemoteDataSource? get _remote => _repositories.products.remote;

  Timer? _anchorPoll;
  int _anchorPollAttempts = 0;

  // The chain worker anchors pending marks on a ~10s tick (see
  // internal/service/integrity/worker.go on the server); five tries 6s apart
  // covers that with room to spare. Past that the badge just sits pending
  // until the reader reopens the screen - still honest, this only saves the
  // common case a manual pull-to-refresh.
  static const _anchorPollInterval = Duration(seconds: 6);
  static const _maxAnchorPollAttempts = 5;

  Future<void> load() async {
    final remote = _remote;
    if (remote == null) {
      emit(state.copyWith(failed: true));
      return;
    }
    try {
      final data = await remote.engagement(targetType, targetId);
      emit(state.copyWith(data: data, failed: false));
      _watchAnchor(data);
    } catch (_) {
      emit(state.copyWith(failed: true));
    }
  }

  /// (Re)starts the poll if [data] is a real, still-unanchored mark. Called
  /// after every fetch, so reopening a screen mid-anchor resumes watching it
  /// same as tapping the button just did.
  void _watchAnchor(Engagement data) {
    _anchorPoll?.cancel();
    if (data.anchored || data.anchorStatus.isEmpty) return;
    _anchorPollAttempts = 0;
    _scheduleAnchorPoll();
  }

  void _scheduleAnchorPoll() {
    _anchorPoll = Timer(_anchorPollInterval, () async {
      final remote = _remote;
      if (remote == null || isClosed) return;
      _anchorPollAttempts++;
      try {
        final data = await remote.engagement(targetType, targetId);
        emit(state.copyWith(data: data, failed: false));
        if (!data.anchored && _anchorPollAttempts < _maxAnchorPollAttempts) {
          _scheduleAnchorPoll();
        }
      } catch (_) {
        // A background refresh failing is not the reader's problem; the next
        // manual load() or toggle() will pick the poll back up.
      }
    });
  }

  /// Adds the mark or takes it back. Rethrows so the screen can say what went
  /// wrong rather than the button silently springing back.
  Future<void> toggle(String kind) async {
    final remote = _remote;
    if (remote == null) throw StateError('no remote data source');
    emit(state.copyWith(pending: kind));
    try {
      final updated = await remote.toggleEngagement(
        targetType: targetType,
        targetId: targetId,
        kind: kind,
      );
      emit(state.copyWith(data: updated, failed: false, clearPending: true));
      _watchAnchor(updated);
    } catch (_) {
      emit(state.copyWith(clearPending: true));
      rethrow;
    }
  }

  @override
  Future<void> close() {
    _anchorPoll?.cancel();
    return super.close();
  }
}
