import 'dart:io';

import 'package:vm_log_api/helper/vm_log_api_export_helper.dart';
import 'package:vm_log_api/model/vm_log_api_export_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../mock/build_context_mock.dart';
import '../mock/mocked_data.dart';

void main() {
  late BuildContext context;
  setUp(() {
    context = BuildContextMock();
  });

  group("VmLogApiExportHelper", () {
    test("should build correct call log", () async {
      _setPackageInfo();

      final result = await VmLogApiExportHelper.buildFullCallLog(
        context: context,
        call: MockedData.getFilledHttpCall(),
      );
      _verifyLogLines(result!);
    });

    test("should save call log to file", () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      _setPackageInfo();
      _setPathProvider();
      _setDefaultTargetPlatform();

      final result = await VmLogApiExportHelper.saveCallsToFile(context, [
        MockedData.getFilledHttpCall(),
      ]);
      expect(result.success, true);
      expect(result.path != null, true);
      expect(result.error, null);

      final file = File(result.path!);
      expect(file.existsSync(), true);
      final content = await file.readAsString();
      _verifyLogLines(content);
      file.delete();
    });
  });

  test("should not save empty call log to file", () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _setPackageInfo();
    _setPathProvider();
    _setDefaultTargetPlatform();

    final result = await VmLogApiExportHelper.saveCallsToFile(context, []);

    expect(result.success, false);
    expect(result.path, null);
    expect(result.error, VmLogApiExportResultError.empty);
  });

  test("should not save call log to file if file problem occurs", () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _setPackageInfo();
    _setPathProvider(isFailing: true);
    _setDefaultTargetPlatform();

    final result = await VmLogApiExportHelper.saveCallsToFile(context, [
      MockedData.getFilledHttpCall(),
    ]);

    expect(result.success, false);
    expect(result.path, null);
    expect(result.error, VmLogApiExportResultError.file);
  });

  test("should share call log", () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _setPackageInfo();
    _setShare();

    final result = await VmLogApiExportHelper.shareCall(
      context: context,
      call: MockedData.getFilledHttpCall(),
    );
    expect(result.success, true);
    expect(result.error, null);
  });
}

void _verifyLogLines(String result) {
  var lines = [
    'VmLogApiTranslationKey.saveHeaderTitle',
    'VmLogApiTranslationKey.saveHeaderAppName  VmLogApi',
    'VmLogApiTranslationKey.saveHeaderPackage pl.hasoft.alice',
    'VmLogApiTranslationKey.saveHeaderTitle 1.0',
    'VmLogApiTranslationKey.saveHeaderBuildNumber 1',
    'VmLogApiTranslationKey.saveHeaderGenerated',
    '',
    '===========================================',
    'VmLogApiTranslationKey.saveLogId',
    '============================================',
    '--------------------------------------------',
    'VmLogApiTranslationKey.saveLogGeneralData',
    '--------------------------------------------',
    'VmLogApiTranslationKey.saveLogServer https://test.com ',
    'VmLogApiTranslationKey.saveLogMethod POST ',
    'VmLogApiTranslationKey.saveLogEndpoint /test ',
    'VmLogApiTranslationKey.saveLogClient  ',
    'VmLogApiTranslationKey.saveLogDuration 0 ms',
    'VmLogApiTranslationKey.saveLogSecured true',
    'VmLogApiTranslationKey.saveLogCompleted: true ',
    '--------------------------------------------',
    'VmLogApiTranslationKey.saveLogRequest',
    '--------------------------------------------',
    'VmLogApiTranslationKey.saveLogRequestTime',
    'VmLogApiTranslationKey.saveLogRequestContentType: application/json',
    'VmLogApiTranslationKey.saveLogRequestCookies []',
    'VmLogApiTranslationKey.saveLogRequestHeaders {}',
    'VmLogApiTranslationKey.saveLogRequestSize 0 B',
    'VmLogApiTranslationKey.saveLogRequestBody {',
    '  "id": 0',
    '}',
    '--------------------------------------------',
    'VmLogApiTranslationKey.saveLogResponse',
    '--------------------------------------------',
    'VmLogApiTranslationKey.saveLogResponseTime',
    'VmLogApiTranslationKey.saveLogResponseStatus 0',
    'VmLogApiTranslationKey.saveLogResponseSize 0 B',
    'VmLogApiTranslationKey.saveLogResponseHeaders {}',
    'VmLogApiTranslationKey.saveLogResponseBody {"id": 0}',
    '--------------------------------------------',
    'VmLogApiTranslationKey.saveLogCurl',
    '--------------------------------------------',
    'curl -X POST ',
    '==============================================',
    '',
  ];
  for (var line in lines) {
    expect(result.contains(line), true);
  }
}

void _setPackageInfo() {
  PackageInfo.setMockInitialValues(
    appName: "VmLogApi",
    packageName: "pl.hasoft.alice",
    version: "1.0",
    buildNumber: "1",
    buildSignature: "buildSignature",
  );
}

void _setPathProvider({bool isFailing = false}) {
  const MethodChannel channel = MethodChannel(
    'plugins.flutter.io/path_provider',
  );
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (isFailing) {
          return "";
        } else {
          return ".";
        }
      });
}

void _setDefaultTargetPlatform() {
  debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
}

void _setShare() {
  const MethodChannel channel = MethodChannel(
    'dev.fluttercommunity.plus/share',
  );
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        return ".";
      });
}
