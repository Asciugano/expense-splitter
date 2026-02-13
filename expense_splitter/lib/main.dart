import 'package:expense_splitter/core/constraints.dart';
import 'package:expense_splitter/views/widget_tree.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
        ),
        appBarTheme: KAppBar.appBarTheme(Colors.greenAccent, Colors.white),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.greenAccent,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: false,
        appBarTheme: KAppBar.appBarTheme(Colors.greenAccent, Colors.white),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.greenAccent,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: WidgetTree(),
    );
  }
}
