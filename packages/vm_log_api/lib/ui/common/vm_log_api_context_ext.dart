import 'package:vm_log_api/model/vm_log_api_translation.dart';
import 'package:vm_log_api/core/vm_log_api_translations.dart';
import 'package:flutter/material.dart';

/// Extension for [BuildContext].
extension AliceContextExt on BuildContext {
  /// Tries to translate given key based on current language code collected from
  /// locale. If it fails to translate [key], it will return [key] itself.
  String i18n(AliceTranslationKey key) {
    try {
      final locale = Localizations.localeOf(this);
      return AliceTranslations.get(languageCode: locale.languageCode, key: key);
    } catch (error) {
      return key.toString();
    }
  }
}
