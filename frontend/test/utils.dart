import 'package:frontend/src/app/model/collection_model.dart';
import 'package:frontend/src/app/model/conversation_model.dart';
import 'package:frontend/src/app/model/match_model.dart';
import 'package:frontend/src/app/model/message_model.dart';
import 'package:frontend/src/app/model/user_model.dart';
import 'package:mockito/mockito.dart';

import 'chat/conversations_widget_test.mocks.dart';

class MockObjects {
  static User getUser(
  {
    required int id,
    String firstName = "mock_first_name",
    String lastName = "mock_last_name",
    String email = "mock.user@email.com",
    String job = "mock_job",
    String bio = "mock_bio",
    String dateOfBirth = "2000-08-03",
    int searchRadius = 80,
    int matchingAlgorithm = 1,
    int swipesLeft = 50,
    String swipeLimitResetDate = "2024-05-05",
    int genderIdentityId = 1,
    double latitude = 0,
    double longitude = 0,
    List<dynamic> interests = const <dynamic>[],
    int distance = 100
  }) {
    return User(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        job: job,
        bio: bio,
        date_of_birth: dateOfBirth,
        search_radius: searchRadius,
        matching_algorithm: matchingAlgorithm,
        swipes_left: swipesLeft,
        swipe_limit_reset_date: swipeLimitResetDate,
        gender_identity_id: genderIdentityId,
        latitude: latitude,
        longitude: longitude,
        interests: interests,
        distance: distance
    );
  }

  static Message getMessage({
    required int id,
    required int conversationId,
    required int senderId,
    required int receiverId,
    String message = "mock_message",
    DateTime? timestamp,
  }) {
    timestamp ??= DateTime.timestamp();

    return Message(
        id: id,
        conversationId: conversationId,
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp
    );
  }

  static Conversation getConversation({
    required int id,
    required int user1Id,
    required int user2Id
  }) {
    return Conversation(
        id: id,
        user1Id: user1Id,
        user2Id: user2Id
    );
  }

  static Match getMatch({
    required int id,
    required int user1Id,
    required int user2Id
  }) {
    return Match(
        id: id,
        user1Id: user1Id,
        user2Id: user2Id
    );
  }

  static (
    MockStateManager,
    MockUserStorage,
    MockConversationStorage,
    MockMatchStorage,
    MockMessageStorage
  ) getStorage({
    required User loggedInUser,
    List<User> otherUsers = const <User>[],
    List<Match> matches = const <Match>[],
    List<Conversation> conversations = const <Conversation>[],
    List<Message> messages = const <Message>[],
  }) {
    final MockStateManager mockStateManager = MockStateManager();
    final MockMatchStorage mockMatchStorage = MockMatchStorage();
    final MockConversationStorage mockConversationStorage = MockConversationStorage();
    final MockUserStorage mockUserStorage = MockUserStorage();
    final MockMessageStorage mockMessageStorage = MockMessageStorage();

    Collection<Match> matchCollection = Collection<Match>();
    Collection<Conversation> conversationCollection = Collection<Conversation>();
    Collection<User> userCollection = Collection<User>();
    Map<int, Collection<Message>> messageCollection = <int, Collection<Message>>{};

    for (var conversation in conversations) {
      conversationCollection.items.putIfAbsent(conversation.id, () => conversation);
      messageCollection.putIfAbsent(conversation.id, () => Collection<Message>());
    }

    for (var match in matches) {
      matchCollection.items.putIfAbsent(match.id, () => match);
    }

    userCollection.items.putIfAbsent(loggedInUser.id, () => loggedInUser);
    for (var user in otherUsers) {
      userCollection.items.putIfAbsent(user.id, () => user);
    }

    // initialise the sates
    when(mockStateManager.initialized).thenReturn(false);
    when(mockStateManager.user).thenReturn(loggedInUser);
    when(mockStateManager.initialize(any)).thenAnswer((_) async {});
    when(mockMatchStorage.initiated).thenReturn(false);
    when(mockConversationStorage.initiated).thenReturn(false);
    when(mockUserStorage.initiated).thenReturn(false);

    when(mockMatchStorage.matches).thenReturn(matchCollection);
    when(mockConversationStorage.conversations).thenReturn(conversationCollection);
    when(mockUserStorage.users).thenReturn(userCollection);
    when(mockMessageStorage.messages).thenReturn(messageCollection);

    when(mockUserStorage.loading).thenReturn(false);
    when(mockMatchStorage.loading).thenReturn(false);
    when(mockConversationStorage.loading).thenReturn(false);
    when(mockMessageStorage.loading).thenReturn(false);

    return (mockStateManager, mockUserStorage, mockConversationStorage, mockMatchStorage, mockMessageStorage);
  }
}