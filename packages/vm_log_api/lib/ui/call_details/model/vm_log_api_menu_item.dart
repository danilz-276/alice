import 'package:flutter/material.dart';

/// Definition of menu item used in call details.
class VmLogApiCallDetailsMenuItem {
  const VmLogApiCallDetailsMenuItem(this.title, this.iconData);

  final String title;
  final IconData iconData;
}

/// Definition of all call details menu item types.
enum VmLogApiCallDetailsMenuItemType { sort, delete, stats, save }
