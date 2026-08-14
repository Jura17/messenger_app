import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';

import 'package:messenger_app/features/auth/data/models/mock_user.dart';
import 'package:messenger_app/features/auth/data/repositories/fake_auth_repository.dart';

import 'package:messenger_app/features/users/presentation/cubits/current_user_cubit.dart';
import 'package:messenger_app/features/users/presentation/cubits/current_user_cubit_state.dart';
import 'package:messenger_app/features/users/data/repositories/fake_userdata_repository.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late FakeAuthRepository mockAuthRepo;
  late FakeUserdataRepository mockUserRepo;

  mockAuthRepo = FakeAuthRepository();
  mockUserRepo = FakeUserdataRepository();

  blocTest<CurrentUserCubit, CurrentUserCubitState>(
    'test description',
    build: () {
      mockAuthRepo.currentUser = MockUser(uid: 'userA', email: 'user@test.com');
      if (mockAuthRepo.currentUser == null) {
        debugPrint("no current user");
      } else {
        debugPrint(mockAuthRepo.currentUser!.uid);
      }
      return CurrentUserCubit(
        authRepo: mockAuthRepo,
        userdataRepo: mockUserRepo,
      );
    },
    act: (cubit) {
      return cubit.updateOnlineStatus(true);
    },
    verify: (_) {
      verify(() => mockUserRepo.updateOnlineStatus('userA', true)).called(1);
    },
  );
}
