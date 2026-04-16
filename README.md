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
  configuration: VmLogApiConfiguration(
    showNotification: false,
    openInspectorOnHttpCall: false,
    inspectorPath: '/vm-log-api',
    inspectorTitle: 'vm-log-api',
  ),
)..addAdapter(adapter);

final dio = Dio()..interceptors.add(adapter);
```

## 3 Flow Sử Dụng

### 1) App dùng Navigator 1.0

```dart
MaterialApp(
  navigatorKey: logApi.getNavigatorKey(),
  home: const HomePage(),
);

// Mở inspector ở bất kỳ đâu:
logApi.showInspector();
```

### 2) App dùng go_router

```dart
final router = GoRouter(
  navigatorKey: logApi.getNavigatorKey(),
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomePage(),
    ),
    GoRoute(
      path: logApi.inspectorPath,
      builder: (_, __) => logApi.buildInspectorScreen(),
    ),
  ],
);

MaterialApp.router(routerConfig: router);

// Điều hướng vào inspector:
context.push(logApi.inspectorPath);
```

### 3) Mở bằng local notification (tap notification vào inspector)

#### Cách A: Dùng notification của thư viện

```dart
final logApi = VmLogApi(
  configuration: VmLogApiConfiguration(
    showNotification: true,
    inspectorTitle: 'vm-log-api',
  ),
);
```

Khi có HTTP call mới, thư viện sẽ hiện notification. Nhấn notification sẽ mở inspector.

#### Cách B: App đã có local notification riêng (khuyến nghị)

Nếu app đã tự `initialize` `flutter_local_notifications`, không nên để app và thư viện cùng quản lý callback tap notification (dễ ghi đè callback).  
Với trường hợp này:

1. Tắt notification của thư viện:

```dart
VmLogApiConfiguration(showNotification: false)
```

2. App tự bắn notification của app với payload riêng, ví dụ: `'vm-log-api'`
3. Trong handler tap notification của app:

```dart
if (payload == 'vm-log-api') {
  context.push(logApi.inspectorPath); // go_router
  // hoặc logApi.showInspector();     // Navigator 1.0
}
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
