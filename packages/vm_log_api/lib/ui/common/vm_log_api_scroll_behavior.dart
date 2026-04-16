import 'dart:ui';

import 'package:flutter/material.dart';

/// Scroll behavior for VmLogApi.
class VmLogApiScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
