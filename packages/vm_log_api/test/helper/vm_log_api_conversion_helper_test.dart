import 'package:vm_log_api/helper/vm_log_api_conversion_helper.dart';
import 'package:test/test.dart';

void main() {
  group("VmLogApiConversionHelper", () {
    test("should format bytes", () {
      expect(VmLogApiConversionHelper.formatBytes(-100), "-1 B");
      expect(VmLogApiConversionHelper.formatBytes(0), "0 B");
      expect(VmLogApiConversionHelper.formatBytes(100), "100 B");
      expect(VmLogApiConversionHelper.formatBytes(999), "999 B");
      expect(VmLogApiConversionHelper.formatBytes(1000), "1000 B");
      expect(VmLogApiConversionHelper.formatBytes(1001), "1.00 kB");
      expect(VmLogApiConversionHelper.formatBytes(100000), "100.00 kB");
      expect(VmLogApiConversionHelper.formatBytes(1000000), "1000.00 kB");
      expect(VmLogApiConversionHelper.formatBytes(1000001), "1.00 MB");
      expect(VmLogApiConversionHelper.formatBytes(100000000), "100.00 MB");
    });

    test("should format time", () {
      expect(VmLogApiConversionHelper.formatTime(-100), "-1 ms");
      expect(VmLogApiConversionHelper.formatTime(0), "0 ms");
      expect(VmLogApiConversionHelper.formatTime(100), "100 ms");
      expect(VmLogApiConversionHelper.formatTime(1000), "1000 ms");
      expect(VmLogApiConversionHelper.formatTime(1001), "1.00 s");
      expect(VmLogApiConversionHelper.formatTime(5000), "5.00 s");
      expect(VmLogApiConversionHelper.formatTime(60000), "60.00 s");
      expect(VmLogApiConversionHelper.formatTime(60001), "1 min 0 s 1 ms");
      expect(VmLogApiConversionHelper.formatTime(85000), "1 min 25 s 0 ms");
    });
  });
}
