import 'dart:async' show FutureOr, StreamSubscription;

import 'package:vm_log_api/core/vm_log_api_storage.dart';
import 'package:vm_log_api/core/vm_log_api_utils.dart';
import 'package:vm_log_api/helper/vm_log_api_export_helper.dart';
import 'package:vm_log_api/core/vm_log_api_notification.dart';
import 'package:vm_log_api/helper/operating_system.dart';
import 'package:vm_log_api/model/vm_log_api_configuration.dart';
import 'package:vm_log_api/model/vm_log_api_export_result.dart';
import 'package:vm_log_api/model/vm_log_api_http_call.dart';
import 'package:vm_log_api/model/vm_log_api_http_error.dart';
import 'package:vm_log_api/model/vm_log_api_http_response.dart';
import 'package:vm_log_api/model/vm_log_api_log.dart';
import 'package:vm_log_api/ui/common/vm_log_api_navigation.dart';
import 'package:vm_log_api/utils/shake_detector.dart';
import 'package:flutter/material.dart';

class VmLogApiCore {
  /// Configuration of VmLogApi
  late VmLogApiConfiguration _configuration;

  /// Detector used to detect device shakes
  ShakeDetector? _shakeDetector;

  /// Helper used for notification management
  VmLogApiNotification? _notification;

  /// Subscription for call changes
  StreamSubscription<List<VmLogApiHttpCall>>? _callsSubscription;

  /// Flag used to determine whether is inspector opened
  bool _isInspectorOpened = false;

  /// Creates alice core instance
  VmLogApiCore({required VmLogApiConfiguration configuration}) {
    _configuration = configuration;
    _subscribeToCallChanges();
    if (_configuration.showNotification &&
        !_configuration.openInspectorOnHttpCall) {
      _notification = VmLogApiNotification();
      _notification?.configure(
        notificationIcon: _configuration.notificationIcon,
        title: _configuration.inspectorTitle,
        openInspectorCallback: navigateToCallListScreen,
      );
    }
    if (_configuration.showInspectorOnShake) {
      if (OperatingSystem.isAndroid || OperatingSystem.isIOS) {
        _shakeDetector = ShakeDetector.autoStart(
          onPhoneShake: navigateToCallListScreen,
          shakeThresholdGravity: 4,
        );
      }
    }
  }

  /// Returns current configuration
  VmLogApiConfiguration get configuration => _configuration;

  /// Set custom navigation key. This will help if there's route library.
  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _configuration = _configuration.copyWith(navigatorKey: navigatorKey);
  }

  /// Dispose subjects and subscriptions
  void dispose() {
    _shakeDetector?.stopListening();
    _unsubscribeFromCallChanges();
  }

  /// Called when calls has been updated
  Future<void> _onCallsChanged(List<VmLogApiHttpCall>? calls) async {
    if (calls != null && calls.isNotEmpty) {
      if (_configuration.openInspectorOnHttpCall) {
        await navigateToCallListScreen();
        return;
      }
      final VmLogApiStats stats = _configuration.storage.getStats();
      _notification?.showStatsNotification(
        context: getContext()!,
        stats: stats,
      );
    }
  }

  /// Opens Http calls inspector. This will navigate user to the new fullscreen
  /// page where all listened http calls can be viewed.
  Future<void> navigateToCallListScreen() async {
    final BuildContext? context = getContext();
    if (context == null) {
      VmLogApiUtils.log(
        'Cant start vm-log-api HTTP Inspector. Please add NavigatorKey to your '
        'application',
      );
      return;
    }
    if (!_isInspectorOpened) {
      _isInspectorOpened = true;
      await VmLogApiNavigation.navigateToCallsList(core: this);
      _isInspectorOpened = false;
    }
  }

  /// Get context from navigator key. Used to open inspector route.
  BuildContext? getContext() =>
      _configuration.navigatorKey?.currentState?.overlay?.context;

  /// Add alice http call to calls subject
  FutureOr<void> addCall(VmLogApiHttpCall call) =>
      _configuration.storage.addCall(call);

  /// Add error to existing alice http call
  FutureOr<void> addError(VmLogApiHttpError error, int requestId) =>
      _configuration.storage.addError(error, requestId);

  /// Add response to existing alice http call
  FutureOr<void> addResponse(VmLogApiHttpResponse response, int requestId) =>
      _configuration.storage.addResponse(response, requestId);

  /// Remove all calls from calls subject
  FutureOr<void> removeCalls() => _configuration.storage.removeCalls();

  /// Selects call with given [requestId]. It may return null.
  @protected
  VmLogApiHttpCall? selectCall(int requestId) =>
      _configuration.storage.selectCall(requestId);

  /// Returns stream which returns list of HTTP calls
  Stream<List<VmLogApiHttpCall>> get callsStream =>
      _configuration.storage.callsStream;

  /// Returns all stored HTTP calls.
  List<VmLogApiHttpCall> getCalls() => _configuration.storage.getCalls();

  /// Save all calls to file.
  Future<VmLogApiExportResult> saveCallsToFile(BuildContext context) =>
      VmLogApiExportHelper.saveCallsToFile(
        context,
        _configuration.storage.getCalls(),
      );

  /// Adds new log to VmLogApi logger.
  void addLog(VmLogApiLog log) => _configuration.logger.add(log);

  /// Adds list of logs to VmLogApi logger
  void addLogs(List<VmLogApiLog> logs) => _configuration.logger.addAll(logs);

  /// Returns flag which determines whether inspector is opened
  bool get isInspectorOpened => _isInspectorOpened;

  /// Subscribes to storage for call changes.
  void _subscribeToCallChanges() {
    _callsSubscription = _configuration.storage.callsStream.listen(
      _onCallsChanged,
    );
  }

  /// Unsubscribes storage for call changes.
  void _unsubscribeFromCallChanges() {
    _callsSubscription?.cancel();
    _callsSubscription = null;
  }
}
