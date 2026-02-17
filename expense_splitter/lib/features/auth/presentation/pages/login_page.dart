import 'package:expense_splitter/core/constraints.dart';
import 'package:expense_splitter/core/pages/home_page.dart';
import 'package:expense_splitter/core/utils/show_snackbar.dart';
import 'package:expense_splitter/core/widgets/loader.dart';
import 'package:expense_splitter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_splitter/features/auth/presentation/pages/register_page.dart';
import 'package:expense_splitter/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static MaterialPageRoute<LoginPage> route() =>
      MaterialPageRoute(builder: (context) => LoginPage());

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) showSnackBar(context, state.message);
          if (state is AuthSuccess) {
            Navigator.pushReplacement(context, HomePage.route());
          }
          if (state is AuthLogout) {
            showSnackBar(context, 'Logout out successfully');
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Loader();
          }

          return Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 30),
                  AuthField(hintText: 'email', controller: emailController),

                  const SizedBox(height: 15),
                  AuthField(
                    hintText: 'password',
                    controller: passwordController,
                    isPassword: true,
                  ),

                  const SizedBox(height: 100),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(20),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            AuthLogin(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            ),
                          );
                        }
                      },
                      child: Text('Login'),
                    ),
                  ),

                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => Navigator.push(context, RegisterPage.route()),
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: KColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
