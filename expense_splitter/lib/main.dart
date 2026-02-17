import 'package:expense_splitter/core/constraints.dart';

import 'package:expense_splitter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_splitter/features/auth/presentation/pages/login_page.dart';
import 'package:expense_splitter/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:expense_splitter/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<TripsBloc>()),
      ],
      child: App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    context.read<AuthBloc>().add(AuthIsUserLogged());
  }

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
        appBarTheme: KAppBar.appBarTheme(KColors.primary, Colors.white),
        colorScheme: ColorScheme.fromSeed(
          seedColor: KColors.primary,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: false,
        appBarTheme: KAppBar.appBarTheme(KColors.primary, Colors.white),
        colorScheme: ColorScheme.fromSeed(
          seedColor: KColors.primary,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const LoginPage(),
    );
  }
}
