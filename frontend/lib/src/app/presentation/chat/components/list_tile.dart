import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/chat/components/avatar.dart';
import 'package:frontend/src/app/presentation/chat/pages/messages_page.dart';
import 'package:frontend/src/config/app_state.dart';
import 'package:provider/provider.dart';

import '../../../model/conversation_model.dart';
import '../../../model/message_model.dart';
import '../../../model/user_model.dart';

class CustomListTile extends StatelessWidget {
  final int? userId;
  final Conversation? conversation;

  const CustomListTile(
      {required this.userId, required this.conversation, super.key});

  @override
  Widget build(BuildContext context) {
    if (userId == null || conversation == null) {
      return const ListTile();
    }

    return Material(
      child: ListTile(
        onTap: () {
          final userStorage = Provider.of<UserStorage>(context, listen: false);
          User? recipient =
              userStorage.users.items[conversation?.getOtherUserId(userId)];

          if (recipient == null || conversation == null) {
            // do nothing
            return;
          }

          Navigator.pushNamed(context, "/home/matches/messages",
              arguments: MessagesPageRouteArguments(recipient, conversation!));
        },
        title: Consumer<UserStorage>(
          builder:
              (BuildContext context, UserStorage userStorage, Widget? child) {
            if (userStorage.loading) {
              return const CircularProgressIndicator();
            }

            User? recipient =
                userStorage.users.items[conversation?.getOtherUserId(userId)];
            if (recipient == null) {
              return const Text("");
            }

            return Text("${recipient.firstName} ${recipient.lastName}");
          },
        ),
        subtitle: Consumer<MessageStorage>(
          builder: (BuildContext context, MessageStorage messageStorage,
              Widget? child) {
            if (messageStorage.loading) {
              return const CircularProgressIndicator();
            }

            Message? message = messageStorage
                .messages[conversation?.id]?.items.values.lastOrNull;
            if (message == null) {
              return const Text("no messages");
            }

            return Text(message.getPreview());
          },
        ),
        leading: Consumer<UserStorage>(
          builder:
              (BuildContext context, UserStorage userStorage, Widget? child) {
            if (userStorage.loading) {
              return const CircularProgressIndicator();
            }

            User? user =
                userStorage.users.items[conversation?.getOtherUserId(userId)];
            if (user == null) {
              return Avatar.withImage(user!);
            }

            return Avatar(user);
          },
        ),
      ),
    );
  }
}
