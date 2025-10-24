import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/features/auth/cubits/login_cubit.dart';
import 'package:messenger_app/features/auth/data/repositories/firebase_auth_repository.dart';

import 'package:messenger_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:messenger_app/features/auth/presentation/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  final void Function()? onTap;

  const LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read<FirebaseAuthRepository>()),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.failure && state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              final cubit = context.read<LoginCubit>();

              if (_emailController.text != state.email) {
                _emailController.text = state.email;
              }
              if (_passwordController.text != state.password) {
                _passwordController.text = state.password;
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.message,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "Welcome back",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  CustomTextfield(
                    hintText: "Email",
                    controller: _emailController,
                    onChanged: cubit.emailChanged,
                  ),
                  SizedBox(height: 10),
                  CustomTextfield(
                    hintText: "Password",
                    obscureText: true,
                    controller: _passwordController,
                    onChanged: cubit.passwordChanged,
                  ),
                  const SizedBox(height: 25),
                  CustomButton(
                    text: state.status == LoginStatus.loading ? "Loading..." : "Login",
                    onTap: state.status == LoginStatus.loading ? null : () => cubit.logIn(),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a member? ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Sign up now",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
