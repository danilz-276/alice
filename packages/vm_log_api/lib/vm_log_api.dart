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
  late final AliceCore _aliceCore;

  /// Creates vm-log-api instance.
  VmLogApi({AliceConfiguration? configuration}) {
    _aliceCore = AliceCore(
      configuration: configuration ?? AliceConfiguration(),
    );
  }

  /// Set custom navigation key. This will help if there's route library.
  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _aliceCore.setNavigatorKey(navigatorKey);
  }

  /// Get currently used navigation key
  GlobalKey<NavigatorState>? getNavigatorKey() =>
      _aliceCore.configuration.navigatorKey;

  /// Opens Http calls inspector. This will navigate user to the new fullscreen
  /// page where all listened http calls can be viewed.
  void showInspector() => _aliceCore.navigateToCallListScreen();

  /// App route path that can be used in routers (for example go_router).
  String get inspectorPath => _aliceCore.configuration.inspectorPath;

  /// Builds inspector page widget to use in app routers.
  Widget buildInspectorScreen() =>
      AliceNavigation.callsListPage(core: _aliceCore);

  /// Handle generic http call. Can be used to any http client.
  void addHttpCall(AliceHttpCall aliceHttpCall) {
    assert(aliceHttpCall.request != null, "Http call request can't be null");
    assert(aliceHttpCall.response != null, "Http call response can't be null");

    _aliceCore.addCall(aliceHttpCall);
  }

  /// Adds new log to Alice logger.
  void addLog(AliceLog log) => _aliceCore.addLog(log);

  /// Adds list of logs to Alice logger
  void addLogs(List<AliceLog> logs) => _aliceCore.addLogs(logs);

  /// Returns flag which determines whether inspector is opened
  bool get isInspectorOpened => _aliceCore.isInspectorOpened;

  /// Adds new adapter to Alice.
  void addAdapter(AliceAdapter adapter) => adapter.injectCore(_aliceCore);
}

@Deprecated('Use VmLogApi instead')
class Alice extends VmLogApi {
  Alice({super.configuration});
}
