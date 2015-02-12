
import 'dart:async';
import 'dart:html';
import 'dart:js';

// TODO: have an iframe

// TODO: embed codemirror

// TODO: populate the menus

// TODO: have run, run

void main() {
  Polymer.whenReady().then((_) {
    _createUi();
    Polymer.checkForUnresolvedElements(logToConsole: true);
  });
}

/**
 * TODO: doc
 */
class Polymer {
  static JsObject _polymer = context['Polymer'];

  /**
   * Return a `Future` that completes when Polymer element registration is
   * finished.
   */
  static Future whenReady() {
    Completer completer = new Completer();
    _polymer.callMethod('whenReady', [completer.complete]);
    return completer.future;
  }

  /**
   * The `waitingFor` method returns a list of `<polymer-element>` tags that
   * don't have a matching Polymer call. The `waitingFor` method does not report
   * elements that are missing HTML imports, or misspelled tags. You can use
   * this method to help diagnose page load stalls.
   */
  static List<Element> waitingFor() => _polymer.callMethod('waitingFor');

  /**
   * `Polymer.forceReady` causes Polymer to stop waiting and immediately
   * register any elements that are ready to register.
   */
  static void forceReady() => _polymer.callMethod('forceReady');

  /**
   * The `Polymer.import` method can be used to dynamically import one or more
   * HTML files. [urls] is a list of HTML import URLs. Loading is asynchronous;
   * the `Future` will complete when all imports have loaded and any custom
   * elements defined in the imports have been upgraded.
   */
  static Future import(List<String> urls) {
    Completer completer = new Completer();
    _polymer.callMethod('import',
        [new JsObject.jsify(urls), completer.complete]);
    return completer.future;
  }

  /**
   * Check for and return any elements that have not been upgraded. This is
   * normally a result of forgetting an html import.
   */
  static List<String> checkForUnresolvedElements({bool logToConsole: false}) {
    Set<String> result = new Set();

    _accept(result, document.body);

    List<String> list = result.toList();

    if (logToConsole && list.isNotEmpty) {
      window.console.error('Non-upgraded elements found: ${list}');
    }

    return list;
  }

  static void _accept(Set<String> result, Element element) {
    // Check for unresolved elements.
    String name = element.localName;

    if (name.startsWith('core-') || name.startsWith('paper-')) {
      // TODO: Is this a reliable test?
      if (element.shadowRoot == null) {
        result.add(name);
      }
    }

    // Recurse into the children.
    for (Element child in element.children) {
      _accept(result, child);
    }
  }
}

void _createUi() {
  CoreAnimatedPages pages = new CoreAnimatedPages()
    ..selected = '0'
    ..flex();
  Transitions.slideFromRight(pages);
  document.body.children.add(pages.element);

  pages.add(_createEditSection(pages));
  pages.add(_createExecuteSection(pages));
}

