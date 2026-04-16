/// Definition of data holder of form data file.
class VmLogApiFormDataFile {
  const VmLogApiFormDataFile(this.fileName, this.contentType, this.length);

  final String? fileName;
  final String contentType;
  final int length;
}
