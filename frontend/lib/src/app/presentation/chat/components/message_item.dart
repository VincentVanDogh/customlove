import 'package:flutter/cupertino.dart';
import 'package:frontend/src/app/presentation/chat/components/chat_bubble.dart';
import 'package:frontend/src/config/app_state.dart';
import 'package:provider/provider.dart';

import '../../../model/message_model.dart';
import '../../../model/user_model.dart';

class MessageItem extends StatelessWidget {
  final Message? message;
  final int? userId;

  const MessageItem(this.message, this.userId, {super.key});

  @override
  Widget build(BuildContext context) {
    // true - right, false - left
    var alignment = userId == message?.senderId ? Alignment.centerLeft : Alignment.centerRight;
    var crossAlignment = userId == message?.senderId ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    var mainAlignment = userId == message?.senderId ? MainAxisAlignment.start : MainAxisAlignment.end;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: crossAlignment,
        mainAxisAlignment: mainAlignment,
        children: [
          getMessageSender(),
          ChatBubble(
              message?.message ?? "",
              message?.receiverId == userId,
              message != null ? message!.isImage : false,
          ),
          getMessageTime()
        ],
      ),
    );
  }

  Widget getMessageSender() {
    if (userId == message?.receiverId) {
      return const Text("You");
    }

    return Consumer<UserStorage>(
      builder: (BuildContext context, UserStorage userStorage, Widget? child) {
        User? sender = userStorage.users.items[message?.senderId];
        if (sender == null) {
          return const Text("");
        }

        return Text(sender.firstName);
      },
    );
  }

  Widget getMessageTime() {
    if (message == null) {
      return const Text("");
    }

    var now = DateTime.now();
    var year = message!.timestamp.year;
    var day = message!.timestamp.day;
    var month = message!.timestamp.month;
    var minute = message!.timestamp.minute;
    var hour = message!.timestamp.hour;

    String d = "$day.$month.$year";

    if (now.year == year && now.month == month && now.day == day) {
      d = "Today";
    } else if (now.year == year) {
      d = "$day.$month";
    }

    return Text("$d ∙ $hour:$minute");
  }
}