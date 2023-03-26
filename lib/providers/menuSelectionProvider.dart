import 'package:flutter/foundation.dart';

import '../models/menuSelection.dart';

class MenuSelectionProvider with ChangeNotifier {
  final MenuSelection _menuSelection = MenuSelection();

  MenuItem? get selectedMenu => _menuSelection.selectedMenu;

  set selectedMenu(MenuItem? value) {
    _menuSelection.selectedMenu = value;
    notifyListeners();
  }
}
