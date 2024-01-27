import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/app/model/collection_model.dart';
import 'package:frontend/src/app/model/conversation_model.dart';
import 'package:frontend/src/app/model/message_model.dart';
import 'package:frontend/src/app/model/user_model.dart';
import 'package:frontend/src/app/presentation/chat/components/list_tile.dart';
import 'package:frontend/src/app/presentation/chat/components/titled_list.dart';
import 'package:frontend/src/app/presentation/chat/pages/conversations_page.dart';
import 'package:frontend/src/config/app_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:frontend/src/app/model/match_model.dart';

import '../utils.dart';
import 'conversations_widget_test.mocks.dart';

@GenerateMocks([StateManager, MatchStorage, ConversationStorage, UserStorage, MessageStorage])
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

  testWidgets('ConversationsPage Loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<MatchStorage>.value(value: mockMatchStorage),
          ChangeNotifierProvider<StateManager>.value(value: mockStateManager),
          ChangeNotifierProvider<ConversationStorage>.value(value: mockConversationStorage),
          ChangeNotifierProvider<UserStorage>.value(value: mockUserStorage),
          ChangeNotifierProvider<MessageStorage>.value(value: mockMessageStorage),
        ],
        child: const MaterialApp(
          home: ConversationsPage(),
        )
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(CustomListTile), findsWidgets);
    expect(find.byType(TitledList<ConversationStorage>), findsOneWidget);
    expect(find.byType(TitledList<MatchStorage>), findsOneWidget);

    expect(find.textContaining("no messages: "), findsNothing);
    expect(find.textContaining("mock_first_name"), findsWidgets);
  });
}
