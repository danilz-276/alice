import 'package:vm_log_api/core/vm_log_api_core.dart';
import 'package:vm_log_api/model/vm_log_api_http_call.dart';
import 'package:vm_log_api/ui/calls_list/model/vm_log_api_calls_list_sort_option.dart';
import 'package:vm_log_api/ui/calls_list/widget/vm_log_api_calls_list_screen.dart';
import 'package:vm_log_api/ui/calls_list/widget/vm_log_api_empty_logs_widget.dart';
import 'package:flutter/material.dart';

/// Screen which is hosted in calls list page. It displays HTTP calls. It allows
/// to search call and sort items based on provided criteria.
class AliceInspectorScreen extends StatefulWidget {
  const AliceInspectorScreen({
    super.key,
    required this.aliceCore,
    required this.queryTextEditingController,
    required this.sortOption,
    required this.sortAscending,
    required this.onListItemPressed,
  });

  final AliceCore aliceCore;
  final TextEditingController queryTextEditingController;
  final AliceCallsListSortOption sortOption;
  final bool sortAscending;
  final void Function(AliceHttpCall) onListItemPressed;

  @override
  State<AliceInspectorScreen> createState() => _AliceInspectorScreenState();
}

class _AliceInspectorScreenState extends State<AliceInspectorScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<List<AliceHttpCall>>(
      stream: widget.aliceCore.callsStream,
      builder: (context, AsyncSnapshot<List<AliceHttpCall>> snapshot) {
        final List<AliceHttpCall> calls = List<AliceHttpCall>.from(
          snapshot.data ?? <AliceHttpCall>[],
        );
        final String query = widget.queryTextEditingController.text.trim();
        if (query.isNotEmpty) {
          calls.removeWhere(
            (AliceHttpCall call) =>
                !call.endpoint.toLowerCase().contains(query.toLowerCase()),
          );
        }
        if (calls.isNotEmpty) {
          return AliceCallsListScreen(
            calls: calls,
            sortOption: widget.sortOption,
            sortAscending: widget.sortAscending,
            onListItemClicked: widget.onListItemPressed,
          );
        } else {
          return const AliceEmptyLogsWidget();
        }
      },
    );
  }
}
