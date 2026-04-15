# vm-log-api

Thư viện Flutter để log và inspect HTTP API ngay trong app.

## Packages

- `vm_log_api`: lõi inspector UI + storage + export/share log
- `vm_log_api_dio`: adapter cho Dio interceptor

## Cài Đặt (monorepo/local path)

```yaml
dependencies:
  vm_log_api:
    path: packages/vm_log_api
  vm_log_api_dio:
    path: packages/vm_log_api_dio
```

## Cài Đặt Qua Git (Monorepo)

```yaml
dependencies:
  vm_log_api:
    git:
      url: https://bitbucket.vietmap.vn/scm/~datdnt/packages.git
      path: packages/vm-log-api/packages/vm_log_api
  vm_log_api_dio:
    git:
      url: https://bitbucket.vietmap.vn/scm/~datdnt/packages.git
      path: packages/vm-log-api/packages/vm_log_api_dio
```

## Cách Dùng Cơ Bản (Dio)

```dart
import 'package:dio/dio.dart';
import 'package:vm_log_api/vm_log_api.dart';
import 'package:vm_log_api/model/vm_log_api_configuration.dart';
import 'package:vm_log_api_dio/vm_log_api_dio_adapter.dart';

final adapter = VmLogApiDioAdapter();

final logApi = VmLogApi(
  configuration: AliceConfiguration(
    showNotification: false,
    openInspectorOnHttpCall: false,
    inspectorPath: '/vm-log-api',
    inspectorTitle: 'vm-log-api',
  ),
)..addAdapter(adapter);

final dio = Dio()..interceptors.add(adapter);
```

## Mở Màn Inspector

### 1) Bằng code

```dart
logApi.showInspector();
```

### 2) Bằng router path (go_router)

```dart
GoRoute(
  path: logApi.inspectorPath,
  builder: (_, __) => logApi.buildInspectorScreen(),
);

context.push(logApi.inspectorPath);
```

## Cấu Hình Quan Trọng

- `inspectorTitle`: tiêu đề hiển thị ở list/detail (mặc định `vm-log-api`)
- `inspectorPath`: route path để mở inspector (mặc định `/vm-log-api`)
- `showNotification`: bật/tắt local notification khi có request mới
- `openInspectorOnHttpCall`: tự bật màn inspector khi có call mới
- `showInspectorOnShake`: mở inspector khi lắc máy

## Example

Chạy ví dụ:

```bash
cd examples/vm_log_api_dio
flutter pub get
flutter run
```

Màn example có:

- Nút chạy polling API mỗi 2 giây
- Chế độ API chậm để test request chồng nhau
- Nút mở inspector
