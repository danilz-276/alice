import 'package:vm_log_api/vm_log_api.dart';
import 'package:vm_log_api/core/vm_log_api_core.dart';
import 'package:vm_log_api/core/vm_log_api_logger.dart';
import 'package:vm_log_api/core/vm_log_api_storage.dart';
import 'package:vm_log_api/model/vm_log_api_configuration.dart';
import 'package:vm_log_api/model/vm_log_api_http_error.dart';
import 'package:vm_log_api/model/vm_log_api_http_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mock/vm_log_api_logger_mock.dart';
import '../mock/vm_log_api_storage_mock.dart';
import '../mock/mocked_data.dart';

void main() {
  late VmLogApiCore core;
  late VmLogApiStorage storage;
  late VmLogApiLogger logger;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(MockedData.getLoadingHttpCall());
    registerFallbackValue(VmLogApiHttpError());
    registerFallbackValue(VmLogApiHttpResponse());
    registerFallbackValue(VmLogApiLog(message: ""));
    storage = VmLogApiStorageMock();
    logger = VmLogApiLoggerMock();

    when(
      () => storage.callsStream,
    ).thenAnswer((_) => const Stream.empty());
    core = VmLogApiCore(
      configuration: VmLogApiConfiguration(
        showNotification: false,
        showInspectorOnShake: false,
        storage: storage,
        logger: logger,
      ),
    );
  });

  group("VmLogApiCore", () {
    test("should use storage to add call", () {
      when(() => storage.addCall(any())).thenAnswer((_) => () {});

      core.addCall(MockedData.getLoadingHttpCall());

      verify(() => storage.addCall(any()));
    });

    test("should use storage to add error", () {
      when(() => storage.addError(any(), any())).thenAnswer((_) => () {});

      core.addError(VmLogApiHttpError(), 0);

      verify(() => storage.addError(any(), any()));
    });

    test("should use storage to add response", () {
      when(
        () => storage.addResponse(any(), any()),
      ).thenAnswer((_) => () {});

      core.addResponse(VmLogApiHttpResponse(), 0);

      verify(() => storage.addResponse(any(), any()));
    });

    test("should use storage to remove calls", () {
      when(() => storage.removeCalls()).thenAnswer((_) => () {});

      core.removeCalls();

      verify(() => storage.removeCalls());
    });

    test("should use storage to get calls stream", () async {
      final calls = [MockedData.getLoadingHttpCall()];
      when(
        () => storage.callsStream,
      ).thenAnswer((_) => Stream.value(calls));

      expect(await core.callsStream.first, calls);

      verify(() => storage.callsStream);
    });

    test("should use storage to get calls", () {
      final calls = [MockedData.getLoadingHttpCall()];
      when(() => storage.getCalls()).thenAnswer((_) => calls);

      expect(core.getCalls(), calls);

      verify(() => storage.getCalls());
    });

    test("should use logger to add log", () {
      when(() => logger.add(any())).thenAnswer((_) => {});

      core.addLog(VmLogApiLog(message: "test"));

      verify(() => core.addLog(any()));
    });

    test("should use logger to add logs", () {
      when(() => logger.addAll(any())).thenAnswer((_) => {});

      core.addLogs([VmLogApiLog(message: "test")]);

      verify(() => core.addLogs(any()));
    });
  });
}