CoreElement _createEditSection(CoreAnimatedPages pages) {
  CoreElement section = CoreElement.section()..fit();

  CoreDrawerPanel topPanel = new CoreDrawerPanel()..forceNarrow();
  section.add(topPanel);

  // drawer
  CoreHeaderPanel headerPanel = new CoreHeaderPanel();
  topPanel.makeDrawer(headerPanel);
  topPanel.add(headerPanel);
  CoreToolbar toolbar = new CoreToolbar()..id = 'nav-header';
  toolbar.add(CoreElement.span('Dart Pad'));
  headerPanel.add(toolbar);
  CoreMenu menu = new CoreMenu();
  menu.add(new CoreItem(label: 'One'));
  menu.add(new CoreItem(label: 'Two'));
  menu.add(new CoreItem(label: 'Three'));
  menu.onCoreActivate.listen(print);
  headerPanel.add(menu);

  // main
  CoreHeaderPanel mainPanel = new CoreHeaderPanel();
  topPanel.makeMain(mainPanel);
  topPanel.add(mainPanel);
  toolbar = new CoreToolbar()..id = 'main-header';
  PaperIconButton navButton = new PaperIconButton(icon: 'menu');
  navButton.onClick.listen((_) => topPanel.togglePanel());
  toolbar.add(navButton);
  toolbar.add(CoreElement.span('Sunflower')..flex());

  // Overflow menu.
  PaperMenuButton overflowMenuButton = new PaperMenuButton();
  overflowMenuButton.add(new PaperIconButton(icon: 'more-vert'));
  PaperDropdown dropdown = new PaperDropdown()..halign = 'left'..clazz('overflow-menu');
  CoreMenu overflowMenu = new CoreMenu();
  overflowMenu.add(new PaperItem(text: 'Share'));
  overflowMenu.add(new PaperItem(text: 'Settings'));
  overflowMenu.add(new PaperItem(text: 'Help'));
  dropdown.add(overflowMenu);
  overflowMenuButton.add(dropdown);
  toolbar.add(overflowMenuButton);

  CoreElement div = CoreElement.div()
    ..clazz('bottom fit')..horizontal()..vertical();
  PaperTabs tabs = new PaperTabs()..flex();
  tabs.selected = '0';
  tabs.add(new PaperTab(name: 'dart', text: 'Dart'));
  tabs.add(new PaperTab(name: 'html', text: 'HTML'));
  tabs.add(new PaperTab(name: 'css', text: 'CSS'));
  tabs.onCoreActivate.listen(print);
  div.add(tabs);
  toolbar.add(div);

  mainPanel.add(toolbar);
  div = CoreElement.div()..clazz('content');
  div.text = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
      'eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad '
      'minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip '
      'ex ea commodo consequat.';
  mainPanel.add(div);

  PaperFab runButton = new PaperFab(icon: 'av:play-arrow')..id = 'run-button';
  runButton.onClick.listen((_) => pages.selected = '1');
  mainPanel.add(runButton);

  return section;
}

CoreElement _createExecuteSection(CoreAnimatedPages pages) {
  CoreElement section = CoreElement.section()..fit();

  CoreHeaderPanel header = new CoreHeaderPanel()..fit();
  section.add(header);

  CoreToolbar toolbar = new CoreToolbar();
  PaperIconButton backButton = new PaperIconButton(icon: 'arrow-back');
  backButton.onClick.listen((_) => pages.selected = '0');
  toolbar.add(backButton);
  toolbar.add(CoreElement.span('Sunflower')..flex());
  PaperToggleButton toggleConsoleButton = new PaperToggleButton();
  toggleConsoleButton.onCoreChange.listen((_) {
    print('${toggleConsoleButton.checked ? 'show' : 'hide'} console');
  });
  toolbar.add(toggleConsoleButton);
  PaperIconButton reRunButton = new PaperIconButton(icon: 'refresh');
  toolbar.add(reRunButton);
  PaperProgress progress = new PaperProgress()..clazz('bottom fit')..hidden();
  toolbar.add(progress);
  header.add(toolbar);

  reRunButton.onClick.listen((_) {
    progress.indeterminate = !progress.indeterminate;
    progress.hidden();
  });

  CoreElement div = CoreElement.div()..clazz('content');
  div.text = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
      'eiusmod tempor incididunt ut labore et dolore magna aliqua.';
  header.add(div);

  return section;
}

/**
 * Finds the first descendant element of this document with the given id.
 */
Element queryId(String id) => querySelector('#${id}');

/**
 * Finds the first descendant element of this document with the given id.
 */
Element $(String id) => querySelector('#${id}');

class PaperDropdown extends CoreDropdown {
  PaperDropdown() : super('paper-dropdown') {
    clazz('dropdown core-transition');
  }
  PaperDropdown.from(HtmlElement element) : super.from(element);
}

// TODO: extends paper-button-base
class PaperFab extends CoreElement {
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

// TODO: extends paper-button-base
class PaperItem extends CoreElement {
  PaperItem({String text}) : super('paper-item', text: text);
  PaperItem.from(HtmlElement element) : super.from(element);
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

class PaperToggleButton extends CoreElement {
  PaperToggleButton() : super('paper-toggle-button');
  PaperToggleButton.from(HtmlElement element) : super.from(element);

