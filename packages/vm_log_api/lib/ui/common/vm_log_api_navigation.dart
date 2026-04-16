import 'package:vm_log_api/core/vm_log_api_core.dart';
import 'package:vm_log_api/model/vm_log_api_http_call.dart';
import 'package:vm_log_api/ui/call_details/page/vm_log_api_call_details_page.dart';
import 'package:vm_log_api/ui/calls_list/page/vm_log_api_calls_list_page.dart';
import 'package:vm_log_api/ui/stats/vm_log_api_stats_page.dart';
import 'package:flutter/material.dart';

/// Simple navigation helper class for VmLogApi.
class VmLogApiNavigation {
  /// Builds calls list page widget for app routers.
  static Widget callsListPage({required VmLogApiCore core}) =>
      VmLogApiCallsListPage(core: core);

  /// Navigates to calls list page.
  static Future<void> navigateToCallsList({required VmLogApiCore core}) {
    return _navigateToPage(core: core, child: callsListPage(core: core));
  }

  /// Navigates to call details page.
  static Future<void> navigateToCallDetails({
    required VmLogApiHttpCall call,
    required VmLogApiCore core,
    BuildContext? context,
  }) {
    return _navigateToPage(
      core: core,
      context: context,
      child: VmLogApiCallDetailsPage(call: call, core: core),
    );
  }

  /// Navigates to stats page.
  static Future<void> navigateToStats({
    required VmLogApiCore core,
    BuildContext? context,
  }) {
    return _navigateToPage(
      core: core,
      context: context,
      child: VmLogApiStatsPage(core),
    );
  }

  /// Common helper method which checks whether context is available for
  /// navigation and navigates to a specific page.
  static Future<void> _navigateToPage({
    required VmLogApiCore core,
    BuildContext? context,
    required Widget child,
  }) {
    final navigationContext = context ?? core.getContext();
    if (navigationContext == null) {
      throw StateError("Context is null in VmLogApiCore.");
    }
    return Navigator.push<void>(
      navigationContext,
      MaterialPageRoute(builder: (_) => child),
    );
  }
}
