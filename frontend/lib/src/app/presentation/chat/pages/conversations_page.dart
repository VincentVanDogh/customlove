import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/user_model.dart';
import 'package:frontend/src/app/presentation/chat/components/avatar.dart';
import 'package:frontend/src/app/presentation/chat/components/list_tile.dart';
import 'package:frontend/src/app/presentation/chat/components/titled_list.dart';
import 'package:frontend/src/app/service/conversation_service.dart';
import 'package:frontend/src/config/app_state.dart';
import 'package:provider/provider.dart';

import '../../../../config/theme.dart';
import '../../../model/conversation_model.dart';
import '../../../model/match_model.dart';
import 'messages_page.dart';

class ConversationsPage extends StatefulWidget {
  const  ConversationsPage({Key? key}) : super(key: key);

  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  @override
  Widget build(BuildContext context) {
    if (!Provider.of<StateManager>(context).initialized) {
      Provider.of<StateManager>(context).initialize(context, force: true);
    }

    ScrollController matchesScrollController = ScrollController();
    ScrollController conversationsController = ScrollController();

    User? loggedInUser = Provider.of<StateManager>(context, listen: false).user;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 2 * _customLoveTheme.universalPadding, horizontal: 0),
      child: Column(
        children: [
          Expanded(
              flex: 1,
              child: TitledList<MatchStorage>(
                title: 'Matches: ',
                emptyMessage: 'No new matches',
                controller: matchesScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: (storage) => storage.matches.items.length,
                builder: (MatchStorage matchStorage, BuildContext context, int index) {
                  return Consumer<UserStorage>(
                    builder: (BuildContext context, UserStorage userStorage, Widget? child) {
                      if (userStorage.loading) {
                        return const CircularProgressIndicator();
                      }

                      Match? match = matchStorage.matches.items.values.elementAtOrNull(index);

                      if (match == null || loggedInUser == null) {
                        return const CircularProgressIndicator();
                      }

                      User? user = userStorage.users.items[match.getOtherUserId(loggedInUser.id)];

                      if (user == null){
                        return const Text("");
                      }

                      return GestureDetector(
                        child: Avatar(user),
                        onTap: () async {
                          if (user == null) {
                            return;
                          }

                          ConversationService conversationService = Provider.of<ConversationService>(context, listen: false);
                          Conversation conversation = await Provider.of<ConversationStorage>(context, listen: false).addConversation(user.id, conversationService);
                          matchStorage.removeMatch(index);

                          // navigate to the new conversation
                          Navigator.pushNamed(
                              context,
                              "/home/matches/messages",
                              arguments: MessagesPageRouteArguments(user, conversation)
                          );
                        }
                      );
                    },
                  );
                },
              )
          ),
          Expanded(
            flex: 5,
            child: TitledList<ConversationStorage>(
              title: 'Conversations: ',
              emptyMessage: 'No new messages',
              controller: conversationsController,
              itemCount: (storage) => storage.conversations.items.length,
              scrollDirection: Axis.vertical,
              builder: (ConversationStorage conversationStorage, BuildContext context, int index) {
                return Consumer<StateManager>(
                  builder: (BuildContext context, StateManager stateManager, Widget? child) {
                    return CustomListTile (
                        userId: stateManager.user?.id,
                        conversation: conversationStorage.conversations.items.values.elementAtOrNull(index)
                    );
                  },
                );
              },
            )
          )
        ],
      ),
    );
  }
}
