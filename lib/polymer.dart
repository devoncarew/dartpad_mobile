
library polymer;

import 'dart:async';
import 'dart:html';
import 'dart:js';

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
