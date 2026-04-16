import 'package:vm_log_api/model/vm_log_api_translation.dart';

/// Class used to manage translations in VmLogApi.
class VmLogApiTranslations {
  /// Contains list of translation data for all languages.
  static final List<VmLogApiTranslationData> _translations = _initialise();

  /// Initialises translation data for all languages.
  static List<VmLogApiTranslationData> _initialise() {
    List<VmLogApiTranslationData> translations = [];
    translations.add(_buildEnTranslations());
    translations.add(_buildPlTranslations());
    return translations;
  }

  /// Builds [VmLogApiTranslationData] for english language.
  static VmLogApiTranslationData _buildEnTranslations() {
    return VmLogApiTranslationData(
      languageCode: "en",
      values: {
        VmLogApiTranslationKey.alice: "vm-log-api",
        VmLogApiTranslationKey.callDetails: "HTTP Call Details",
        VmLogApiTranslationKey.emailSubject: "vm-log-api report",
        VmLogApiTranslationKey.callDetailsRequest: "Request",
        VmLogApiTranslationKey.callDetailsResponse: "Response",
        VmLogApiTranslationKey.callDetailsOverview: "Overview",
        VmLogApiTranslationKey.callDetailsError: "Error",
        VmLogApiTranslationKey.callDetailsEmpty: "Loading data failed",
        VmLogApiTranslationKey.callErrorScreenErrorEmpty: "Error is empty",
        VmLogApiTranslationKey.callErrorScreenError: "Error:",
        VmLogApiTranslationKey.callErrorScreenStacktrace: "Stack trace:",
        VmLogApiTranslationKey.callErrorScreenEmpty: "Nothing to display here",
        VmLogApiTranslationKey.callOverviewMethod: "Method:",
        VmLogApiTranslationKey.callOverviewServer: "Server:",
        VmLogApiTranslationKey.callOverviewEndpoint: "Endpoint:",
        VmLogApiTranslationKey.callOverviewStarted: "Started:",
        VmLogApiTranslationKey.callOverviewFinished: "Finished:",
        VmLogApiTranslationKey.callOverviewDuration: "Duration:",
        VmLogApiTranslationKey.callOverviewBytesSent: "Bytes sent:",
        VmLogApiTranslationKey.callOverviewBytesReceived: "Bytes received:",
        VmLogApiTranslationKey.callOverviewClient: "Client:",
        VmLogApiTranslationKey.callOverviewSecure: "Secure:",
        VmLogApiTranslationKey.callRequestStarted: "Started:",
        VmLogApiTranslationKey.callRequestBytesSent: "Bytes sent:",
        VmLogApiTranslationKey.callRequestContentType: "Content type:",
        VmLogApiTranslationKey.callRequestBody: "Body:",
        VmLogApiTranslationKey.callRequestBodyEmpty: "Body is empty",
        VmLogApiTranslationKey.callRequestFormDataFields: "Form data fields:",
        VmLogApiTranslationKey.callRequestFormDataFiles: "Form files:",
        VmLogApiTranslationKey.callRequestHeaders: "Headers:",
        VmLogApiTranslationKey.callRequestHeadersEmpty: "Headers are empty",
        VmLogApiTranslationKey.callRequestQueryParameters: "Query parameters",
        VmLogApiTranslationKey.callRequestQueryParametersEmpty:
            "Query parameters are empty",
        VmLogApiTranslationKey.callResponseWaitingForResponse:
            "Awaiting response...",
        VmLogApiTranslationKey.callResponseError: "Error",
        VmLogApiTranslationKey.callResponseReceived: "Received:",
        VmLogApiTranslationKey.callResponseBytesReceived: "Bytes received:",
        VmLogApiTranslationKey.callResponseStatus: "Status:",
        VmLogApiTranslationKey.callResponseHeaders: "Headers:",
        VmLogApiTranslationKey.callResponseHeadersEmpty: "Headers are empty",
        VmLogApiTranslationKey.callResponseBodyImage: "Body: Image",
        VmLogApiTranslationKey.callResponseBody: "Body:",
        VmLogApiTranslationKey.callResponseTooLargeToShow: "Too large to show",
        VmLogApiTranslationKey.callResponseBodyShow: "Show body",
        VmLogApiTranslationKey.callResponseLargeBodyShowWarning:
            'Warning! It will take some time to render output.',
        VmLogApiTranslationKey.callResponseBodyVideo: 'Body: Video',
        VmLogApiTranslationKey.callResponseBodyVideoWebBrowser:
            'Open video in web browser',
        VmLogApiTranslationKey.callResponseHeadersUnknown: "Unknown",
        VmLogApiTranslationKey.callResponseBodyUnknown:
            'Unsupported body. vm-log-api'
            ' can render video/image/text body. Response has Content-Type: '
            "[contentType] which can't be handled. If you're feeling lucky you "
            "can try button below to try render body as text, but it may fail.",
        VmLogApiTranslationKey.callResponseBodyUnknownShow:
            "Show unsupported body",
        VmLogApiTranslationKey.callsListInspector: "Inspector",
        VmLogApiTranslationKey.callsListLogger: "Logger",
        VmLogApiTranslationKey.callsListDeleteLogsDialogTitle: "Delete logs",
        VmLogApiTranslationKey.callsListDeleteLogsDialogDescription:
            "Do you want to clear logs?",
        VmLogApiTranslationKey.callsListYes: "Yes",
        VmLogApiTranslationKey.callsListNo: "No",
        VmLogApiTranslationKey.callsListDeleteCallsDialogTitle: "Delete calls",
        VmLogApiTranslationKey.callsListDeleteCallsDialogDescription:
            "Do you want to delete HTTP calls?",
        VmLogApiTranslationKey.callsListSearchHint: "Search HTTP call...",
        VmLogApiTranslationKey.callsListSort: "Sort",
        VmLogApiTranslationKey.callsListDelete: "Delete",
        VmLogApiTranslationKey.callsListStats: "Stats",
        VmLogApiTranslationKey.callsListSave: "Save",
        VmLogApiTranslationKey.logsEmpty: "There are no logs to show",
        VmLogApiTranslationKey.logsError: "Failed to display error",
        VmLogApiTranslationKey.logsItemError: "Error:",
        VmLogApiTranslationKey.logsItemStackTrace: "Stack trace:",
        VmLogApiTranslationKey.logsCopied: "Copied to clipboard.",
        VmLogApiTranslationKey.sortDialogTitle: "Select filter",
        VmLogApiTranslationKey.sortDialogAscending: 'Ascending',
        VmLogApiTranslationKey.sortDialogDescending: "Descending",
        VmLogApiTranslationKey.sortDialogAccept: "Accept",
        VmLogApiTranslationKey.sortDialogCancel: "Cancel",
        VmLogApiTranslationKey.sortDialogTime: "Create time (default)",
        VmLogApiTranslationKey.sortDialogResponseTime: "Response time",
        VmLogApiTranslationKey.sortDialogResponseCode: "Response code",
        VmLogApiTranslationKey.sortDialogResponseSize: "Response size",
        VmLogApiTranslationKey.sortDialogEndpoint: "Endpoint",
        VmLogApiTranslationKey.statsTitle: "Stats",
        VmLogApiTranslationKey.statsTotalRequests: "Total requests:",
        VmLogApiTranslationKey.statsPendingRequests: "Pending requests:",
        VmLogApiTranslationKey.statsSuccessRequests: "Success requests:",
        VmLogApiTranslationKey.statsRedirectionRequests: "Redirection requests:",
        VmLogApiTranslationKey.statsErrorRequests: "Error requests:",
        VmLogApiTranslationKey.statsBytesSent: "Bytes sent:",
        VmLogApiTranslationKey.statsBytesReceived: "Bytes received:",
        VmLogApiTranslationKey.statsAverageRequestTime: "Average request time:",
        VmLogApiTranslationKey.statsMaxRequestTime: "Max request time:",
        VmLogApiTranslationKey.statsMinRequestTime: "Min request time:",
        VmLogApiTranslationKey.statsGetRequests: "GET requests:",
        VmLogApiTranslationKey.statsPostRequests: "POST requests:",
        VmLogApiTranslationKey.statsDeleteRequests: "DELETE requests:",
        VmLogApiTranslationKey.statsPutRequests: "PUT requests:",
        VmLogApiTranslationKey.statsPatchRequests: "PATCH requests:",
        VmLogApiTranslationKey.statsSecuredRequests: "Secured requests:",
        VmLogApiTranslationKey.statsUnsecuredRequests: "Unsecured requests:",
        VmLogApiTranslationKey.notificationLoading: "Loading:",
        VmLogApiTranslationKey.notificationSuccess: "Success:",
        VmLogApiTranslationKey.notificationRedirect: "Redirect:",
        VmLogApiTranslationKey.notificationError: "Error:",
        VmLogApiTranslationKey.notificationTotalRequests:
            "vm-log-api (total [callCount] HTTP calls)",
        VmLogApiTranslationKey.saveDialogPermissionErrorTitle: "Permission error",
        VmLogApiTranslationKey.saveDialogPermissionErrorDescription:
            "Permission not granted. Couldn't save logs.",
        VmLogApiTranslationKey.saveDialogEmptyErrorTitle: "Call history empty",
        VmLogApiTranslationKey.saveDialogEmptyErrorDescription:
            "There are no calls to save.",
        VmLogApiTranslationKey.saveDialogFileSaveErrorTitle: "Save error",
        VmLogApiTranslationKey.saveDialogFileSaveErrorDescription:
            "Failed to save http calls to file.",
        VmLogApiTranslationKey.saveSuccessTitle: "Logs saved",
        VmLogApiTranslationKey.saveSuccessDescription:
            "Successfully saved logs in [path].",
        VmLogApiTranslationKey.saveSuccessView: "View file",
        VmLogApiTranslationKey.saveHeaderTitle: "vm-log-api - HTTP Inspector",
        VmLogApiTranslationKey.saveHeaderAppName: "App name:",
        VmLogApiTranslationKey.saveHeaderPackage: "Package:",
        VmLogApiTranslationKey.saveHeaderVersion: "Version:",
        VmLogApiTranslationKey.saveHeaderBuildNumber: "Build number:",
        VmLogApiTranslationKey.saveHeaderGenerated: "Generated:",
        VmLogApiTranslationKey.saveLogId: "Id:",
        VmLogApiTranslationKey.saveLogGeneralData: "General data",
        VmLogApiTranslationKey.saveLogServer: "Server:",
        VmLogApiTranslationKey.saveLogMethod: "Method:",
        VmLogApiTranslationKey.saveLogEndpoint: "Endpoint:",
        VmLogApiTranslationKey.saveLogClient: "Client:",
        VmLogApiTranslationKey.saveLogDuration: "Duration:",
        VmLogApiTranslationKey.saveLogSecured: "Secured connection:",
        VmLogApiTranslationKey.saveLogCompleted: "Completed:",
        VmLogApiTranslationKey.saveLogRequest: "Request",
        VmLogApiTranslationKey.saveLogRequestTime: "Request time:",
        VmLogApiTranslationKey.saveLogRequestContentType: "Request content type:",
        VmLogApiTranslationKey.saveLogRequestCookies: "Request cookies:",
        VmLogApiTranslationKey.saveLogRequestHeaders: "Request headers:",
        VmLogApiTranslationKey.saveLogRequestQueryParams: "Request query params:",
        VmLogApiTranslationKey.saveLogRequestSize: "Request size:",
        VmLogApiTranslationKey.saveLogRequestBody: "Request body:",
        VmLogApiTranslationKey.saveLogResponse: "Response",
        VmLogApiTranslationKey.saveLogResponseTime: "Response time:",
        VmLogApiTranslationKey.saveLogResponseStatus: "Response status:",
        VmLogApiTranslationKey.saveLogResponseSize: "Response size:",
        VmLogApiTranslationKey.saveLogResponseHeaders: "Response headers:",
        VmLogApiTranslationKey.saveLogResponseBody: "Response body:",
        VmLogApiTranslationKey.saveLogError: "Error",
        VmLogApiTranslationKey.saveLogStackTrace: "Stack trace",
        VmLogApiTranslationKey.saveLogCurl: "Curl",
        VmLogApiTranslationKey.accept: "Accept",
        VmLogApiTranslationKey.parserFailed: "Failed to parse: ",
        VmLogApiTranslationKey.unknown: "Unknown",
      },
    );
  }

