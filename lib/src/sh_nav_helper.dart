import 'package:flutter/material.dart';

/// [PageBuilder] it use for build NavPage screen.
typedef PageBuilder = Widget Function(Uri path, dynamic params);

/// [initializePath] it use for set NavPage screen (path)
dynamic? initializeParams;

/// [initializePath] it use for set NavPage screen (params)
Uri initializePath = Uri(path: '/');
