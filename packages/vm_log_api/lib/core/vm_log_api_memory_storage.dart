import 'dart:async';

import 'package:vm_log_api/core/vm_log_api_storage.dart';
import 'package:vm_log_api/core/vm_log_api_utils.dart';
import 'package:vm_log_api/model/vm_log_api_http_call.dart';
import 'package:vm_log_api/model/vm_log_api_http_error.dart';
import 'package:vm_log_api/model/vm_log_api_http_response.dart';
import 'package:vm_log_api/utils/num_comparison.dart';
import 'package:collection/collection.dart';
import 'package:rxdart/subjects.dart';

/// Storage which uses memory to store calls data. It's a default storage
/// method.
class VmLogApiMemoryStorage implements VmLogApiStorage {
  VmLogApiMemoryStorage({required this.maxCallsCount})
    : _callsSubject = BehaviorSubject.seeded([]),
      assert(maxCallsCount > 0, 'Max calls count should be greater than 0');
  @override
  final int maxCallsCount;

  /// Subject which stores all HTTP calls.
  final BehaviorSubject<List<VmLogApiHttpCall>> _callsSubject;

  /// Stream which returns all HTTP calls on change.
  @override
  Stream<List<VmLogApiHttpCall>> get callsStream => _callsSubject.stream;

  /// Returns all HTTP calls.
  @override
  List<VmLogApiHttpCall> getCalls() => _callsSubject.value;

  /// Returns stats based on calls.
  @override
  VmLogApiStats getStats() {
    final List<VmLogApiHttpCall> calls = getCalls();

    return (
      total: calls.length,
      successes:
          calls
              .where(
                (VmLogApiHttpCall call) =>
                    (call.response?.status.gte(200) ?? false) &&
                    (call.response?.status.lt(300) ?? false),
              )
              .length,
      redirects:
          calls
              .where(
                (VmLogApiHttpCall call) =>
                    (call.response?.status.gte(300) ?? false) &&
                    (call.response?.status.lt(400) ?? false),
              )
              .length,
      errors:
          calls
              .where(
                (VmLogApiHttpCall call) =>
                    ((call.response?.status.gte(400) ?? false) &&
                        (call.response?.status.lt(600) ?? false)) ||
                    const [-1, 0].contains(call.response?.status),
              )
              .length,
      loading: calls.where((VmLogApiHttpCall call) => call.loading).length,
    );
  }

  /// Adds new call to calls list.
  @override
  void addCall(VmLogApiHttpCall call) {
    final int callsCount = _callsSubject.value.length;
    if (callsCount >= maxCallsCount) {
      final List<VmLogApiHttpCall> originalCalls = _callsSubject.value;
      originalCalls.removeAt(0);
      originalCalls.add(call);

      _callsSubject.add(originalCalls);
    } else {
      _callsSubject.add([..._callsSubject.value, call]);
    }
  }

  /// Adds error to a specific call.
  @override
  void addError(VmLogApiHttpError error, int requestId) {
    final VmLogApiHttpCall? selectedCall = selectCall(requestId);

    if (selectedCall == null) {
      return VmLogApiUtils.log('Selected call is null');
    }

    selectedCall.error = error;
    _callsSubject.add([..._callsSubject.value]);
  }

  /// Adds response to a specific call.
  @override
  void addResponse(VmLogApiHttpResponse response, int requestId) {
    final VmLogApiHttpCall? selectedCall = selectCall(requestId);

    if (selectedCall == null) {
      return VmLogApiUtils.log('Selected call is null');
    }

    selectedCall
      ..loading = false
      ..response = response
      ..duration =
          response.time.millisecondsSinceEpoch -
          (selectedCall.request?.time.millisecondsSinceEpoch ?? 0);

    _callsSubject.add([..._callsSubject.value]);
  }

  /// Removes all calls.
  @override
  void removeCalls() => _callsSubject.add([]);

  /// Searches for call with specific [requestId]. It may return null.
  @override
  VmLogApiHttpCall? selectCall(int requestId) => _callsSubject.value
      .firstWhereOrNull((VmLogApiHttpCall call) => call.id == requestId);
}
