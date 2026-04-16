import 'dart:async';

import 'package:vm_log_api/vm_log_api.dart';
import 'package:vm_log_api/model/vm_log_api_configuration.dart';
import 'package:vm_log_api_dio/vm_log_api_dio_adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _homePath = '/';
  static const _fastPhotosUrl = 'https://jsonplaceholder.typicode.com/photos';
  static const _slowApiUrl = 'https://httpbin.org/delay/6';
  late final VmLogApiDioAdapter _logApiDioAdapter = VmLogApiDioAdapter();
  bool _isRunning = false;
  bool _slowModeEnabled = false;
  int _requestSequence = 0;
  Timer? _pollingTimer;

  final configuration = VmLogApiConfiguration(
    showNotification: false,
    openInspectorOnHttpCall: false,
    inspectorPath: '/vm-log-api',
    inspectorTitle: 'vm-log-api',
  );
  late final VmLogApi _logApi = VmLogApi(configuration: configuration)
    ..addAdapter(_logApiDioAdapter);

  late final Dio _dio = Dio(
    BaseOptions(followRedirects: true, validateStatus: (_) => true),
  )..interceptors.add(_logApiDioAdapter);

  late final GoRouter _router = GoRouter(
    navigatorKey: _logApi.getNavigatorKey(),
    initialLocation: _homePath,
    routes: [
      GoRoute(
        path: _homePath,
        builder: (context, state) => _buildHomeScreen(context),
      ),
      GoRoute(
        path: _logApi.inspectorPath,
        builder: (context, state) => _logApi.buildInspectorScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _buildHomeScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ví dụ vm-log-api + Dio')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _togglePolling,
              child: Text(
                _isRunning
                    ? 'Dừng polling API'
                    : 'Run: bắt đầu polling mỗi 2 giây',
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _slowModeEnabled,
              onChanged:
                  _isRunning
                      ? null
                      : (value) {
                        setState(() {
                          _slowModeEnabled = value;
                        });
                      },
              title: const Text('Chế độ API chậm (delay ~6 giây)'),
              subtitle: const Text(
                'Bật để test request cũ chưa xong nhưng timer 2 giây vẫn gọi tiếp.',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.push(_logApi.inspectorPath),
              child: const Text('Mở màn vm-log-api Inspector'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _togglePolling() async {
    if (_isRunning) {
      _pollingTimer?.cancel();
      if (mounted) {
        setState(() {
          _isRunning = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isRunning = true;
      });
    }

    await _callPhotosOnce();
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _callPhotosOnce();
    });
  }

  Future<void> _callPhotosOnce() async {
    _requestSequence += 1;
    final int sequence = _requestSequence;
    final String url = _slowModeEnabled ? _slowApiUrl : _fastPhotosUrl;

    await _safeRequest(
      label:
          _slowModeEnabled
              ? 'slow_polling_$sequence'
              : 'fast_polling_$sequence',
      request:
          () => _dio.get<dynamic>(
            url,
            queryParameters: <String, dynamic>{'seq': sequence},
          ),
    );
  }

  Future<void> _safeRequest({
    required String label,
    required Future<Response<dynamic>> Function() request,
  }) async {
    try {
      final Response<dynamic> response = await request();
      debugPrint(
        '[vm-log-api Example][$label] ${response.statusCode} ${response.requestOptions.uri}',
      );
    } on DioException catch (error, stackTrace) {
      debugPrint(
        '[vm-log-api Example][$label] DioException: ${error.message} uri=${error.requestOptions.uri}',
      );
      debugPrintStack(stackTrace: stackTrace);
    } catch (error, stackTrace) {
      debugPrint('[vm-log-api Example][$label] Unexpected error: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
