import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/features/auth/data/repositories/auth_repository.dart';

import 'package:messenger_app/features/chat/data/repositories/chat_repository.dart';

import 'package:messenger_app/features/chat/presentation/widgets/message_list.dart';
import 'package:messenger_app/features/chat/presentation/widgets/message_input.dart';
import 'package:messenger_app/features/users/bloc/current_user_bloc.dart';
import 'package:messenger_app/features/users/bloc/current_user_state.dart';

class ChatScreen extends StatefulWidget with WidgetsBindingObserver {
  final String chatPartnerEmail;
  final String chatPartnerId;

  const ChatScreen({
    super.key,
    required this.chatPartnerEmail,
    required this.chatPartnerId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottom = false;
  String onlineStatus = "online";

  void _scrollListener() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;

    // show scroll-to-bottom if necessary
    if (offset < maxScroll && !_showScrollToBottom) {
      setState(() {
        _showScrollToBottom = true;
      });
    } else if (offset >= maxScroll && _showScrollToBottom) {
      setState(() {
        _showScrollToBottom = false;
      });
    }
  }

  // only scroll if necessary
  void _scrollDown() {
    if (_scrollController.hasClients && _scrollController.position.maxScrollExtent > 0) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final authRepo = context.read<AuthRepository>();
    final chatRepo = context.read<ChatRepository>();
    _scrollController.addListener(_scrollListener);

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        _scrollDown();

        final currentUser = authRepo.getCurrentUser();
        chatRepo.markMessagesAsRead(widget.chatPartnerId, currentUser);
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.chatPartnerEmail),
            BlocBuilder<CurrentUserBloc, CurrentUserState>(builder: (context, state) {
              if (state is CurrentUserLoading) {
                return Text("Loading user status...");
              }
              if (state is CurrentUserError) {
                debugPrint(state.errorText);
              }
              if (state is CurrentUserLoaded) {
                final isOnline = state.userdata!.isOnline;
                final lastSeen = state.userdata!.lastSeen;

                if (!isOnline) {
                  onlineStatus = "last seen at ${DateFormat.Hm().format(lastSeen)}";
                } else {
                  onlineStatus = "online";
                }

                return Text(
                  onlineStatus,
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              }
              return Text(
                "Unknown user status error",
                style: Theme.of(context).textTheme.bodyMedium,
              );
            }),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: MessageList(
                scrollController: _scrollController,
                chatPartnerId: widget.chatPartnerId,
              ),
            ),
            MessageInput(
              scrollDown: _scrollDown,
              receiverId: widget.chatPartnerId,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      floatingActionButton: _showScrollToBottom
          ? GestureDetector(
              onTap: _scrollDown,
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 70),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, shape: BoxShape.circle),
                child: const Icon(
                  Icons.expand_more,
                  size: 30,
                ),
              ),
            )
          : null,
    );
  }
}
