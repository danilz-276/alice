import 'package:vm_log_api/vm_log_api.dart';
import 'package:vm_log_api/core/vm_log_api_adapter.dart';
import 'package:vm_log_api/core/vm_log_api_logger.dart';
import 'package:vm_log_api/core/vm_log_api_storage.dart';
import 'package:vm_log_api/model/vm_log_api_configuration.dart';
import 'package:vm_log_api/model/vm_log_api_http_call.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/mocked_data.dart';

void main() {
  group("vm-log-api", () {
    late VmLogApi alice;
    late AliceStorage aliceStorage;
    late AliceLogger aliceLogger;
    setUp(() {
      aliceStorage = AliceMemoryStorage(maxCallsCount: 1000);
      aliceLogger = AliceLogger(maximumSize: 1000);
      alice = VmLogApi(
        configuration: AliceConfiguration(
          showInspectorOnShake: false,
          showNotification: false,
          logger: aliceLogger,
          storage: aliceStorage,
        ),
      );
    });

    test("should set new navigator key", () {
      final navigatorKey = GlobalKey<NavigatorState>();

      expect(alice.getNavigatorKey() != navigatorKey, true);

      alice.setNavigatorKey(navigatorKey);

      expect(alice.getNavigatorKey() == navigatorKey, true);
    });

    test("should add log", () {
      final log = AliceLog(message: "test");

      alice.addLog(log);

      expect(aliceLogger.logs, [log]);
    });

    test("should add logs", () {
      final logs = [AliceLog(message: "test 1"), AliceLog(message: "test 2")];

      alice.addLogs(logs);

      expect(aliceLogger.logs, logs);
    });

    test("should add call", () {
      final call = MockedData.getFilledHttpCall();

      alice.addHttpCall(call);

      expect(aliceStorage.getCalls(), [call]);
    });

    test("should add adapter", () {
      final call = MockedData.getFilledHttpCall();
      final adapter = FakeAdapter();
      alice.addAdapter(adapter);

      adapter.addCallLog(call);

      expect(aliceStorage.getCalls(), [call]);
    });

    test("should return is inspector opened flag", () {
      expect(alice.isInspectorOpened, false);
    });
  });
}

class FakeAdapter with AliceAdapter {
  void addCallLog(AliceHttpCall call) {
    aliceCore.addCall(call);
  }
}
