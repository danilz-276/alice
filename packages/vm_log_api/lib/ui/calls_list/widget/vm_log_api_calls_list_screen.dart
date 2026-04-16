import 'package:vm_log_api/model/vm_log_api_http_call.dart';
import 'package:vm_log_api/ui/calls_list/model/vm_log_api_calls_list_sort_option.dart';
import 'package:vm_log_api/ui/calls_list/widget/vm_log_api_call_list_item_widget.dart';
import 'package:vm_log_api/ui/common/vm_log_api_scroll_behavior.dart';
import 'package:flutter/material.dart';

/// Widget which displays calls list. It's hosted in tab in calls list page.
class VmLogApiCallsListScreen extends StatelessWidget {
  const VmLogApiCallsListScreen({
    super.key,
    required this.calls,
    this.sortOption,
    this.sortAscending = false,
    required this.onListItemClicked,
  });

  final List<VmLogApiHttpCall> calls;
  final VmLogApiCallsListSortOption? sortOption;
  final bool sortAscending;
  final void Function(VmLogApiHttpCall) onListItemClicked;

  /// Returns sorted copy of calls based on [sortOption] and [sortAscending].
  List<VmLogApiHttpCall> _buildSortedCalls() {
    final List<VmLogApiHttpCall> sortedCalls = List<VmLogApiHttpCall>.from(calls);

    int sortByResponseTime(VmLogApiHttpCall call1, VmLogApiHttpCall call2) =>
        (call1.response?.time ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(
              call2.response?.time ?? DateTime.fromMillisecondsSinceEpoch(0),
            );

    int sortByResponseCode(VmLogApiHttpCall call1, VmLogApiHttpCall call2) =>
        (call1.response?.status ?? -1).compareTo(call2.response?.status ?? -1);

    int sortByResponseSize(VmLogApiHttpCall call1, VmLogApiHttpCall call2) =>
        (call1.response?.size ?? -1).compareTo(call2.response?.size ?? -1);

    int compare(
      VmLogApiHttpCall call1,
      VmLogApiHttpCall call2,
    ) => switch (sortOption) {
      VmLogApiCallsListSortOption.time => call1.createdTime.compareTo(
        call2.createdTime,
      ),
      VmLogApiCallsListSortOption.responseTime => sortByResponseTime(call1, call2),
      VmLogApiCallsListSortOption.responseCode => sortByResponseCode(call1, call2),
      VmLogApiCallsListSortOption.responseSize => sortByResponseSize(call1, call2),
      VmLogApiCallsListSortOption.endpoint => call1.endpoint.compareTo(
        call2.endpoint,
      ),
      _ => call1.createdTime.compareTo(call2.createdTime),
    };

    sortedCalls.sort((VmLogApiHttpCall call1, VmLogApiHttpCall call2) {
      final int result = compare(call1, call2);
      return sortAscending ? result : -result;
    });

    return sortedCalls;
  }

  @override
  Widget build(BuildContext context) {
    final List<VmLogApiHttpCall> sortedCalls = _buildSortedCalls();

    return ScrollConfiguration(
      behavior: VmLogApiScrollBehavior(),
      child: ListView.builder(
        itemCount: sortedCalls.length,
        itemBuilder:
            (_, int index) =>
                VmLogApiCallListItemWidget(sortedCalls[index], onListItemClicked),
      ),
    );
  }
}
