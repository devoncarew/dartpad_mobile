// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dartpad_app;

import 'dart:async';
import 'dart:html';

import 'package:dart_pad/elements/elements.dart';

class DartpadApp extends DElement {
  PaperAnimatedPages pages;

  EditPage editPage;
  ExecPage execPage;

  DartpadApp(Element element) : super(element) {
    pages = new PaperAnimatedPages(
        element.shadowRoot.querySelector('core-animated-pages'));
    editPage = new EditPage(this, pages.element.querySelector('dartpad-edit-page'));
    execPage = new ExecPage(this, pages.element.querySelector('dartpad-exec-page'));
  }

  void showExecPage() {
    pages.selected = '1';
  }

  void showEditPage() {
    pages.selected = '0';
  }
}

class EditPage extends DElement {
  final DartpadApp app;

  PaperFab runButton;
  PaperProgress progress;

  EditPage(this.app, Element element) : super(element) {
    runButton = new PaperFab(element.shadowRoot.querySelector('#runbutton'));
    progress = new PaperProgress(element.shadowRoot.querySelector('#progress'));

    runButton.onClick.listen((_) => _handleRun());
  }

  void _handleRun() {
    runButton.disabled = true;
    progress.hidden = false;
    progress.indeterminate = true;

    new Timer(new Duration(milliseconds: 1250), () {
      runButton.disabled = false;
      progress.hidden = true;
      progress.indeterminate = false;

      app.showExecPage();
    });
  }
}

class ExecPage extends DElement {
  final DartpadApp app;

  PaperFab rerunButton;
  PaperProgress progress;

  ExecPage(this.app, Element element) : super(element) {
    PaperIconButton button = new PaperIconButton(
        element.shadowRoot.querySelector('#nav-back'));
    button.onClick.listen((_) => app.showEditPage());

    rerunButton = new PaperFab(element.shadowRoot.querySelector('#rerun-button'));
    progress = new PaperProgress(element.shadowRoot.querySelector('#progress'));

    rerunButton.onClick.listen((_) => _handleRerun());
  }

  void _handleRerun() {
    rerunButton.disabled = true;
    progress.hidden = false;
    progress.indeterminate = true;

    new Timer(new Duration(milliseconds: 1250), () {
      rerunButton.disabled = false;
      progress.hidden = true;
      progress.indeterminate = false;

      app.showExecPage();
    });
  }
}

class PaperFab extends DElement {
  PaperFab(Element element) : super(element);

  set disabled(bool value) {
    value ? setAttr('disabled', '') : clearAttr('disabled');
  }
}

class PaperIconButton extends DElement {
  PaperIconButton(Element element) : super(element);
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

// core-animated-pages
class PaperAnimatedPages extends DElement {
  PaperAnimatedPages(Element element) : super(element);

  String get selected => getAttr('selected');
  set selected(String value) => setAttr('selected', value);
}
