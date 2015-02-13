// Copyright (c) 2014, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:dartpad_mobile/dartpad_app.dart';

void main() {
  // TODO: We need a more rigorous way to determine when polymer has been
  // upgraded.
  bool unresolved = document.body.attributes.containsKey('unresolved');

  if (!unresolved) {
    _init();
  } else {
    document.addEventListener('polymer-ready', (e) => _init());
  }
}

void _init() {
  DartpadApp app = new DartpadApp(querySelector('dartpad-app'));
}
