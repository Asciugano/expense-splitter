import 'package:expense_splitter/core/constraints.dart';
import 'package:expense_splitter/core/pages/home_page.dart';
import 'package:expense_splitter/core/utils/show_snackbar.dart';
import 'package:expense_splitter/core/widgets/loader.dart';
import 'package:expense_splitter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_splitter/features/auth/presentation/pages/login_page.dart';
import 'package:expense_splitter/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  static MaterialPageRoute<RegisterPage> route() =>
      MaterialPageRoute(builder: (context) => RegisterPage());

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
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
          if (state is AuthLogout) showSnackBar(context, 'Logout successfully');
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
                    'Register',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 30),
                  AuthField(hintText: 'name', controller: nameController),

                  const SizedBox(height: 15),
                  AuthField(hintText: 'email', controller: emailController),

                  const SizedBox(height: 15),
                  AuthField(
                    hintText: 'password',
                    controller: passwordController,
                    isPassword: true,
                  ),

                  const SizedBox(height: 20),
                  FilledButton(
                    child: Text('Register'),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                          AuthRegister(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            name: nameController.text.trim(),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => Navigator.push(context, LoginPage.route()),
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Login',
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
