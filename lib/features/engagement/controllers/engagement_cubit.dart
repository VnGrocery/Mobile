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

  Future<void> load() async {
    final remote = _remote;
    if (remote == null) {
      emit(state.copyWith(failed: true));
      return;
    }
    try {
      emit(
        state.copyWith(
          data: await remote.engagement(targetType, targetId),
          failed: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(failed: true));
    }
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
    } catch (_) {
      emit(state.copyWith(clearPending: true));
      rethrow;
    }
  }
}
