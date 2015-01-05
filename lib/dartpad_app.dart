// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dartpad_app;

import 'dart:async';
import 'dart:html';

import 'package:dartpad_ui/elements/elements.dart';

class DartpadApp extends DElement {
  PaperFab runButton;
  PaperSpinner spinner;

  DartpadApp(Element element) : super(element) {
    runButton = new PaperFab(element.shadowRoot.querySelector('#runbutton'));
    spinner = new PaperSpinner(element.shadowRoot.querySelector('#spinner'));

    runButton.onClick.listen((_) => _handleRun());
  }

  void _handleRun() {
    runButton.disabled = true;
    spinner.active = true;

    new Timer(new Duration(milliseconds: 1250), () {
      runButton.disabled = false;
      spinner.active = false;
    });
  }
}

class PaperFab extends DElement {
  PaperFab(Element element) : super(element);

  set disabled(bool value) {
    value ? setAttr('disabled', '') : clearAttr('disabled');
  }
}

class PaperSpinner extends DElement {
  PaperSpinner(Element element) : super(element);

  set active(bool value) {
    value ? setAttr('active', '') : clearAttr('active');
  }
}
