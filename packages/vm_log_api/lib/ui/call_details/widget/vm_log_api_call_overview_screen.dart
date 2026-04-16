import 'package:vm_log_api/helper/vm_log_api_conversion_helper.dart';
import 'package:vm_log_api/model/vm_log_api_http_call.dart';
import 'package:vm_log_api/model/vm_log_api_translation.dart';
import 'package:vm_log_api/ui/call_details/widget/vm_log_api_call_list_row.dart';
import 'package:vm_log_api/ui/common/vm_log_api_context_ext.dart';
import 'package:vm_log_api/ui/common/vm_log_api_scroll_behavior.dart';
import 'package:flutter/material.dart';

/// Screen which displays call overview data, for example method, server.
class VmLogApiCallOverviewScreen extends StatelessWidget {
  final VmLogApiHttpCall call;

  const VmLogApiCallOverviewScreen({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      child: ScrollConfiguration(
        behavior: VmLogApiScrollBehavior(),
        child: ListView(
          children: [
            VmLogApiCallListRow(
              name: context.i18n(VmLogApiTranslationKey.callOverviewMethod),
              value: call.method,
            ),
            VmLogApiCallListRow(
              name: context.i18n(VmLogApiTranslationKey.callOverviewServer),
              value: call.server,
            ),
            VmLogApiCallListRow(
              name: context.i18n(VmLogApiTranslationKey.callOverviewEndpoint),
              value: call.endpoint,
            ),
            VmLogApiCallListRow(
              name: context.i18n(VmLogApiTranslationKey.callOverviewStarted),
              value: call.request?.time.toString(),
            ),
            VmLogApiCallListRow(
              name: context.i18n(VmLogApiTranslationKey.callOverviewFinished),
              value: call.response?.time.toString(),
            ),
            VmLogApiCallListRow(
              name: context.i18n(VmLogApiTranslationKey.callOverviewDuration),
              value: VmLogApiConversionHelper.formatTime(call.duration),
            ),
            VmLogApiCallListRow(
              name: context.i18n(VmLogApiTranslationKey.callOverviewBytesSent),
              value: VmLogApiConversionHelper.formatBytes(call.request?.size ?? 0),
            ),
            VmLogApiCallListRow(
              name: context.i18n(VmLogApiTranslationKey.callOverviewBytesReceived),
              value: VmLogApiConversionHelper.formatBytes(
                call.response?.size ?? 0,
              ),
            ),
            VmLogApiCallListRow(
              name: context.i18n(VmLogApiTranslationKey.callOverviewClient),
              value: call.client,
            ),
            VmLogApiCallListRow(
              name: context.i18n(VmLogApiTranslationKey.callOverviewSecure),
              value: call.secure.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
