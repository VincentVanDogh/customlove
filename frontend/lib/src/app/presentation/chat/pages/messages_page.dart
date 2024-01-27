import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/chat/components/message_input.dart';
import 'package:frontend/src/app/presentation/chat/components/message_list.dart';
import 'package:provider/provider.dart';

import '../../../../config/app_state.dart';
import '../../../../config/theme.dart';
import '../../../model/conversation_model.dart';
import '../../../model/user_model.dart';
import '../../../service/message_service.dart';

class MessagesPageRouteArguments {
  User user;
  Conversation conversation;

  MessagesPageRouteArguments(this.user, this.conversation);
}

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as MessagesPageRouteArguments;
    final TextEditingController _textInputController = TextEditingController();
    const CustomLoveTheme _theme = CustomLoveTheme();

    Provider.of<MessageStorage>(context, listen: false).initializeFirstPage(
        args.conversation.id,
        Provider.of<MessageService>(context, listen: false));

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: _theme.universalPadding,
          vertical: _theme.universalPadding),
      child: Column(
        children: [
          Expanded(
            child: MessageList(args.conversation, args.user.id),
          ),
          MessageInput(_textInputController, args.conversation.id,
              args.conversation.getOtherUserId(args.user.id)!, args.user.id),
        ],
      ),
    );
  }
}
