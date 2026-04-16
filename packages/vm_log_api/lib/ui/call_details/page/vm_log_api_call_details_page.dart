// ignore_for_file: use_build_context_synchronously

import 'package:vm_log_api/core/vm_log_api_core.dart';
import 'package:vm_log_api/helper/vm_log_api_export_helper.dart';
import 'package:vm_log_api/model/vm_log_api_http_call.dart';
import 'package:vm_log_api/model/vm_log_api_translation.dart';
import 'package:vm_log_api/ui/call_details/model/vm_log_api_call_details_tab.dart';
import 'package:vm_log_api/ui/call_details/widget/vm_log_api_call_error_screen.dart';
import 'package:vm_log_api/ui/call_details/widget/vm_log_api_call_overview_screen.dart';
import 'package:vm_log_api/ui/call_details/widget/vm_log_api_call_request_screen.dart';
import 'package:vm_log_api/ui/call_details/widget/vm_log_api_call_response_screen.dart';
import 'package:vm_log_api/ui/common/vm_log_api_context_ext.dart';
import 'package:vm_log_api/ui/common/vm_log_api_page.dart';
import 'package:vm_log_api/ui/common/vm_log_api_theme.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';

/// Call details page which displays 4 tabs: overview, request, response, error.
class VmLogApiCallDetailsPage extends StatefulWidget {
  final VmLogApiHttpCall call;
  final VmLogApiCore core;

  const VmLogApiCallDetailsPage({
    required this.call,
    required this.core,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _VmLogApiCallDetailsPageState();
}

/// State of call details page.
class _VmLogApiCallDetailsPageState extends State<VmLogApiCallDetailsPage>
    with SingleTickerProviderStateMixin {
  VmLogApiHttpCall get call => widget.call;

  @override
  Widget build(BuildContext context) {
    return VmLogApiPage(
      core: widget.core,
      child: StreamBuilder<List<VmLogApiHttpCall>>(
        stream: widget.core.callsStream,
        initialData: [widget.call],
        builder: (context, AsyncSnapshot<List<VmLogApiHttpCall>> callsSnapshot) {
          if (callsSnapshot.hasData && !callsSnapshot.hasError) {
            final VmLogApiHttpCall? call = callsSnapshot.data?.firstWhereOrNull(
              (VmLogApiHttpCall snapshotCall) => snapshotCall.id == widget.call.id,
            );
            if (call != null) {
              return DefaultTabController(
                length: 4,
                child: Scaffold(
                  appBar: AppBar(
                    bottom: TabBar(
                      indicatorColor: VmLogApiTheme.lightRed,
                      tabs:
                          VmLogApiCallDetailsTabItem.values.map((item) {
                            return Tab(
                              icon: _getTabIcon(item: item),
                              text: _getTabName(item: item),
                            );
                          }).toList(),
                    ),
                    title: Text(
                      '${widget.core.configuration.inspectorTitle} -'
                      ' ${context.i18n(VmLogApiTranslationKey.callDetails)}',
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      VmLogApiCallOverviewScreen(call: widget.call),
                      VmLogApiCallRequestScreen(call: widget.call),
                      VmLogApiCallResponseScreen(call: widget.call),
                      VmLogApiCallErrorScreen(call: widget.call),
                    ],
                  ),
                  floatingActionButton:
                      widget.core.configuration.showShareButton
                          ? FloatingActionButton(
                            backgroundColor: VmLogApiTheme.lightRed,
                            key: const Key('share_key'),
                            onPressed: _shareCall,
                            child: const Icon(
                              Icons.share,
                              color: VmLogApiTheme.white,
                            ),
                          )
                          : null,
                ),
              );
            }
          }

          return Center(
            child: Text(context.i18n(VmLogApiTranslationKey.callDetailsEmpty)),
          );
        },
      ),
    );
  }

  /// Called when share button has been pressed. It encodes the [widget.call]
  /// and tries to invoke system action to share it.
  void _shareCall() async {
    await VmLogApiExportHelper.shareCall(context: context, call: widget.call);
  }

  /// Get tab name based on [item] type.
  String _getTabName({required VmLogApiCallDetailsTabItem item}) {
    switch (item) {
      case VmLogApiCallDetailsTabItem.overview:
        return context.i18n(VmLogApiTranslationKey.callDetailsOverview);
      case VmLogApiCallDetailsTabItem.request:
        return context.i18n(VmLogApiTranslationKey.callDetailsRequest);
      case VmLogApiCallDetailsTabItem.response:
        return context.i18n(VmLogApiTranslationKey.callDetailsResponse);
      case VmLogApiCallDetailsTabItem.error:
        return context.i18n(VmLogApiTranslationKey.callDetailsError);
    }
  }

  /// Get tab icon based on [item] type.
  Icon _getTabIcon({required VmLogApiCallDetailsTabItem item}) {
    switch (item) {
      case VmLogApiCallDetailsTabItem.overview:
        return const Icon(Icons.info_outline);
      case VmLogApiCallDetailsTabItem.request:
        return const Icon(Icons.arrow_upward);
      case VmLogApiCallDetailsTabItem.response:
        return const Icon(Icons.arrow_downward);
      case VmLogApiCallDetailsTabItem.error:
        return const Icon(Icons.warning);
    }
  }
}
