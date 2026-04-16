import 'package:vm_log_api/model/vm_log_api_http_call.dart';
import 'dart:async' show FutureOr;

import 'package:vm_log_api/model/vm_log_api_http_error.dart';
import 'package:vm_log_api/model/vm_log_api_http_response.dart';

/// Definition of call stats.
typedef VmLogApiStats =
    ({int total, int successes, int redirects, int errors, int loading});

/// Definition of storage
abstract interface class VmLogApiStorage {
  /// Stream which returns all HTTP calls on change.
  abstract final Stream<List<VmLogApiHttpCall>> callsStream;

  /// Max calls number which should be stored.
  abstract final int maxCallsCount;

  /// Returns all HTTP calls.
  List<VmLogApiHttpCall> getCalls();

  /// Returns stats based on calls.
  VmLogApiStats getStats();

  /// Searches for call with specific [requestId]. It may return null.
  VmLogApiHttpCall? selectCall(int requestId);

  /// Adds new call to calls list.
  FutureOr<void> addCall(VmLogApiHttpCall call);

  /// Adds error to a specific call.
  FutureOr<void> addError(VmLogApiHttpError error, int requestId);

  /// Adds response to a specific call.
  FutureOr<void> addResponse(VmLogApiHttpResponse response, int requestId);

  /// Removes all calls.
  FutureOr<void> removeCalls();
}
