enum MenuItem { item1, item2, item3, item4, item5, item6 }

class MenuSelection {
  final menuItemType = {
    MenuItem.item1: "1",
    MenuItem.item2: "2",
    MenuItem.item3: "3",
    MenuItem.item4: "4",
    MenuItem.item5: "5",
    MenuItem.item6: "6",
  };
  MenuItem? selectedMenu;
}
