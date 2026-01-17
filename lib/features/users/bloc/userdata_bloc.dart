import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/users/bloc/userdata_event.dart';
import 'package:messenger_app/features/users/bloc/userdata_state.dart';
import 'package:messenger_app/features/users/data/models/user_data.dart';
import 'package:messenger_app/features/users/data/repositories/userdata_repository.dart';

class UserdataBloc extends Bloc<UserdataEvent, UserdataState> {
  final UserdataRepository _userRepo;

  UserdataBloc({
    required UserdataRepository userRepo,
  })  : _userRepo = userRepo,
        super(UserdataInitial()) {
    on<WatchUserdata>(_onWatchUserdata);
  }

  @override
  void onChange(Change<UserdataState> change) {
    print(change);
    super.onChange(change);
  }

  @override
  Future<void> close() {
    print("CLOSED");
    return super.close();
  }

  Future<void> _onWatchUserdata(WatchUserdata event, Emitter<UserdataState> emit) async {
    emit(UserdataLoading());
    print("on watch");
    return emit.forEach<Userdata?>(
      _userRepo.watchUserStream(event.uid),
      onData: (userdata) => UserdataLoaded(userdata),
    );
  }
}
