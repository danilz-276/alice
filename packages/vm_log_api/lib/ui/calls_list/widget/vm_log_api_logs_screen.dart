import 'package:vm_log_api/core/vm_log_api_logger.dart';
import 'package:vm_log_api/ui/calls_list/widget/vm_log_api_empty_logs_widget.dart';
import 'package:vm_log_api/ui/calls_list/widget/vm_log_api_log_list_widget.dart';
import 'package:vm_log_api/ui/calls_list/widget/vm_log_api_raw_log_list_widger.dart';
import 'package:flutter/material.dart';

/// Screen hosted in calls list which displays logs list.
class VmLogApiLogsScreen extends StatelessWidget {
  const VmLogApiLogsScreen({
    super.key,
    required this.scrollController,
    this.logger,
    this.isAndroidRawLogsEnabled = false,
  });

  final ScrollController scrollController;
  final VmLogApiLogger? logger;
  final bool isAndroidRawLogsEnabled;

  @override
  Widget build(BuildContext context) =>
      logger != null
          ? isAndroidRawLogsEnabled
              ? VmLogApiRawLogListWidget(
                scrollController: scrollController,
                getRawLogs: logger?.getAndroidRawLogs(),
              )
              : VmLogApiLogListWidget(
                logsStream: logger?.logsStream,
                scrollController: scrollController,
              )
          : const VmLogApiEmptyLogsWidget();
}
