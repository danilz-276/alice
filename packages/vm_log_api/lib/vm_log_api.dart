import 'package:vm_log_api/core/vm_log_api_adapter.dart';
import 'package:vm_log_api/core/vm_log_api_core.dart';
import 'package:vm_log_api/model/vm_log_api_configuration.dart';
import 'package:vm_log_api/model/vm_log_api_http_call.dart';
import 'package:vm_log_api/model/vm_log_api_log.dart';
import 'package:vm_log_api/ui/common/vm_log_api_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

export 'package:vm_log_api/core/vm_log_api_memory_storage.dart';
export 'package:vm_log_api/model/vm_log_api_log.dart';
export 'package:vm_log_api/utils/vm_log_api_parser.dart';

class VmLogApi {
  /// Core instance
  late final VmLogApiCore _core;

  /// Creates vm-log-api instance.
  VmLogApi({VmLogApiConfiguration? configuration}) {
    _core = VmLogApiCore(
      configuration: configuration ?? VmLogApiConfiguration(),
    );
  }

  /// Set custom navigation key. This will help if there's route library.
  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _core.setNavigatorKey(navigatorKey);
  }

  /// Get currently used navigation key
  GlobalKey<NavigatorState>? getNavigatorKey() =>
      _core.configuration.navigatorKey;

  /// Opens Http calls inspector. This will navigate user to the new fullscreen
  /// page where all listened http calls can be viewed.
  void showInspector() => _core.navigateToCallListScreen();

  /// App route path that can be used in routers (for example go_router).
  String get inspectorPath => _core.configuration.inspectorPath;

  /// Builds inspector page widget to use in app routers.
  Widget buildInspectorScreen() =>
      VmLogApiNavigation.callsListPage(core: _core);

  /// Handle generic http call. Can be used to any http client.
  void addHttpCall(VmLogApiHttpCall call) {
    assert(call.request != null, "Http call request can't be null");
    assert(call.response != null, "Http call response can't be null");

    _core.addCall(call);
  }

  /// Adds new log to VmLogApi logger.
  void addLog(VmLogApiLog log) => _core.addLog(log);

  /// Adds list of logs to VmLogApi logger
  void addLogs(List<VmLogApiLog> logs) => _core.addLogs(logs);

  /// Returns flag which determines whether inspector is opened
  bool get isInspectorOpened => _core.isInspectorOpened;

  /// Adds new adapter to VmLogApi.
  void addAdapter(VmLogApiAdapter adapter) => adapter.injectCore(_core);
}
