import 'package:vm_log_api/model/vm_log_api_http_call.dart';
import 'package:vm_log_api/ui/calls_list/model/vm_log_api_calls_list_sort_option.dart';
import 'package:vm_log_api/ui/calls_list/widget/vm_log_api_call_list_item_widget.dart';
import 'package:vm_log_api/ui/common/vm_log_api_scroll_behavior.dart';
import 'package:flutter/material.dart';

/// Widget which displays calls list. It's hosted in tab in calls list page.
class AliceCallsListScreen extends StatelessWidget {
  const AliceCallsListScreen({
    super.key,
    required this.calls,
    this.sortOption,
    this.sortAscending = false,
    required this.onListItemClicked,
  });

  final List<AliceHttpCall> calls;
  final AliceCallsListSortOption? sortOption;
  final bool sortAscending;
  final void Function(AliceHttpCall) onListItemClicked;

  /// Returns sorted copy of calls based on [sortOption] and [sortAscending].
  List<AliceHttpCall> _buildSortedCalls() {
    final List<AliceHttpCall> sortedCalls = List<AliceHttpCall>.from(calls);

    int sortByResponseTime(AliceHttpCall call1, AliceHttpCall call2) =>
        (call1.response?.time ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(
              call2.response?.time ?? DateTime.fromMillisecondsSinceEpoch(0),
            );

    int sortByResponseCode(AliceHttpCall call1, AliceHttpCall call2) =>
        (call1.response?.status ?? -1).compareTo(call2.response?.status ?? -1);

    int sortByResponseSize(AliceHttpCall call1, AliceHttpCall call2) =>
        (call1.response?.size ?? -1).compareTo(call2.response?.size ?? -1);

    int compare(
      AliceHttpCall call1,
      AliceHttpCall call2,
    ) => switch (sortOption) {
      AliceCallsListSortOption.time => call1.createdTime.compareTo(
        call2.createdTime,
      ),
      AliceCallsListSortOption.responseTime => sortByResponseTime(call1, call2),
      AliceCallsListSortOption.responseCode => sortByResponseCode(call1, call2),
      AliceCallsListSortOption.responseSize => sortByResponseSize(call1, call2),
      AliceCallsListSortOption.endpoint => call1.endpoint.compareTo(
        call2.endpoint,
      ),
      _ => call1.createdTime.compareTo(call2.createdTime),
    };

    sortedCalls.sort((AliceHttpCall call1, AliceHttpCall call2) {
      final int result = compare(call1, call2);
      return sortAscending ? result : -result;
    });

    return sortedCalls;
  }

  @override
  Widget build(BuildContext context) {
    final List<AliceHttpCall> sortedCalls = _buildSortedCalls();

    return ScrollConfiguration(
      behavior: AliceScrollBehavior(),
      child: ListView.builder(
        itemCount: sortedCalls.length,
        itemBuilder:
            (_, int index) =>
                AliceCallListItemWidget(sortedCalls[index], onListItemClicked),
      ),
    );
  }
}
