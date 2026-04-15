import 'package:vm_log_api/core/vm_log_api_core.dart';

/// Adapter mixin which is used in http client adapters.
mixin AliceAdapter {
  late final AliceCore aliceCore;

  /// Injects [AliceCore] into adapter.
  void injectCore(AliceCore aliceCore) => this.aliceCore = aliceCore;
}
