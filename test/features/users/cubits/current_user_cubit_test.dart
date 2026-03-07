import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';

import 'package:messenger_app/features/auth/data/models/mock_user.dart';
import 'package:messenger_app/features/auth/data/repositories/mock_auth_repository.dart';

import 'package:messenger_app/features/users/cubits/current_user_cubit.dart';
import 'package:messenger_app/features/users/cubits/current_user_cubit_state.dart';
import 'package:messenger_app/features/users/data/repositories/mock_userdata_repository.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockUserdataRepository mockUserRepo;

  mockAuthRepo = MockAuthRepository();
  mockUserRepo = MockUserdataRepository();

// TODO: modify mock repos so that they work with Mocktail (currently more or less fakes instead of mock classes)
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
