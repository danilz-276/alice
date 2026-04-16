import 'package:flutter/material.dart';
import 'package:vm_log_api/model/vm_log_api_translation.dart';
import 'package:vm_log_api/ui/calls_list/model/vm_log_api_calls_list_sort_option.dart';
import 'package:vm_log_api/ui/common/vm_log_api_context_ext.dart';

/// Dialog which can be used to sort alice calls.
class VmLogApiSortDialog extends StatelessWidget {
  final VmLogApiCallsListSortOption sortOption;
  final bool sortAscending;

  const VmLogApiSortDialog({
    super.key,
    required this.sortOption,
    required this.sortAscending,
  });

  @override
  Widget build(BuildContext context) {
    VmLogApiCallsListSortOption currentSortOption = sortOption;
    bool currentSortAscending = sortAscending;
    return Theme(
      data: ThemeData(brightness: Brightness.light),
      child: StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(context.i18n(VmLogApiTranslationKey.sortDialogTitle)),
            content: Wrap(
              children: [
                RadioGroup<VmLogApiCallsListSortOption>(
                  groupValue: currentSortOption,
                  onChanged: (VmLogApiCallsListSortOption? value) {
                    if (value != null) {
                      setState(() {
                        currentSortOption = value;
                      });
                    }
                  },
                  child: Column(
                    children: [
                      for (final VmLogApiCallsListSortOption sortOption
                          in VmLogApiCallsListSortOption.values)
                        RadioListTile<VmLogApiCallsListSortOption>(
                          title: Text(
                            _getName(context: context, option: sortOption),
                          ),
                          value: sortOption,
                        ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.i18n(VmLogApiTranslationKey.sortDialogDescending),
                    ),
                    Switch(
                      value: currentSortAscending,
                      onChanged: (value) {
                        setState(() {
                          currentSortAscending = value;
                        });
                      },
                      activeTrackColor: Colors.grey,
                      activeThumbColor: Colors.white,
                    ),
                    Text(context.i18n(VmLogApiTranslationKey.sortDialogAscending)),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: Text(context.i18n(VmLogApiTranslationKey.sortDialogCancel)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(
                    VmLogApiSortDialogResult(
                      sortOption: currentSortOption,
                      sortAscending: currentSortAscending,
                    ),
                  );
                },
                child: Text(context.i18n(VmLogApiTranslationKey.sortDialogAccept)),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Get sort option name based on [option].
  String _getName({
    required BuildContext context,
    required VmLogApiCallsListSortOption option,
  }) {
    return switch (option) {
      VmLogApiCallsListSortOption.time => context.i18n(
        VmLogApiTranslationKey.sortDialogTime,
      ),
      VmLogApiCallsListSortOption.responseTime => context.i18n(
        VmLogApiTranslationKey.sortDialogResponseTime,
      ),
      VmLogApiCallsListSortOption.responseCode => context.i18n(
        VmLogApiTranslationKey.sortDialogResponseCode,
      ),
      VmLogApiCallsListSortOption.responseSize => context.i18n(
        VmLogApiTranslationKey.sortDialogResponseSize,
      ),
      VmLogApiCallsListSortOption.endpoint => context.i18n(
        VmLogApiTranslationKey.sortDialogEndpoint,
      ),
    };
  }
}

/// Result of alice sort dialog.
class VmLogApiSortDialogResult {
  final VmLogApiCallsListSortOption sortOption;
  final bool sortAscending;

  VmLogApiSortDialogResult({
    required this.sortOption,
    required this.sortAscending,
  });
}
