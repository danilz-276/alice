import 'package:vm_log_api/core/vm_log_api_logger.dart';
import 'package:vm_log_api/model/vm_log_api_log.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  late VmLogApiLogger logger;
  setUp(() {
    logger = VmLogApiLogger(maximumSize: 1000);
  });

  group("VmLogApiLogger", () {
    test("should add log", () {
      final log = VmLogApiLog(message: "test");

      logger.add(log);

      expect(logger.logs, [log]);
    });

    test("should add logs", () {
      final logs = [VmLogApiLog(message: "test"), VmLogApiLog(message: "test2")];

      logger.addAll(logs);

      expect(logger.logs, logs);
    });

    test("should clear logs", () {
      final logs = [VmLogApiLog(message: "test"), VmLogApiLog(message: "test2")];

      logger.addAll(logs);

      expect(logger.logs.isNotEmpty, true);

      logger.clearLogs();

      expect(logger.logs.isEmpty, true);
    });
  });
}
