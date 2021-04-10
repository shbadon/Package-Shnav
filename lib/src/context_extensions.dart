import 'package:flutter/material.dart';
import 'package:shnav/shnav.dart';

/// Extensions for general basic [Context]
extension Extensions on BuildContext {
  /// use:- context.shNav.push(Uri(path:'/'));
  ShNavManager get shNav => ShNavDelegate.of(this);
}
