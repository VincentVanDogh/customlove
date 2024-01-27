import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/app/presentation/chat/components/message_input.dart';
import 'package:frontend/src/app/presentation/chat/components/message_list.dart';
import 'package:frontend/src/app/presentation/chat/pages/messages_page.dart';
import 'package:frontend/src/app/service/message_service.dart';
import 'package:frontend/src/config/app_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../utils.dart';
import 'messages_widget_test.mocks.dart';

@GenerateMocks([StateManager, MatchStorage, ConversationStorage, UserStorage, MessageStorage, MessageService])
void main() {
  final (
  mockStateManager,
  mockUserStorage,
  mockConversationStorage,
  mockMatchStorage,
  mockMessageStorage
  ) = MockObjects.getStorage(
      loggedInUser: MockObjects.getUser(id: 1),
      otherUsers: [MockObjects.getUser(id: 2)],
      matches: [MockObjects.getMatch(
          id: 1,
          user1Id: 1,
          user2Id: 2
      )],
      conversations: [MockObjects.getConversation(
          id: 1,
          user1Id: 1,
          user2Id: 2
      )],
      messages: [
        MockObjects.getMessage(
            id: 1,
            conversationId: 1,
            senderId: 1,
            receiverId: 2
        ),
        MockObjects.getMessage(
            id: 2,
            conversationId: 1,
            senderId: 2,
            receiverId: 1
        ),
      ]
  );

  testWidgets('MessagesPage Loads', (WidgetTester tester) async {
    MessagesPageRouteArguments args = MessagesPageRouteArguments(mockUserStorage.users.items[1]!, MockObjects.getConversation(
        id: 1,
        user1Id: 1,
        user2Id: 2
    ));

    final mockMessageService = MockMessageService();

    await tester.pumpWidget(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<MatchStorage>.value(value: mockMatchStorage),
            ChangeNotifierProvider<StateManager>.value(value: mockStateManager),
            ChangeNotifierProvider<ConversationStorage>.value(value: mockConversationStorage),
            ChangeNotifierProvider<UserStorage>.value(value: mockUserStorage),
            ChangeNotifierProvider<MessageStorage>.value(value: mockMessageStorage),
            Provider<MessageService>.value(value: mockMessageService)
          ],
          child: MaterialApp(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                settings: RouteSettings(arguments: args),
                builder: (context) {
                  return const MessagesPage();
                },
              );
            },
          )
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(MessageList), findsWidgets);
    expect(find.byType(MessageInput), findsOneWidget);
  });
}
