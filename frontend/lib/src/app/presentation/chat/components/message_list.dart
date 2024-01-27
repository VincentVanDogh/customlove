import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/chat/components/message_item.dart';
import 'package:frontend/src/app/service/message_service.dart';
import 'package:frontend/src/config/app_state.dart';
import 'package:provider/provider.dart';

import '../../../../config/theme.dart';
import '../../../model/conversation_model.dart';

class MessageList extends StatefulWidget {
  final Conversation conversation;
  final int userId;
  bool loading = false;

  MessageList(this.conversation, this.userId, {super.key});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();

    controller.addListener(() async {
      // if the scroll is at the top
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() {
          widget.loading = true;
        });
        try {
          await Provider.of<MessageStorage>(context, listen: false).getNextPage(
              widget.conversation.id,
              Provider.of<MessageService>(context, listen: false)
          );
        } finally {
          setState(() {
            widget.loading = false;
          });
        }
      }
    });

    return Consumer<MessageStorage>(
      builder: (BuildContext context, MessageStorage messageStore, Widget? child) {
        var messages = messageStore.messages[widget.conversation.id];
        if (messages == null) {
          return ListView(children: const [],);
        }

        int length = widget.loading ? messages.items.length + 1 : messages.items.length;

        return ListView.separated(
            controller: controller,
            reverse: true,
            itemBuilder: (BuildContext context, int index) {
              // insert the loading icon at the last place
              if (widget.loading && index == length - 1) {
                return const CircularProgressIndicator();
              }

              // reverse the messages
              return MessageItem(messages.items.values.elementAtOrNull(messages.items.length - index - 1), widget.userId);
            },
            separatorBuilder: (BuildContext context, int index) => SizedBox(height: _customLoveTheme.universalPadding,),
            itemCount: length,
        );
      },
    );
  }
}