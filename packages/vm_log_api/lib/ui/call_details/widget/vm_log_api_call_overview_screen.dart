import 'package:vm_log_api/helper/vm_log_api_conversion_helper.dart';
import 'package:vm_log_api/model/vm_log_api_http_call.dart';
import 'package:vm_log_api/model/vm_log_api_translation.dart';
import 'package:vm_log_api/ui/call_details/widget/vm_log_api_call_list_row.dart';
import 'package:vm_log_api/ui/common/vm_log_api_context_ext.dart';
import 'package:vm_log_api/ui/common/vm_log_api_scroll_behavior.dart';
import 'package:flutter/material.dart';

/// Screen which displays call overview data, for example method, server.
class AliceCallOverviewScreen extends StatelessWidget {
  final AliceHttpCall call;

  const AliceCallOverviewScreen({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      child: ScrollConfiguration(
        behavior: AliceScrollBehavior(),
        child: ListView(
          children: [
            AliceCallListRow(
              name: context.i18n(AliceTranslationKey.callOverviewMethod),
              value: call.method,
            ),
            AliceCallListRow(
              name: context.i18n(AliceTranslationKey.callOverviewServer),
              value: call.server,
            ),
            AliceCallListRow(
              name: context.i18n(AliceTranslationKey.callOverviewEndpoint),
              value: call.endpoint,
            ),
            AliceCallListRow(
              name: context.i18n(AliceTranslationKey.callOverviewStarted),
              value: call.request?.time.toString(),
            ),
            AliceCallListRow(
              name: context.i18n(AliceTranslationKey.callOverviewFinished),
              value: call.response?.time.toString(),
            ),
            AliceCallListRow(
              name: context.i18n(AliceTranslationKey.callOverviewDuration),
              value: AliceConversionHelper.formatTime(call.duration),
            ),
            AliceCallListRow(
              name: context.i18n(AliceTranslationKey.callOverviewBytesSent),
              value: AliceConversionHelper.formatBytes(call.request?.size ?? 0),
            ),
            AliceCallListRow(
              name: context.i18n(AliceTranslationKey.callOverviewBytesReceived),
              value: AliceConversionHelper.formatBytes(
                call.response?.size ?? 0,
              ),
            ),
            AliceCallListRow(
              name: context.i18n(AliceTranslationKey.callOverviewClient),
              value: call.client,
            ),
            AliceCallListRow(
              name: context.i18n(AliceTranslationKey.callOverviewSecure),
              value: call.secure.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