  /// Builds [VmLogApiTranslationData] for polish language.
  static VmLogApiTranslationData _buildPlTranslations() {
    return VmLogApiTranslationData(
      languageCode: "pl",
      values: {
        VmLogApiTranslationKey.alice: "vm-log-api",
        VmLogApiTranslationKey.callDetails: "Połączenie HTTP - detale",
        VmLogApiTranslationKey.emailSubject: "Raport vm-log-api",
        VmLogApiTranslationKey.callDetailsRequest: "Żądanie",
        VmLogApiTranslationKey.callDetailsResponse: "Odpowiedź",
        VmLogApiTranslationKey.callDetailsOverview: "Przegląd",
        VmLogApiTranslationKey.callDetailsError: "Błąd",
        VmLogApiTranslationKey.callDetailsEmpty: "Błąd ładowania danych",
        VmLogApiTranslationKey.callErrorScreenErrorEmpty: "Brak błędów",
        VmLogApiTranslationKey.callErrorScreenError: "Błąd:",
        VmLogApiTranslationKey.callErrorScreenStacktrace: "Ślad stosu:",
        VmLogApiTranslationKey.callErrorScreenEmpty: "Brak danych do wyświetlenia",
        VmLogApiTranslationKey.callOverviewMethod: "Metoda:",
        VmLogApiTranslationKey.callOverviewServer: "Serwer:",
        VmLogApiTranslationKey.callOverviewEndpoint: "Endpoint:",
        VmLogApiTranslationKey.callOverviewStarted: "Rozpoczęto:",
        VmLogApiTranslationKey.callOverviewFinished: "Zakończono:",
        VmLogApiTranslationKey.callOverviewDuration: "Czas trwania:",
        VmLogApiTranslationKey.callOverviewBytesSent: "Bajty wysłane:",
        VmLogApiTranslationKey.callOverviewBytesReceived: "Bajty odebrane:",
        VmLogApiTranslationKey.callOverviewClient: "Klient:",
        VmLogApiTranslationKey.callOverviewSecure: "Połączenie zabezpieczone:",
        VmLogApiTranslationKey.callRequestStarted: "Ropoczęto:",
        VmLogApiTranslationKey.callRequestBytesSent: "Bajty wysłane:",
        VmLogApiTranslationKey.callRequestContentType: "Typ zawartości:",
        VmLogApiTranslationKey.callRequestBody: "Body:",
        VmLogApiTranslationKey.callRequestBodyEmpty: "Body jest puste",
        VmLogApiTranslationKey.callRequestFormDataFields: "Pola forumlarza:",
        VmLogApiTranslationKey.callRequestFormDataFiles: "Pliki formularza:",
        VmLogApiTranslationKey.callRequestHeaders: "Headery:",
        VmLogApiTranslationKey.callRequestHeadersEmpty: "Headery są puste",
        VmLogApiTranslationKey.callRequestQueryParameters: "Parametry query",
        VmLogApiTranslationKey.callRequestQueryParametersEmpty:
            "Parametry query są puste",
        VmLogApiTranslationKey.callResponseWaitingForResponse:
            "Oczekiwanie na odpowiedź...",
        VmLogApiTranslationKey.callResponseError: "Błąd",
        VmLogApiTranslationKey.callResponseReceived: "Otrzymano:",
        VmLogApiTranslationKey.callResponseBytesReceived: "Bajty odebrane:",
        VmLogApiTranslationKey.callResponseStatus: "Status:",
        VmLogApiTranslationKey.callResponseHeaders: "Headery:",
        VmLogApiTranslationKey.callResponseHeadersEmpty: "Headery są puste",
        VmLogApiTranslationKey.callResponseBodyImage: "Body: Obraz",
        VmLogApiTranslationKey.callResponseBody: "Body:",
        VmLogApiTranslationKey.callResponseTooLargeToShow: "Za duże aby pokazać",
        VmLogApiTranslationKey.callResponseBodyShow: "Pokaż body",
        VmLogApiTranslationKey.callResponseLargeBodyShowWarning:
            'Uwaga! Może zająć trochę czasu, zanim uda się wyrenderować output.',
        VmLogApiTranslationKey.callResponseBodyVideo: 'Body: Video',
        VmLogApiTranslationKey.callResponseBodyVideoWebBrowser:
            'Otwórz video w przeglądarce',
        VmLogApiTranslationKey.callResponseHeadersUnknown: "Nieznane",
        VmLogApiTranslationKey.callResponseBodyUnknown:
            'Nieznane body. vm-log-api'
            ' może renderować video/image/text. Odpowiedź ma typ zawartości:'
            "[contentType], który nie może być obsłużony.Jeżeli chcesz, możesz "
            "spróbować wyrenderować body jako tekst, ale może to się nie udać.",
        VmLogApiTranslationKey.callResponseBodyUnknownShow:
            "Pokaż nieobsługiwane body",
        VmLogApiTranslationKey.callsListInspector: "Inspektor",
        VmLogApiTranslationKey.callsListLogger: "Logger",
        VmLogApiTranslationKey.callsListDeleteLogsDialogTitle: "Usuń logi",
        VmLogApiTranslationKey.callsListDeleteLogsDialogDescription:
            "Czy chcesz usunąc logi?",
        VmLogApiTranslationKey.callsListYes: "Tak",
        VmLogApiTranslationKey.callsListNo: "Nie",
        VmLogApiTranslationKey.callsListDeleteCallsDialogTitle: "Usuń połączenia",
        VmLogApiTranslationKey.callsListDeleteCallsDialogDescription:
            "Czy chcesz usunąć zapisane połaczenia HTTP?",
        VmLogApiTranslationKey.callsListSearchHint: "Szukaj połączenia HTTP...",
        VmLogApiTranslationKey.callsListSort: "Sortuj",
        VmLogApiTranslationKey.callsListDelete: "Usuń",
        VmLogApiTranslationKey.callsListStats: "Statystyki",
        VmLogApiTranslationKey.callsListSave: "Zapis",
        VmLogApiTranslationKey.logsEmpty: "Brak rezultatów",
        VmLogApiTranslationKey.logsError: "Problem z wyświetleniem logów.",
        VmLogApiTranslationKey.logsItemError: "Błąd:",
        VmLogApiTranslationKey.logsItemStackTrace: "Ślad stosu:",
        VmLogApiTranslationKey.logsCopied: "Skopiowano do schowka.",
        VmLogApiTranslationKey.sortDialogTitle: "Wybierz filtr",
        VmLogApiTranslationKey.sortDialogAscending: 'Rosnąco',
        VmLogApiTranslationKey.sortDialogDescending: "Malejąco",
        VmLogApiTranslationKey.sortDialogAccept: "Akceptuj",
        VmLogApiTranslationKey.sortDialogCancel: "Anuluj",
        VmLogApiTranslationKey.sortDialogTime: "Czas utworzenia (domyślnie)",
        VmLogApiTranslationKey.sortDialogResponseTime: "Czas odpowiedzi",
        VmLogApiTranslationKey.sortDialogResponseCode: "Status odpowiedzi",
        VmLogApiTranslationKey.sortDialogResponseSize: "Rozmiar odpowiedzi",
        VmLogApiTranslationKey.sortDialogEndpoint: "Endpoint",
        VmLogApiTranslationKey.statsTitle: "Statystyki",
        VmLogApiTranslationKey.statsTotalRequests: "Razem żądań:",
        VmLogApiTranslationKey.statsPendingRequests: "Oczekujące żądania:",
        VmLogApiTranslationKey.statsSuccessRequests: "Poprawne żądania:",
        VmLogApiTranslationKey.statsRedirectionRequests: "Żądania przekierowania:",
        VmLogApiTranslationKey.statsErrorRequests: "Błędne żądania:",
        VmLogApiTranslationKey.statsBytesSent: "Bajty wysłane:",
        VmLogApiTranslationKey.statsBytesReceived: "Bajty otrzymane:",
        VmLogApiTranslationKey.statsAverageRequestTime: "Średni czas żądania:",
        VmLogApiTranslationKey.statsMaxRequestTime: "Maksymalny czas żądania:",
        VmLogApiTranslationKey.statsMinRequestTime: "Minimalny czas żądania:",
        VmLogApiTranslationKey.statsGetRequests: "Żądania GET:",
        VmLogApiTranslationKey.statsPostRequests: "Żądania POST:",
        VmLogApiTranslationKey.statsDeleteRequests: "Żądania DELETE:",
        VmLogApiTranslationKey.statsPutRequests: "Żądania PUT:",
        VmLogApiTranslationKey.statsPatchRequests: "Żądania PATCH:",
        VmLogApiTranslationKey.statsSecuredRequests: "Żądania zabezpieczone:",
        VmLogApiTranslationKey.statsUnsecuredRequests: "Żądania niezabezpieczone:",
        VmLogApiTranslationKey.notificationLoading: "Oczekujące:",
        VmLogApiTranslationKey.notificationSuccess: "Poprawne:",
        VmLogApiTranslationKey.notificationRedirect: "Przekierowanie:",
        VmLogApiTranslationKey.notificationError: "Błąd:",
        VmLogApiTranslationKey.notificationTotalRequests:
            "vm-log-api (razem [callCount] połączeń HTTP)",
        VmLogApiTranslationKey.saveDialogPermissionErrorTitle: "Błąd pozwolenia",
        VmLogApiTranslationKey.saveDialogPermissionErrorDescription:
            "Pozwolenie nieprzyznane. Nie można zapisać logów.",
        VmLogApiTranslationKey.saveDialogEmptyErrorTitle:
            "Pusta historia połaczeń",
        VmLogApiTranslationKey.saveDialogEmptyErrorDescription:
            "Nie ma połączeń do zapisania.",
        VmLogApiTranslationKey.saveDialogFileSaveErrorTitle: "Błąd zapisu",
        VmLogApiTranslationKey.saveDialogFileSaveErrorDescription:
            "Nie można zapisać danych do pliku.",
        VmLogApiTranslationKey.saveSuccessTitle: "Logi zapisane",
        VmLogApiTranslationKey.saveSuccessDescription: "Zapisano logi w [path].",
        VmLogApiTranslationKey.saveSuccessView: "Otwórz plik",
        VmLogApiTranslationKey.saveHeaderTitle: "vm-log-api - Inspektor HTTP",
        VmLogApiTranslationKey.saveHeaderAppName: "Nazwa aplikacji:",
        VmLogApiTranslationKey.saveHeaderPackage: "Paczka:",
        VmLogApiTranslationKey.saveHeaderVersion: "Wersja:",
        VmLogApiTranslationKey.saveHeaderBuildNumber: "Numer buildu:",
        VmLogApiTranslationKey.saveHeaderGenerated: "Wygenerowano:",
        VmLogApiTranslationKey.saveLogId: "Id:",
        VmLogApiTranslationKey.saveLogGeneralData: "Ogólne informacje",
        VmLogApiTranslationKey.saveLogServer: "Serwer:",
        VmLogApiTranslationKey.saveLogMethod: "Metoda:",
        VmLogApiTranslationKey.saveLogEndpoint: "Endpoint:",
        VmLogApiTranslationKey.saveLogClient: "Klient:",
        VmLogApiTranslationKey.saveLogDuration: "Czas trwania:",
        VmLogApiTranslationKey.saveLogSecured: "Połączenie zabezpieczone:",
        VmLogApiTranslationKey.saveLogCompleted: "Zakończono:",
        VmLogApiTranslationKey.saveLogRequest: "Żądanie",
        VmLogApiTranslationKey.saveLogRequestTime: "Czas żądania:",
        VmLogApiTranslationKey.saveLogRequestContentType:
            "Typ zawartości żądania:",
        VmLogApiTranslationKey.saveLogRequestCookies: "Ciasteczka żądania:",
        VmLogApiTranslationKey.saveLogRequestHeaders: "Heady żądania",
        VmLogApiTranslationKey.saveLogRequestQueryParams:
            "Parametry query żądania",
        VmLogApiTranslationKey.saveLogRequestSize: "Rozmiar żądania:",
        VmLogApiTranslationKey.saveLogRequestBody: "Body żądania:",
        VmLogApiTranslationKey.saveLogResponse: "Odpowiedź",
        VmLogApiTranslationKey.saveLogResponseTime: "Czas odpowiedzi:",
        VmLogApiTranslationKey.saveLogResponseStatus: "Status odpowiedzi:",
        VmLogApiTranslationKey.saveLogResponseSize: "Rozmiar odpowiedzi:",
        VmLogApiTranslationKey.saveLogResponseHeaders: "Headery odpowiedzi:",
        VmLogApiTranslationKey.saveLogResponseBody: "Body odpowiedzi:",
        VmLogApiTranslationKey.saveLogError: "Błąd",
        VmLogApiTranslationKey.saveLogStackTrace: "Ślad stosu",
        VmLogApiTranslationKey.saveLogCurl: "Curl",
        VmLogApiTranslationKey.accept: "Akceptuj",
        VmLogApiTranslationKey.parserFailed: "Problem z parsowaniem: ",
        VmLogApiTranslationKey.unknown: "Nieznane",
      },
    );
  }

  /// Returns localized value for specific [languageCode] and [key]. If value
  /// can't be selected then [key] will be returned.
  static String get({
    required String languageCode,
    required VmLogApiTranslationKey key,
  }) {
    try {
      final data = _translations.firstWhere(
        (element) => element.languageCode == languageCode,
        orElse: () => _translations.first,
      );
      final value = data.values[key] ?? key.toString();
      return value;
    } catch (error) {
      return key.toString();
    }
  }
}