  // TODO: get checked is not corrent -
  bool get checked => _property('checked');
  set checked(bool value) => toggleAttribute('checked', value);

  bool get disabled => hasAttribute('disabled');
  set disabled(bool value) => toggleAttribute('disabled', value);

  /**
   * Fired when the checked state changes due to user interaction.
   */
  Stream get onChange => _listen('change');

  /**
   * Fired when the checked state changes.
   */
  Stream get onCoreChange => _listen('core-change');
}

class PaperProgress extends CoreElement {
  PaperProgress() : super('paper-progress');
  PaperProgress.from(HtmlElement element) : super.from(element);

  bool get indeterminate => hasAttribute('indeterminate');
  set indeterminate(bool value) => toggleAttribute('indeterminate', value);
}

class CoreAnimatedPages extends CoreSelector {
  CoreAnimatedPages() : super('core-animated-pages');
  CoreAnimatedPages.from(HtmlElement element) : super.from(element);
}

// core-drawer-panel
class CoreDrawerPanel extends CoreElement {
  CoreDrawerPanel() : super('core-drawer-panel');
  CoreDrawerPanel.from(HtmlElement element) : super.from(element);

  void forceNarrow() => toggleAttribute('forceNarrow');

  void makeDrawer(CoreElement element) =>
      element.toggleAttribute('drawer', true);

  void makeMain(CoreElement element) => element.toggleAttribute('main', true);

  /// Toggles the panel open and closed.
  void togglePanel() => _call('togglePanel');

  /// Opens the drawer.
  void openDrawer() => _call('openDrawer');

  /// Closes the drawer.
  void closeDrawer() => _call('closeDrawer');
}

class CoreDropdown extends CoreOverlay {
  CoreDropdown([String tag]) : super(tag == null ? 'core-dropdown' : tag);
  CoreDropdown.from(HtmlElement element) : super.from(element);

  String get halign => attribute('halign');
  /// Accepted values: 'left', 'right'.
  set halign(String value) => setAttribute('halign', value);

  String get valign => attribute('valign');
  /// Accepted values: 'top', 'bottom'.
  set valign(String value) => setAttribute('valign', value);
}

class CoreHeaderPanel extends CoreElement {
  CoreHeaderPanel() : super('core-header-panel');
  CoreHeaderPanel.from(HtmlElement element) : super.from(element);
}

class CoreItem extends CoreElement {
  CoreItem({String icon, String label}) : super('core-item') {
    if (label != null) this.label = label;
    if (icon != null) this.icon = icon;
  }

  CoreItem.from(HtmlElement element) : super.from(element);
}

class CoreMenu extends CoreSelector {
  CoreMenu() : super('core-menu');
  CoreMenu.from(HtmlElement element) : super.from(element);
}

class CoreOverlay extends CoreElement {
  CoreOverlay([String tag]) : super(tag == null ? 'core-overlay' : tag);
  CoreOverlay.from(HtmlElement element) : super.from(element);

  /**
   * Toggle the opened state of the overlay.
   */
  void toggle() => _call('toggle');

  /**
   * Open the overlay. This is equivalent to setting the opened property to
   * true.
   */
  void open() => _call('open');

  /**
   * Close the overlay. This is equivalent to setting the opened property to
   * false.
   */
  void close() => _call('close');
}

abstract class CoreSelector extends CoreElement {
  Stream _coreActivateStream;

  CoreSelector(String tag) : super(tag);
  CoreSelector.from(HtmlElement element) : super.from(element);

  String get selected => attribute('selected');
  set selected(String value) => setAttribute('selected', value);

  dynamic get selectedIndex => _property('selectedIndex');

  Object get selectedItem => _property('selectedItem');

  /**
   * Selects the previous item; this should be used in single selection only.
   * This will wrap to the end if [wrapped] is `true` and it is already at the
   * first item.
   */
  void selectPrevious(bool wrapped) => _call('selectPrevious', [wrapped]);

  /**
   * Selects the next item; this should be used in single selection only. This
   * will wrap to the front if [wrapped] is `true` and it is already at the last
   * item.
   */
  void selectNext(bool wrapped) => _call('selectNext', [wrapped]);

