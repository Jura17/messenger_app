import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/auth/bloc/auth_bloc.dart';

import 'package:messenger_app/features/auth/bloc/auth_state.dart';
import 'package:messenger_app/features/auth/data/repositories/firebase_auth_repository.dart';

import 'package:messenger_app/features/auth/presentation/screens/login_or_signup.dart';
import 'package:messenger_app/features/users/cubits/current_user_cubit.dart';
import 'package:messenger_app/features/users/data/repositories/firestore_userdata_repository.dart';

import 'package:messenger_app/navigation_scaffold.dart';

// class AuthGate extends StatelessWidget {
//   const AuthGate({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<AuthBloc, AuthState>(
//         builder: (context, state) {
//           if (state is Authenticated) {
//             return const NavigationScaffold();
//           } else if (state is AuthError) {
//             return Center(child: Text("Error: ${state.message}"));
//           } else {
//             return const LoginOrSignup();
//           }
//         },
//       ),
//     );
//   }
// }

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return BlocProvider(
              create: (_) => CurrentUserCubit(
                authRepo: context.read<FirebaseAuthRepository>(),
                userdataRepo: context.read<FirestoreUserdataRepository>(),
              )..loadCurrentUser(),
              child: const NavigationScaffold(),
            );
          } else if (state is AuthError) {
            return Center(child: Text("Error: ${state.message}"));
          } else {
            return const LoginOrSignup();
          }
        },
      ),
    );
  }
}
