
library paper;

import 'dart:async';
import 'dart:html';

import 'core.dart';

abstract class PaperButtonBase extends CoreElement {
  PaperButtonBase(String tag, {String text}) : super(tag, text: text);
  PaperButtonBase.from(HtmlElement element) : super.from(element);
}

class PaperDropdown extends CoreDropdown {
  PaperDropdown() : super('paper-dropdown') {
    clazz('dropdown core-transition');
  }
  PaperDropdown.from(HtmlElement element) : super.from(element);
}

class PaperFab extends PaperButtonBase {
  PaperFab({String icon, bool mini}) : super('paper-fab') {
    if (icon != null) this.icon = icon;
    if (mini != null) this.mini = mini;
  }

  PaperFab.from(HtmlElement element) : super.from(element);

  bool get disabled => hasAttribute('disabled');
  set disabled(bool value) => toggleAttribute('disabled', value);

  bool get mini => hasAttribute('mini');
  set mini(bool value) => toggleAttribute('mini', value);
}

class PaperIconButton extends CoreElement {
  PaperIconButton({String icon}) : super('paper-icon-button') {
    if (icon != null) this.icon = icon;
  }

  PaperIconButton.from(HtmlElement element) : super.from(element);
}

class PaperItem extends PaperButtonBase {
  PaperItem({String text, String icon}) :
      super('paper-item', text: text) {
    if (icon != null) this.icon = icon;
  }

  PaperItem.from(HtmlElement element) : super.from(element);

  void name(String value) => setAttribute('name', value);
}

// TODO: extends core-dropdown-base
class PaperMenuButton extends CoreElement {
  PaperMenuButton() : super('paper-menu-button');
  PaperMenuButton.from(HtmlElement element) : super.from(element);
}

class PaperSpinner extends CoreElement {
  PaperSpinner() : super('paper-spinner');
  PaperSpinner.from(HtmlElement element) : super.from(element);

  bool get active => hasAttribute('active');
  set active(bool value) => toggleAttribute('active', value);
}

class PaperTabs extends CoreSelector {
  PaperTabs() : super('paper-tabs');
  PaperTabs.from(HtmlElement element) : super.from(element);
}

class PaperTab extends CoreElement {
  PaperTab({String name, String text}) : super('paper-tab', text: text) {
    if (name != null) setAttribute('name', name);
  }

  PaperTab.from(HtmlElement element) : super.from(element);
}

class PaperToast extends CoreElement {
  PaperToast({String text}) : super('paper-toast') {
    if (text != null) this.text = text;
  }
  PaperToast.from(HtmlElement element) : super.from(element);

  String get text => attribute('text');
  set text(String value) => setAttribute('text', value);

  /// Set opened to true to show the toast and to false to hide it.
  bool get opened => hasAttribute('opened');
  set opened(bool value) => toggleAttribute('opened', value);

  /// Toggle the opened state of the toast.
  void toggle() => call('toggle');

  /// Show the toast for the specified duration.
  void show() => call('show');

  /// Dismiss the toast and hide it.
  void dismiss() => call('dismiss');
}

class PaperToggleButton extends CoreElement {
  PaperToggleButton() : super('paper-toggle-button');
  PaperToggleButton.from(HtmlElement element) : super.from(element);

  // TODO: get checked is not corrent -
  bool get checked => property('checked');
  set checked(bool value) => toggleAttribute('checked', value);

  bool get disabled => hasAttribute('disabled');
  set disabled(bool value) => toggleAttribute('disabled', value);

  /**
   * Fired when the checked state changes due to user interaction.
   */
  Stream get onChange => listen('change');

  /**
   * Fired when the checked state changes.
   */
  Stream get onCoreChange => listen('core-change');
}

class PaperProgress extends CoreElement {
  PaperProgress() : super('paper-progress');
  PaperProgress.from(HtmlElement element) : super.from(element);

  bool get indeterminate => hasAttribute('indeterminate');
  set indeterminate(bool value) => toggleAttribute('indeterminate', value);
}
