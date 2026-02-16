import 'package:expense_splitter/core/widgets/navbar.dart';
import 'package:expense_splitter/features/trips/presentation/pages/trips_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static MaterialPageRoute<HomePage> route() =>
      MaterialPageRoute(builder: (context) => HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Expense Splitter")),
      body: TripPage(),
      bottomNavigationBar: Navbar(),
    );
  }
}
