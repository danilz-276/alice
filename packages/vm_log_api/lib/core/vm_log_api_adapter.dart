import 'package:vm_log_api/core/vm_log_api_core.dart';

/// Adapter mixin which is used in http client adapters.
mixin VmLogApiAdapter {
  late final VmLogApiCore core;

  /// Injects [VmLogApiCore] into adapter.
  void injectCore(VmLogApiCore core) => this.core = core;
}
