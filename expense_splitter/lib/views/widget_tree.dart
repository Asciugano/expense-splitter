import 'package:expense_splitter/core/notifiers.dart';
import 'package:expense_splitter/core/pages/home_page.dart';
import 'package:expense_splitter/core/pages/profile_page.dart';
import 'package:expense_splitter/features/auth/pages/login_page.dart';
import 'package:expense_splitter/views/widgets/navbar.dart';
import 'package:flutter/material.dart';

const List<Widget> pages = [HomePage(), ProfilePage()];

class WidgetTree extends StatefulWidget {
  static MaterialPageRoute<LoginPage> route() =>
      MaterialPageRoute(builder: (context) => LoginPage());

  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentPageNotifier,
      builder: (context, currentPage, _) {
        return Scaffold(
          appBar: AppBar(title: Text("Expenses Splitter")),
          // body: pages[currentPage],
          body: LoginPage(),
          bottomNavigationBar: Navbar(),
        );
      },
    );
  }
}
