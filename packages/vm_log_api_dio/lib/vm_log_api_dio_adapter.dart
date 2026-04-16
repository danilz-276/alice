import 'dart:convert';

import 'package:vm_log_api/core/vm_log_api_adapter.dart';
import 'package:vm_log_api/model/vm_log_api_form_data_file.dart';
import 'package:vm_log_api/model/vm_log_api_from_data_field.dart';
import 'package:vm_log_api/model/vm_log_api_http_call.dart';
import 'package:vm_log_api/model/vm_log_api_http_error.dart';
import 'package:vm_log_api/model/vm_log_api_http_request.dart';
import 'package:vm_log_api/model/vm_log_api_http_response.dart';
import 'package:vm_log_api/model/vm_log_api_log.dart';
import 'package:vm_log_api/utils/vm_log_api_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class VmLogApiDioAdapter extends InterceptorsWrapper with VmLogApiAdapter {
  /// Handles dio request and creates vm-log-api http call based on it
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final call = VmLogApiHttpCall(options.hashCode);

    final uri = options.uri;
    call.method = options.method;
    var path = options.uri.path;
    if (path.isEmpty) {
      path = '/';
    }
    call
      ..endpoint = path
      ..server = uri.host
      ..client = 'Dio'
      ..uri = options.uri.toString();

    if (uri.scheme == 'https') {
      call.secure = true;
    }

    final request = VmLogApiHttpRequest();

    final dynamic data = options.data;
    if (data == null) {
      request
        ..size = 0
        ..body = '';
    } else {
      if (data is FormData) {
        // ignore: avoid_dynamic_calls
        request.body += 'Form data';

        if (data.fields.isNotEmpty == true) {
          final fields = <VmLogApiFormDataField>[];
          for (var entry in data.fields) {
            fields.add(VmLogApiFormDataField(entry.key, entry.value));
          }
          request.formDataFields = fields;
        }

        if (data.files.isNotEmpty == true) {
          final files = <VmLogApiFormDataFile>[];
          for (var entry in data.files) {
            files.add(
              VmLogApiFormDataFile(
                entry.value.filename,
                entry.value.contentType.toString(),
                entry.value.length,
              ),
            );
          }

          request.formDataFiles = files;
        }
      } else {
        request
          ..size = utf8.encode(data.toString()).length
          ..body = data;
      }
    }

    request
      ..time = DateTime.now()
      ..headers = VmLogApiParser.parseHeaders(headers: options.headers)
      ..contentType = options.contentType.toString()
      ..queryParameters = uri.queryParameters;

    call
      ..request = request
      ..response = VmLogApiHttpResponse();

    core.addCall(call);
    handler.next(options);
  }

  /// Handles dio response and adds data to vm-log-api http call
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final httpResponse = VmLogApiHttpResponse()..status = response.statusCode;

    if (response.data == null) {
      httpResponse
        ..body = ''
        ..size = 0;
    } else {
      httpResponse
        ..body = response.data
        ..size = utf8.encode(response.data.toString()).length;
    }

    httpResponse.time = DateTime.now();
    final headers = <String, String>{};
    response.headers.forEach((header, values) {
      headers[header] = values.toString();
    });
    httpResponse.headers = headers;

    core.addResponse(httpResponse, response.requestOptions.hashCode);
    handler.next(response);
  }

  /// Handles error and adds data to vm-log-api http call
  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    final httpError = VmLogApiHttpError()..error = error.toString();
    if (error is Error) {
      final basicError = error as Error;
      httpError.stackTrace = basicError.stackTrace;
    }

    core.addError(httpError, error.requestOptions.hashCode);
    final httpResponse = VmLogApiHttpResponse()..time = DateTime.now();
    if (error.response == null) {
      httpResponse.status = -1;
      core.addResponse(httpResponse, error.requestOptions.hashCode);
    } else {
      httpResponse.status = error.response!.statusCode;

      if (error.response!.data == null) {
        httpResponse
          ..body = ''
          ..size = 0;
      } else {
        httpResponse
          ..body = error.response!.data
          ..size = utf8.encode(error.response!.data.toString()).length;
      }
      final headers = <String, String>{};
      error.response!.headers.forEach((header, values) {
        headers[header] = values.toString();
      });
      httpResponse.headers = headers;
      core.addResponse(
        httpResponse,
        error.response!.requestOptions.hashCode,
      );
      core.addLog(
        VmLogApiLog(
          message: error.toString(),
          level: DiagnosticLevel.error,
          error: error,
          stackTrace: error.stackTrace,
        ),
      );
    }
    handler.next(error);
  }
}
