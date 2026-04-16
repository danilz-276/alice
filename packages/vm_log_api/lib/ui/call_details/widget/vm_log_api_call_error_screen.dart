import 'package:vm_log_api/model/vm_log_api_http_call.dart';
import 'package:vm_log_api/model/vm_log_api_translation.dart';
import 'package:vm_log_api/ui/call_details/widget/vm_log_api_call_expandable_list_row.dart';
import 'package:vm_log_api/ui/call_details/widget/vm_log_api_call_list_row.dart';
import 'package:vm_log_api/ui/common/vm_log_api_context_ext.dart';
import 'package:vm_log_api/ui/common/vm_log_api_scroll_behavior.dart';
import 'package:flutter/material.dart';

/// Call error screen which displays info on HTTP call error.
class VmLogApiCallErrorScreen extends StatelessWidget {
  const VmLogApiCallErrorScreen({super.key, required this.call});

  final VmLogApiHttpCall call;

  @override
  Widget build(BuildContext context) {
    if (call.error != null) {
      final dynamic error = call.error?.error;
      final StackTrace? stackTrace = call.error?.stackTrace;
      final String errorText =
          error != null
              ? error.toString()
              : context.i18n(VmLogApiTranslationKey.callErrorScreenErrorEmpty);

      return Container(
        padding: const EdgeInsets.all(6),
        child: ScrollConfiguration(
          behavior: VmLogApiScrollBehavior(),
          child: ListView(
            children: [
              VmLogApiCallListRow(
                name: context.i18n(VmLogApiTranslationKey.callErrorScreenError),
                value: errorText,
              ),
              if (stackTrace != null)
                VmLogApiCallExpandableListRow(
                  name: context.i18n(
                    VmLogApiTranslationKey.callErrorScreenStacktrace,
                  ),
                  value: stackTrace.toString(),
                ),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Text(context.i18n(VmLogApiTranslationKey.callErrorScreenEmpty)),
      );
    }
  }
}
