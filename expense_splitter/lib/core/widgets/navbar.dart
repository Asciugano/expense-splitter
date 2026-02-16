import 'package:expense_splitter/core/notifiers.dart';
import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentPageNotifier,
      builder: (context, currentPage, _) {
        return NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.map), label: 'Trips'),
            NavigationDestination(
              icon: Icon(Icons.payments),
              label: 'Expenses',
            ),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ],
          selectedIndex: currentPage,
          onDestinationSelected: (idx) => currentPageNotifier.value = idx,
        );
      },
    );
  }
}
