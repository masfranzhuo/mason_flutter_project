import 'dart:io';

import '../utils/test_path.dart';

String fixture(String name) => File(testPath(name)).readAsStringSync();
