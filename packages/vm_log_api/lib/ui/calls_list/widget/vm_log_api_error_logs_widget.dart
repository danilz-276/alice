import 'package:vm_log_api/model/vm_log_api_translation.dart';
import 'package:vm_log_api/ui/common/vm_log_api_context_ext.dart';
import 'package:vm_log_api/ui/common/vm_log_api_theme.dart';
import 'package:flutter/material.dart';

/// Widget which renders empty text for calls list.
class VmLogApiErrorLogsWidget extends StatelessWidget {
  const VmLogApiErrorLogsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: VmLogApiTheme.red),
            const SizedBox(height: 6),
            Text(
              context.i18n(VmLogApiTranslationKey.logsItemError),
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
