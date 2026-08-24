import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';

class ActivityState {
  final List<ActivityEvent> events;
  final bool loading;
  final bool failed;

  /// False once a page comes back short, so the list stops asking for more.
  final bool hasMore;

  /// Verifications the reader has asked for, by event id.
  final Map<String, ActivityVerification> checked;

  /// The entry a verification is in flight for.
  final String? verifying;

  const ActivityState({
    this.events = const [],
    this.loading = false,
    this.failed = false,
    this.hasMore = true,
    this.checked = const {},
    this.verifying,
  });

  ActivityState copyWith({
    List<ActivityEvent>? events,
    bool? loading,
    bool? failed,
    bool? hasMore,
    Map<String, ActivityVerification>? checked,
    String? verifying,
    bool clearVerifying = false,
  }) {
    return ActivityState(
      events: events ?? this.events,
      loading: loading ?? this.loading,
      failed: failed ?? this.failed,
      hasMore: hasMore ?? this.hasMore,
      checked: checked ?? this.checked,
      verifying: clearVerifying ? null : (verifying ?? this.verifying),
    );
  }
}

/// The reader's own trail: every like, follow, comment and check they made.
///
/// A page that fails is reported rather than dropped. An activity log that
/// quietly shows less than happened is worse than one that says it is broken,
/// because the reader cannot tell the difference from having done nothing.
class ActivityCubit extends Cubit<ActivityState> with CloseSafeEmit {
  static const pageSize = 20;

  final AppRepositories _repositories;
  int _page = 1;

  ActivityCubit({AppRepositories? repositories})
    : _repositories = repositories ?? AppRepositories.instance,
      super(const ActivityState());

  RemoteDataSource? get _remote => _repositories.products.remote;

  Future<void> load() async {
    _page = 1;
    final remote = _remote;
    if (remote == null) {
      emit(state.copyWith(failed: true, loading: false));
      return;
    }
    emit(state.copyWith(loading: true, failed: false));
    try {
      final events = await remote.myActivity(page: 1, pageSize: pageSize);
      emit(
        state.copyWith(
          events: events,
          loading: false,
          failed: false,
          hasMore: events.length == pageSize,
          checked: const {},
        ),
      );
    } catch (_) {
      emit(state.copyWith(loading: false, failed: true));
    }
  }

  Future<void> loadMore() async {
    final remote = _remote;
    if (remote == null || state.loading || !state.hasMore) return;
    emit(state.copyWith(loading: true));
    try {
      final next = await remote.myActivity(page: _page + 1, pageSize: pageSize);
      _page++;
      emit(
        state.copyWith(
          events: [...state.events, ...next],
          loading: false,
          hasMore: next.length == pageSize,
        ),
      );
    } catch (_) {
      // The pages already read stay on screen: losing them would punish the
      // reader for scrolling.
      emit(state.copyWith(loading: false, failed: true));
    }
  }

  /// Re-checks one entry. Rethrows so the screen can say the check itself
  /// failed, which is a different thing from the entry failing its check.
  Future<void> verify(String eventId) async {
    final remote = _remote;
    if (remote == null) throw StateError('no remote data source');
    emit(state.copyWith(verifying: eventId));
    try {
      final result = await remote.verifyActivityEvent(eventId);
      emit(
        state.copyWith(
          checked: {...state.checked, eventId: result},
          clearVerifying: true,
        ),
      );
    } catch (_) {
      emit(state.copyWith(clearVerifying: true));
      rethrow;
    }
  }
}
