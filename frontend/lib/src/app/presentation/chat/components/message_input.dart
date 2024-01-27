import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/chat/components/popup_menu.dart';
import 'package:frontend/src/config/app_state.dart';
import 'package:provider/provider.dart';

import '../../../model/message_model.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController textInputController;
  final int conversationId;
  final int senderId;
  final int receiverId;

  const MessageInput(this.textInputController, this.conversationId,
      this.senderId, this.receiverId,
      {super.key});

  Future<void> sendMessage(BuildContext context) async {
    if (textInputController.text.isEmpty) {
      return;
    }

    Message message = Message(
      conversationId: conversationId,
      senderId: senderId,
      receiverId: receiverId,
      message: textInputController.text,
      timestamp: DateTime.now(),
    );

    Provider.of<StateManager>(context, listen: false)
        .sendMessage(message, context);
    textInputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        children: [
          PopupMenu(receiverId),
          Expanded(
              child: TextField(
            decoration: const InputDecoration(
              hintText: "Enter your message ...",
            ),
            controller: textInputController,
            obscureText: false,
            autofocus: true,
            maxLines: null,
          )),
          IconButton(
              onPressed: () => sendMessage(context),
              icon: const Icon(
                Icons.send,
                size: 40,
              )),
        ],
      ),
    );
  }
}