  /**
   * Fired when an item's selection state is changed. This event is fired both
   * when an item is selected or deselected.
   */
  Stream get onCoreSelect => _listen('core-select');

  /**
   * Fired when a selection is activated.
   */
  Stream get onCoreActivate => _listen('core-activate');
}

class CoreToolbar extends CoreElement {
  CoreToolbar() : super('core-toolbar');
  CoreToolbar.from(HtmlElement element) : super.from(element);
}

class WebElement {
  final HtmlElement element;

  WebElement(String tag, {String text}) : element = new Element.tag(tag) {
    if (text != null) element.text = text;
  }

  WebElement.from(this.element);

  String get tagName => element.tagName;

  String get id => attribute('id');
  set id(String value) => setAttribute('id', value);

  bool hasAttribute(String name) => element.attributes.containsKey(name);

  void toggleAttribute(String name, [bool value]) {
    if (value == null) value = !element.attributes.containsKey(name);

    if (value) {
      element.setAttribute(name, '');
    } else {
      element.attributes.remove(name);
    }
  }

  String attribute(String name) => element.getAttribute(name);

  void setAttribute(String name, [String value = '']) =>
      element.setAttribute(name, value);

  String clearAttribute(String name) => element.attributes.remove(name);

  void clazz(String _class) {
    // TODO: check that this works with spaces in the class name
    element.classes.add(_class);
  }

  set text(String value) {
    element.text = value;
  }

  /**
   * Add the given child to this element's list of children. [child] must be
   * either a `WebElement` or an `Element`.
   */
  void add(dynamic child) {
    if (child is WebElement) {
      element.children.add(child.element);
    } else if (child is Element) {
      element.children.add(element);
    } else {
      throw new ArgumentError('child must be a WebElement or an Element');
    }
  }

  Stream<Event> get onClick => element.onClick;

  void dispose() {
    if (element.parent.children.contains(element)) {
      try {
        element.parent.children.remove(element);
      } catch (e) {
        // TODO:
        print('foo');
      }
    }
  }

  String toString() => element.toString();
}

class CoreElement extends WebElement {
  static CoreElement div() => new CoreElement('div');
  static CoreElement section() => new CoreElement('section');
  static CoreElement span([String text]) => new CoreElement('span', text: text);

  JsObject _proxy;
  Map<String, Stream> _eventStreams = {};

  CoreElement(String tag, {String text}) : super(tag, text: text);
  CoreElement.from(HtmlElement element) : super.from(element);

  void hidden() => toggleAttribute('hidden');

  String get icon => attribute('icon');
  set icon(String value) => setAttribute('icon', value);

  String get label => attribute('label');
  set label(String value) => setAttribute('label', value);

  String get transitions => attribute('transitions');
  set transitions(String value) => setAttribute('transitions', value);

  // Layout types.
  void layout() => toggleAttribute('layout');
  void horizontal() => toggleAttribute('horizontal');
  void vertical() => toggleAttribute('vertical');

  // Layout params.
  void fit() => toggleAttribute('fit');
  void flex() => toggleAttribute('flex');

  dynamic _call(String methodName, [List args]) {
    if (_proxy == null) _proxy = new JsObject.fromBrowserObject(element);
    return _proxy.callMethod(methodName, args);
  }

  dynamic _property(String name) {
    if (_proxy == null) _proxy = new JsObject.fromBrowserObject(element);
    return _proxy[name];
  }

  Stream _listen(String eventName, [Function converter]) {
    if (!_eventStreams.containsKey(eventName)) {
      StreamController controller = new StreamController.broadcast();
      _eventStreams[eventName] = controller.stream;
      element.on[eventName].listen((e) {
        controller.add(converter == null ? e : converter(e));
      });
    }

    return _eventStreams[eventName];
  }
}

class Transitions {
  static void slideFromRight(CoreElement parent) => _add(parent, 'slide-from-right');

  static void _add(CoreElement parent, String transitionId) {
    String t = parent.transitions;
    t = t == null ? transitionId : '${t} ${transitionId}';
    parent.transitions = t;
  }
}
