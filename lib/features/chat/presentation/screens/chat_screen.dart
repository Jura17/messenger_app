import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/features/auth/data/repositories/firebase_auth_repository.dart';

import 'package:messenger_app/features/chat/data/repositories/firestore_chat_repository.dart';

import 'package:messenger_app/features/chat/presentation/widgets/message_list.dart';
import 'package:messenger_app/features/chat/presentation/widgets/message_input.dart';
import 'package:messenger_app/features/users/bloc/userdata_bloc.dart';
import 'package:messenger_app/features/users/bloc/userdata_state.dart';

class ChatScreen extends StatefulWidget with WidgetsBindingObserver {
  final String chatPartnerEmail;
  final String chatPartnerId;
  final DateTime lastSeen;

  const ChatScreen({
    super.key,
    required this.chatPartnerEmail,
    required this.chatPartnerId,
    required this.lastSeen,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottom = false;

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
    _scrollController.addListener(_scrollListener);

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        _scrollDown();
        if (mounted) {
          final currentUser = context.read<FirebaseAuthRepository>().getCurrentUser();
          context.read<FirestoreChatRepository>().markMessagesAsRead(widget.chatPartnerId, currentUser);
        }
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
    final onlineStatus = DateTime.now().second - widget.lastSeen.second < 15
        ? "online"
        : "last seen at ${DateFormat.Hms().format(widget.lastSeen)}";

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.chatPartnerEmail),
            BlocBuilder<UserdataBloc, UserdataState>(builder: (context, state) {
              if (state is UserdataLoading) {
                return Text("Loading user status...");
              }
              if (state is UserdataError) {
                debugPrint(state.errorText);
              }
              if (state is UserdataLoaded) {
                return Text(
                  state.userdata!.lastSeen.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              }
              return Text(
                "Unknown user status error",
                style: Theme.of(context).textTheme.bodyMedium,
              );
            }),
            Text(
              onlineStatus,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
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
            )
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
