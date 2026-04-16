import 'package:vm_log_api/core/vm_log_api_core.dart';
import 'package:vm_log_api/helper/vm_log_api_conversion_helper.dart';
import 'package:vm_log_api/model/vm_log_api_http_call.dart';
import 'package:vm_log_api/model/vm_log_api_translation.dart';
import 'package:vm_log_api/ui/common/vm_log_api_context_ext.dart';
import 'package:vm_log_api/ui/common/vm_log_api_page.dart';
import 'package:vm_log_api/ui/widget/vm_log_api_stats_row.dart';
import 'package:vm_log_api/utils/num_comparison.dart';
import 'package:flutter/material.dart';

/// General stats page for currently caught HTTP calls.
class VmLogApiStatsPage extends StatelessWidget {
  final VmLogApiCore core;

  const VmLogApiStatsPage(this.core, {super.key});

  @override
  Widget build(BuildContext context) {
    return VmLogApiPage(
      core: core,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${context.i18n(VmLogApiTranslationKey.alice)} - '
            '${context.i18n(VmLogApiTranslationKey.statsTitle)}',
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(8),
          child: ListView(
            children: [
              VmLogApiStatsRow(
                context.i18n(VmLogApiTranslationKey.statsTotalRequests),
                '${_getTotalRequests()}',
              ),
              VmLogApiStatsRow(
                context.i18n(VmLogApiTranslationKey.statsPendingRequests),
                '${_getPendingRequests()}',
              ),
              VmLogApiStatsRow(
                context.i18n(VmLogApiTranslationKey.statsSuccessRequests),
                '${_getSuccessRequests()}',
              ),
              VmLogApiStatsRow(
                context.i18n(VmLogApiTranslationKey.statsRedirectionRequests),
                '${_getRedirectionRequests()}',
              ),
              VmLogApiStatsRow(
                context.i18n(VmLogApiTranslationKey.statsErrorRequests),
                '${_getErrorRequests()}',
              ),
              VmLogApiStatsRow(
                context.i18n(VmLogApiTranslationKey.statsBytesSent),
                VmLogApiConversionHelper.formatBytes(_getBytesSent()),
              ),
              VmLogApiStatsRow(
                context.i18n(VmLogApiTranslationKey.statsBytesReceived),
                VmLogApiConversionHelper.formatBytes(_getBytesReceived()),
              ),
              VmLogApiStatsRow(
                context.i18n(VmLogApiTranslationKey.statsAverageRequestTime),
                VmLogApiConversionHelper.formatTime(_getAverageRequestTime()),
              ),
              VmLogApiStatsRow(
                context.i18n(VmLogApiTranslationKey.statsMaxRequestTime),
                VmLogApiConversionHelper.formatTime(_getMaxRequestTime()),
              ),
              VmLogApiStatsRow(
                context.i18n(VmLogApiTranslationKey.statsMinRequestTime),
                VmLogApiConversionHelper.formatTime(_getMinRequestTime()),
              ),
              VmLogApiStatsRow(
                context.i18n(VmLogApiTranslationKey.statsGetRequests),
                '${_getRequests('GET')} ',
              ),
              VmLogApiStatsRow(
                context.i18n(VmLogApiTranslationKey.statsPostRequests),
                '${_getRequests('POST')} ',
              ),
              VmLogApiStatsRow(
                context.i18n(VmLogApiTranslationKey.statsDeleteRequests),
                '${_getRequests('DELETE')} ',
              ),
              VmLogApiStatsRow(
                context.i18n(VmLogApiTranslationKey.statsPutRequests),
                '${_getRequests('PUT')} ',
              ),
              VmLogApiStatsRow(
                context.i18n(VmLogApiTranslationKey.statsPatchRequests),
                '${_getRequests('PATCH')} ',
              ),
              VmLogApiStatsRow(
                context.i18n(VmLogApiTranslationKey.statsSecuredRequests),
                '${_getSecuredRequests()}',
              ),
              VmLogApiStatsRow(
                context.i18n(VmLogApiTranslationKey.statsUnsecuredRequests),
                '${_getUnsecuredRequests()}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns count of requests.
  int _getTotalRequests() => _calls.length;

  /// Returns count of success requests.
  int _getSuccessRequests() =>
      _calls
          .where(
            (VmLogApiHttpCall call) =>
                (call.response?.status.gte(200) ?? false) &&
                (call.response?.status.lt(300) ?? false),
          )
          .toList()
          .length;

  /// Returns count of redirection requests.
  int _getRedirectionRequests() =>
      _calls
          .where(
            (VmLogApiHttpCall call) =>
                (call.response?.status.gte(300) ?? false) &&
                (call.response?.status.lt(400) ?? false),
          )
          .toList()
          .length;

  /// Returns count of error requests.
  int _getErrorRequests() =>
      _calls
          .where(
            (VmLogApiHttpCall call) =>
                (call.response?.status.gte(400) ?? false) &&
                    (call.response?.status.lt(600) ?? false) ||
                const [-1, 0].contains(call.response?.status),
          )
          .toList()
          .length;

  /// Returns count of pending requests.
  int _getPendingRequests() =>
      _calls.where((VmLogApiHttpCall call) => call.loading).toList().length;

  /// Returns total bytes sent count.
  int _getBytesSent() => _calls.fold(
    0,
    (int sum, VmLogApiHttpCall call) => sum + (call.request?.size ?? 0),
  );

  /// Returns total bytes received count.
  int _getBytesReceived() => _calls.fold(
    0,
    (int sum, VmLogApiHttpCall call) => sum + (call.response?.size ?? 0),
  );

  /// Returns average request time of all calls.
  int _getAverageRequestTime() {
    int requestTimeSum = 0;
    int requestsWithDurationCount = 0;
    for (final VmLogApiHttpCall call in _calls) {
      if (call.duration != 0) {
        requestTimeSum = call.duration;
        requestsWithDurationCount++;
      }
    }
    if (requestTimeSum == 0) {
      return 0;
    }
    return requestTimeSum ~/ requestsWithDurationCount;
  }

  /// Returns max request time of all calls.
  int _getMaxRequestTime() {
    int maxRequestTime = 0;
    for (final VmLogApiHttpCall call in _calls) {
      if (call.duration > maxRequestTime) {
        maxRequestTime = call.duration;
      }
    }
    return maxRequestTime;
  }

  /// Returns min request time of all calls.
  int _getMinRequestTime() {
    int minRequestTime = 10000000;
    if (_calls.isEmpty) {
      minRequestTime = 0;
    } else {
      for (final VmLogApiHttpCall call in _calls) {
        if (call.duration != 0 && call.duration < minRequestTime) {
          minRequestTime = call.duration;
        }
      }
    }
    return minRequestTime;
  }

  /// Get all requests with [requestType].
  int _getRequests(String requestType) =>
      _calls.where((call) => call.method == requestType).toList().length;

  /// Get all secured requests count.
  int _getSecuredRequests() =>
      _calls.where((call) => call.secure).toList().length;

  /// Get unsecured requests count.
  int _getUnsecuredRequests() =>
      _calls.where((call) => !call.secure).toList().length;

  /// Get all calls from VmLogApi.
  List<VmLogApiHttpCall> get _calls => core.getCalls();
}
