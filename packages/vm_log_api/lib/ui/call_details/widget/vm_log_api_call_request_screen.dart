import 'package:vm_log_api/helper/vm_log_api_conversion_helper.dart';
import 'package:vm_log_api/model/vm_log_api_form_data_file.dart';
import 'package:vm_log_api/model/vm_log_api_from_data_field.dart';
import 'package:vm_log_api/model/vm_log_api_http_call.dart';
import 'package:vm_log_api/model/vm_log_api_translation.dart';
import 'package:vm_log_api/ui/call_details/widget/vm_log_api_call_list_row.dart';
import 'package:vm_log_api/ui/common/vm_log_api_context_ext.dart';
import 'package:vm_log_api/utils/vm_log_api_parser.dart';
import 'package:vm_log_api/ui/common/vm_log_api_scroll_behavior.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Screen which displays information about call request: content, transfer,
/// headers.
class VmLogApiCallRequestScreen extends StatelessWidget {
  final VmLogApiHttpCall call;

  const VmLogApiCallRequestScreen({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [
      VmLogApiCallListRow(
        name: context.i18n(VmLogApiTranslationKey.callRequestStarted),
        value: call.request?.time.toString(),
      ),
      VmLogApiCallListRow(
        name: context.i18n(VmLogApiTranslationKey.callRequestBytesSent),
        value: VmLogApiConversionHelper.formatBytes(call.request?.size ?? 0),
      ),
      VmLogApiCallListRow(
        name: context.i18n(VmLogApiTranslationKey.callRequestContentType),
        value: VmLogApiParser.getContentType(
          context: context,
          headers: call.request?.headers,
        ),
      ),
    ];

    rows.add(
      VmLogApiCallListRow(
        name: context.i18n(VmLogApiTranslationKey.callRequestBody),
        value: _getBodyContent(context: context),
      ),
    );

    final List<VmLogApiFormDataField>? formDataFields =
        call.request?.formDataFields;
    if (formDataFields?.isNotEmpty ?? false) {
      rows.add(
        VmLogApiCallListRow(
          name: context.i18n(VmLogApiTranslationKey.callRequestFormDataFields),
          value: '',
        ),
      );
      rows.addAll([
        for (final VmLogApiFormDataField field in formDataFields!)
          VmLogApiCallListRow(name: '   • ${field.name}:', value: field.value),
      ]);
    }

    final List<VmLogApiFormDataFile>? formDataFiles = call.request!.formDataFiles;
    if (formDataFiles?.isNotEmpty ?? false) {
      rows.add(
        VmLogApiCallListRow(
          name: context.i18n(VmLogApiTranslationKey.callRequestFormDataFiles),
          value: '',
        ),
      );
      rows.addAll([
        for (final VmLogApiFormDataFile file in formDataFiles!)
          VmLogApiCallListRow(
            name: '   • ${file.fileName}:',
            value: '${file.contentType} / ${file.length} B',
          ),
      ]);
    }

    final Map<String, dynamic>? headers = call.request?.headers;
    final String headersContent =
        headers?.isEmpty ?? true
            ? context.i18n(VmLogApiTranslationKey.callRequestHeadersEmpty)
            : '';
    rows.add(
      VmLogApiCallListRow(
        name: context.i18n(VmLogApiTranslationKey.callRequestHeaders),
        value: headersContent,
      ),
    );
    rows.addAll([
      for (final MapEntry<String, dynamic> header in headers?.entries ?? [])
        VmLogApiCallListRow(
          name: '   • ${header.key}:',
          value: header.value.toString(),
        ),
    ]);

    final Map<String, dynamic>? queryParameters = call.request?.queryParameters;
    final String queryParametersContent =
        queryParameters?.isEmpty ?? true
            ? context.i18n(VmLogApiTranslationKey.callRequestQueryParametersEmpty)
            : '';
    rows.add(
      VmLogApiCallListRow(
        name: context.i18n(VmLogApiTranslationKey.callRequestQueryParameters),
        value: queryParametersContent,
      ),
    );
    rows.addAll([
      for (final MapEntry<String, dynamic> queryParam
          in queryParameters?.entries ?? [])
        VmLogApiCallListRow(
          name: '   • ${queryParam.key}:',
          value: queryParam.value.toString(),
        ),
    ]);

    return Container(
      padding: const EdgeInsets.all(6),
      child: ScrollConfiguration(
        behavior: VmLogApiScrollBehavior(),
        child: ListView(children: rows),
      ),
    );
  }

  /// Returns body content formatted.
  String _getBodyContent({required BuildContext context}) {
    final dynamic body = call.request?.body;
    return body != null
        ? VmLogApiParser.formatBody(
          context: context,
          body: body,
          contentType: VmLogApiParser.getContentType(
            context: context,
            headers: call.request?.headers,
          ),
        )
        : context.i18n(VmLogApiTranslationKey.callRequestBodyEmpty);
  }
}
