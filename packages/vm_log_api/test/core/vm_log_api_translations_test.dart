import 'package:vm_log_api/core/vm_log_api_translations.dart';
import 'package:vm_log_api/model/vm_log_api_translation.dart';
import 'package:test/test.dart';

void main() {
  group("VmLogApiTranslations", () {
    test("should return translated value", () {
      expect(
        VmLogApiTranslations.get(
          languageCode: "en",
          key: VmLogApiTranslationKey.saveLogId,
        ),
        "Id:",
      );

      expect(
        VmLogApiTranslations.get(
          languageCode: "en",
          key: VmLogApiTranslationKey.logsEmpty,
        ),
        "There are no logs to show",
      );
    });

    test(
      "should return english translation when there's no translation found",
      () {
        expect(
          VmLogApiTranslations.get(
            languageCode: "xx",
            key: VmLogApiTranslationKey.saveLogId,
          ),
          "Id:",
        );

        expect(
          VmLogApiTranslations.get(
            languageCode: "xx",
            key: VmLogApiTranslationKey.logsEmpty,
          ),
          "There are no logs to show",
        );
      },
    );

    test("should return translated key for other languages", () {
      expect(
        VmLogApiTranslations.get(
          languageCode: "pl",
          key: VmLogApiTranslationKey.logsEmpty,
        ),
        "Brak rezultatów",
      );

      expect(
        VmLogApiTranslations.get(
          languageCode: "pl",
          key: VmLogApiTranslationKey.saveLogRequest,
        ),
        "Żądanie",
      );
    });
  });
}
