import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/features/auth/cubits/sign_up_cubit.dart';
import 'package:messenger_app/features/auth/cubits/sign_up_state.dart';
import 'package:messenger_app/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:messenger_app/features/auth/presentation/widgets/app_title.dart';

import 'package:messenger_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:messenger_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:messenger_app/features/users/data/repositories/firestore_userdata_repository.dart';

class SignUpScreen extends StatefulWidget {
  final void Function()? onTap;

  const SignUpScreen({super.key, required this.onTap});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  String errorText = '';

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(
        authRepo: context.read<FirebaseAuthRepository>(),
        userdataRepo: context.read<FirestoreUserdataRepository>(),
      ),
      child: Scaffold(
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
              final signUpCubit = context.read<SignUpCubit>();

              if (_emailController.text != state.email) {
                _emailController.text = state.email;
              }
              if (_passwordController.text != state.password) {
                _passwordController.text = state.password;
              }
              if (_confirmPasswordController.text != state.confirmPassword) {
                _confirmPasswordController.text = state.confirmPassword;
              }

              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    AppTitle(),
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
                      hintText: "Username",
                      controller: _usernameController,
                      onChanged: signUpCubit.usernameChanged,
                    ),
                    SizedBox(height: 10),
                    CustomTextfield(
                      hintText: "Email",
                      controller: _emailController,
                      onChanged: signUpCubit.emailChanged,
                    ),
                    SizedBox(height: 10),
                    CustomTextfield(
                      hintText: "Password",
                      obscureText: true,
                      controller: _passwordController,
                      onChanged: signUpCubit.passwordChanged,
                    ),
                    SizedBox(height: 10),
                    CustomTextfield(
                      hintText: "Confirm password",
                      obscureText: true,
                      controller: _confirmPasswordController,
                      onChanged: signUpCubit.confirmPasswordChanged,
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
                      onTap: state.status == SignUpStatus.loading ? null : () => signUpCubit.signUp(),
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
