import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/features/users/domain/entities/app_user_data.dart';
import 'package:messenger_app/features/users/presentation/bloc/chat_partner_event.dart';
import 'package:messenger_app/features/users/presentation/bloc/chat_partner_state.dart';
import 'package:messenger_app/features/users/domain/repositories/userdata_repository.dart';

// - Watches the chat partner's status for the currently opened conversation
class ChatPartnerBloc extends Bloc<ChatPartnerEvent, ChatPartnerState> {
  final UserdataRepository _userRepo;

  ChatPartnerBloc({
    required UserdataRepository userRepo,
  })  : _userRepo = userRepo,
        super(ChatPartnerInitial()) {
    on<WatchChatPartner>(_onWatchChatPartner);
  }

  Future<void> _onWatchChatPartner(WatchChatPartner event, Emitter<ChatPartnerState> emit) async {
    emit(ChatPartnerLoading());
    return emit.forEach<AppUserData?>(
      _userRepo.watchUser(event.uid),
      onData: (userdata) {
        return ChatPartnerLoaded(userdata);
      },
      onError: (error, stackTrace) {
        return ChatPartnerError(error.toString());
      },
    );
  }
}
