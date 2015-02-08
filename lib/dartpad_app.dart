// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dartpad_app;

import 'dart:async';
import 'dart:html';

import 'package:dart_pad/elements/elements.dart';

class DartpadApp extends DElement {
  PaperFab runButton;
  //PaperSpinner spinner;
  PaperProgress progress;

  DartpadApp(Element element) : super(element) {
    runButton = new PaperFab(element.shadowRoot.querySelector('#runbutton'));
    //spinner = new PaperSpinner(element.shadowRoot.querySelector('#spinner'));
    progress = new PaperProgress(element.shadowRoot.querySelector('#progress'));

    runButton.onClick.listen((_) => _handleRun());
  }

  void _handleRun() {
    runButton.disabled = true;
    //spinner.active = true;
    progress.hidden = false;
    progress.indeterminate = true;

    new Timer(new Duration(milliseconds: 1250), () {
      runButton.disabled = false;
      //spinner.active = false;
      progress.hidden = true;
      progress.indeterminate = false;
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

class PaperProgress extends DElement {
  PaperProgress(Element element) : super(element);

  set indeterminate(bool value) {
    value ? setAttr('indeterminate', '') : clearAttr('indeterminate');
  }

  set hidden(bool value) {
    value ? setAttr('hidden', '') : clearAttr('hidden');
  }
}
