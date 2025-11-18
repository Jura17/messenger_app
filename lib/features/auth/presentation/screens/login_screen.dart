import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:messenger_app/features/auth/cubits/login_cubit.dart';
import 'package:messenger_app/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:messenger_app/features/auth/presentation/widgets/app_title.dart';

import 'package:messenger_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:messenger_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:messenger_app/features/users/data/repositories/firestore_userdata_repository.dart';

class LoginScreen extends StatefulWidget {
  final void Function()? onTap;

  const LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  String errorText = '';

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
      create: (context) => LoginCubit(
        authRepo: context.read<FirebaseAuthRepository>(),
        userdataRepo: context.read<FirestoreUserdataRepository>(),
      ),
      child: Scaffold(
        body: BlocListener<LoginCubit, LoginState>(
          // if error occurs show red text
          listener: (context, state) {
            if (state.status == LoginStatus.failure && state.errorMessage != null) {
              errorText = state.errorMessage!;
            } else {
              errorText = '';
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

              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    AppTitle(),
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
                    const SizedBox(height: 10),
                    CustomTextfield(
                      hintText: "Password",
                      obscureText: true,
                      controller: _passwordController,
                      onChanged: cubit.passwordChanged,
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
                      text: state.status == LoginStatus.loading ? "Loading..." : "Login",
                      onTap: state.status == LoginStatus.loading ? null : () async => await cubit.logIn(),
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
