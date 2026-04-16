import 'package:vm_log_api/core/vm_log_api_core.dart';
import 'package:vm_log_api/ui/common/vm_log_api_theme.dart';
import 'package:flutter/material.dart';

/// Common page widget which is used across VmLogApi pages.
class VmLogApiPage extends StatelessWidget {
  const VmLogApiPage({super.key, required this.core, required this.child});

  final VmLogApiCore core;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          core.configuration.directionality ?? Directionality.of(context),
      child: Theme(data: VmLogApiTheme.getTheme(), child: child),
    );
  }
}
