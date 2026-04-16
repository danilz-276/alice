/// Model of export result.
class VmLogApiExportResult {
  final bool success;
  final VmLogApiExportResultError? error;
  final String? path;

  VmLogApiExportResult({required this.success, this.error, this.path});
}

/// Definition of all possible export errors.
enum VmLogApiExportResultError { logGenerate, empty, permission, file }
