import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/features/auth/cubits/sign_up_cubit.dart';
import 'package:messenger_app/features/auth/cubits/sign_up_state.dart';
import 'package:messenger_app/features/auth/data/repositories/firebase_auth_repository.dart';

import 'package:messenger_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:messenger_app/features/auth/presentation/widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  final void Function()? onTap;

  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  String errorText = '';

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(context.read<FirebaseAuthRepository>()),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: BlocListener<SignUpCubit, SignUpState>(
          // if error occurs show red text
          listener: (context, state) {
            if (state.status == SignUpStatus.failure && state.errorMessage != null) {
              errorText = state.errorMessage!;
            } else {
              errorText = '';
            }
          },
          child: BlocBuilder<SignUpCubit, SignUpState>(
            builder: (context, state) {
              final cubit = context.read<SignUpCubit>();

              if (_emailController.text != state.email) {
                _emailController.text = state.email;
              }
              if (_passwordController.text != state.password) {
                _passwordController.text = state.password;
              }
              if (_confirmPasswordController.text != state.confirmPassword) {
                _confirmPasswordController.text = state.confirmPassword;
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
                    "Let's create an account",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(height: 10),
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
                  SizedBox(height: 10),
                  CustomTextfield(
                    hintText: "Confirm password",
                    obscureText: true,
                    controller: _confirmPasswordController,
                    onChanged: cubit.confirmPasswordChanged,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                    child: SizedBox(
                      height: 50,
                      child: Text(
                        maxLines: 2,
                        errorText,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red),
                      ),
                    ),
                  ),
                  CustomButton(
                    text: state.status == SignUpStatus.loading ? "Loading..." : "Sign up",
                    onTap: state.status == SignUpStatus.loading ? null : () => cubit.signUp(),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already a member? ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Login now",
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
