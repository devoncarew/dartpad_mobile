
import 'package:dartpad_mobile/mobile.dart' as mobile;
import 'package:dartpad_mobile/polymer.dart';

void main() {
  Polymer.whenReady().then((_) {
    mobile.init();

    Polymer.checkForUnresolvedElements(logToConsole: true);
  });
}
