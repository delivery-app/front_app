import 'dart:async';

enum NavBarItem { PROFILE, HOME, CART }

class BottomNavBarBloc {
  final StreamController<NavBarItem> _navBarController =
      StreamController<NavBarItem>.broadcast();

  NavBarItem defaultItem = NavBarItem.HOME;

  Stream<NavBarItem> get itemStream => _navBarController.stream;

  void pickItem(int i) {
    switch (i) {
      case 0:
        _navBarController.sink.add(NavBarItem.PROFILE);
        break;
      case 1:
        _navBarController.sink.add(NavBarItem.HOME);
        break;
      case 2:
        _navBarController.sink.add(NavBarItem.CART);
        break;
    }
  }

  close() {
    _navBarController?.close();
  }
}
