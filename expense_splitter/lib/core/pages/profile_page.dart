import 'package:expense_splitter/core/notifiers.dart';
import 'package:expense_splitter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_splitter/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('ProfilePage'),
          Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                _showVerification(context);
              },
              child: Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  void _showVerification(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              top: 16,
              right: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: OutlinedButton(
                    // TODO: abbellire
                    onPressed: () => Navigator.pop(context),
                    child: Text('Deny'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogout());
                      Navigator.pushReplacement(context, LoginPage.route());
                      currentPageNotifier.value = 0;
                    },
                    child: Text('Logout'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
