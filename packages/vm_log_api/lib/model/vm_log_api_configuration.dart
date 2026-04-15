import 'package:vm_log_api/core/vm_log_api_logger.dart';
import 'package:vm_log_api/core/vm_log_api_memory_storage.dart';
import 'package:vm_log_api/core/vm_log_api_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class AliceConfiguration with EquatableMixin {
  /// Default max calls count used in default memory storage.
  static const _defaultMaxCalls = 1000;

  /// Default max logs count.
  static const _defaultMaxLogs = 1000;

  /// Should user be notified with notification when there's new request caught
  /// by Alice. Default value is true.
  final bool showNotification;

  /// Should inspector be opened on device shake (works only with physical
  /// with sensors). Default value is true.
  final bool showInspectorOnShake;

  /// Should inspector be opened automatically when HTTP calls list changes.
  /// This mode skips notification flow. Default value is false.
  final bool openInspectorOnHttpCall;

  /// Icon url for notification. Default value is '@mipmap/ic_launcher'.
  final String notificationIcon;

  /// App route path used for exposing inspector screen in app routers.
  final String inspectorPath;

  /// Main title displayed in inspector pages.
  final String inspectorTitle;

  /// Directionality of app. Directionality of the app will be used if set to
  /// null. Default value is null.
  final TextDirection? directionality;

  /// Flag used to show/hide share button
  final bool showShareButton;

  /// Navigator key used to open inspector. Default value is null.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Storage where calls will be saved. The default storage is memory storage.
  final AliceStorage aliceStorage;

  /// Logger instance.
  final AliceLogger aliceLogger;

  AliceConfiguration({
    this.showNotification = true,
    this.showInspectorOnShake = true,
    this.openInspectorOnHttpCall = false,
    this.notificationIcon = '@mipmap/ic_launcher',
    this.inspectorPath = '/vm-log-api',
    this.inspectorTitle = 'vm-log-api',
    this.directionality,
    this.showShareButton = true,
    GlobalKey<NavigatorState>? navigatorKey,
    AliceStorage? storage,
    AliceLogger? logger,
  }) : aliceStorage =
           storage ?? AliceMemoryStorage(maxCallsCount: _defaultMaxCalls),
       navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>(),
       aliceLogger = logger ?? AliceLogger(maximumSize: _defaultMaxLogs);

  AliceConfiguration copyWith({
    GlobalKey<NavigatorState>? navigatorKey,
    bool? showNotification,
    bool? showInspectorOnShake,
    bool? openInspectorOnHttpCall,
    String? notificationIcon,
    String? inspectorPath,
    String? inspectorTitle,
    TextDirection? directionality,
    bool? showShareButton,
    AliceStorage? aliceStorage,
    AliceLogger? aliceLogger,
  }) => AliceConfiguration(
    showNotification: showNotification ?? this.showNotification,
    showInspectorOnShake: showInspectorOnShake ?? this.showInspectorOnShake,
    openInspectorOnHttpCall:
        openInspectorOnHttpCall ?? this.openInspectorOnHttpCall,
    notificationIcon: notificationIcon ?? this.notificationIcon,
    inspectorPath: inspectorPath ?? this.inspectorPath,
    inspectorTitle: inspectorTitle ?? this.inspectorTitle,
    directionality: directionality ?? this.directionality,
    showShareButton: showShareButton ?? this.showShareButton,
    navigatorKey: navigatorKey ?? this.navigatorKey,
    storage: aliceStorage ?? this.aliceStorage,
    logger: aliceLogger ?? this.aliceLogger,
  );

  @override
  List<Object?> get props => [
    showNotification,
    showInspectorOnShake,
    openInspectorOnHttpCall,
    notificationIcon,
    inspectorPath,
    inspectorTitle,
    directionality,
    showShareButton,
    navigatorKey,
    aliceStorage,
    aliceLogger,
  ];
}
