import 'package:vm_log_api/model/vm_log_api_http_call.dart';
import 'package:vm_log_api/model/vm_log_api_http_request.dart';
import 'package:vm_log_api/model/vm_log_api_http_response.dart';

class MockedData {
  static VmLogApiHttpCall getHttpCallWithResponseStatus({
    required int statusCode,
  }) {
    final httpCall = VmLogApiHttpCall(DateTime.now().millisecondsSinceEpoch)
      ..loading = false;
    httpCall.request = VmLogApiHttpRequest();
    httpCall.response = VmLogApiHttpResponse()..status = statusCode;
    return httpCall;
  }

  static VmLogApiHttpCall getLoadingHttpCall() {
    final httpCall = VmLogApiHttpCall(DateTime.now().millisecondsSinceEpoch);
    return httpCall;
  }

  static VmLogApiHttpCall getHttpCall({required int id}) {
    final httpCall = VmLogApiHttpCall(id);
    return httpCall;
  }

  static VmLogApiHttpCall getFilledHttpCall() =>
      VmLogApiHttpCall(DateTime.now().microsecondsSinceEpoch)
        ..loading = false
        ..request =
            (VmLogApiHttpRequest()
              ..headers = {}
              ..body = '{"id": 0}'
              ..contentType = "application/json"
              ..size = 0
              ..time = DateTime.now())
        ..response =
            (VmLogApiHttpResponse()
              ..headers = {}
              ..body = '{"id": 0}'
              ..size = 0
              ..time = DateTime.now())
        ..method = "POST"
        ..endpoint = "/test"
        ..server = "https://test.com"
        ..secure = true;
}
