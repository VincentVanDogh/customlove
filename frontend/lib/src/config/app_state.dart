import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/src/app/model/collection_model.dart';
import 'package:frontend/src/app/presentation/authentification/pages/logout_page.dart';
import 'package:frontend/src/app/service/match_service.dart';
import 'package:frontend/src/app/service/message_service.dart';
import 'package:frontend/src/app/service/user_service.dart';
import 'package:frontend/src/config/api_config.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../app/api/helpers/jwt_api.dart';
import '../app/model/conversation_model.dart';
import '../app/model/match_model.dart';
import '../app/model/message_model.dart';
import '../app/model/notification_model.dart';
import '../app/model/user_model.dart';
import '../app/presentation/chat/pages/messages_page.dart';
import '../app/service/conversation_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class CollectionStorage extends ChangeNotifier {
  bool loading = false;
  bool initiated = false;
}

class UserStorage extends CollectionStorage {
  Collection<User> users = Collection<User>();
}

class ConversationStorage extends CollectionStorage {
  Collection<Conversation> conversations = Collection<Conversation>();

  Future<Conversation> addConversation(
      int userId, ConversationService conversationService) async {
    Conversation conversation =
        await conversationService.createConversation(userId);
    conversations.items.putIfAbsent(conversation.id, () => conversation);

    notifyListeners();

    return conversation;
  }
}

class MessageStorage extends CollectionStorage {
  Map<int, Collection<Message>> messages = <int, Collection<Message>>{};

  Future<void> initializeFirstPage(
      int conversationId, MessageService messageService) async {
    messages[conversationId] = Collection<Message>();

    await messages[conversationId]!
        .getNextPage(messageService.copyWith("$conversationId"));
    notifyListeners();
  }

  void addMessage(Message message, MessageService messageService) {
    if (!messages.containsKey(message.conversationId)) {
      messages[message.conversationId] = Collection<Message>();
      messages[message.conversationId]!
          .getFirst(messageService.copyWith("${message.conversationId}"));
    }

    messages[message.conversationId]!
        .items
        .putIfAbsent(message.id!, () => message);
    notifyListeners();
  }

  Future<void> getNextPage(
      int conversationId, MessageService messageService) async {
    await messages[conversationId]
        ?.getNextPage(messageService.copyWith("$conversationId"));
    notifyListeners();
  }
}

class MatchStorage extends CollectionStorage {
  Collection<Match> matches = Collection<Match>();

  void removeMatch(int index) {
    Match match = matches.items.values.elementAt(index);
    matches.items.remove(match.id);
    notifyListeners();
  }
}

class StateManager extends ChangeNotifier {
  User? _user;
  WebSocketChannel? socket;
  bool connected = false;
  int loginRetries = 10;
  bool initialized = false;

  User? get user {
    unawaited(getUser());
    return _user;
  }

  Future<void> getUser() async {
    if (_user != null) {
      return;
    }

    const FlutterSecureStorage storage = FlutterSecureStorage();
    String? u = await storage.read(key: "user");
    if (u == null) {
      return;
    }

    _user = User.fromJson(json.decode(u));
    notifyListeners();
  }

  set user(User? value) {
    if (value == null) {
      _user = value;
      return;
    }

    const FlutterSecureStorage storage = FlutterSecureStorage();
    unawaited(storage.write(key: "user", value: jsonEncode(value)));

    _user = value;
  }

  Future<void> registerUser(User user, BuildContext buildContext) async {
    // save the current user
    this.user = user;

    if (!buildContext.mounted) return;
    await connect(buildContext);
  }

  Future<void> initialize(BuildContext buildContext,
      {bool force = false}) async {
    List<Future<void>> tasks = List<Future<void>>.from({
      initializeUsers(buildContext, force: force),
      initializeConversations(buildContext, force: force),
      initializeMatches(buildContext, force: force)
    });

    for (Future<void> task in tasks) {
      await task;
    }

    initialized = true;
  }

  Future<void> initializeUsers(BuildContext buildContext,
      {bool force = false}) async {
    UserService userService = buildContext.read<UserService>();
    UserStorage userStorage =
        Provider.of<UserStorage>(buildContext, listen: false);

    if (force) {
      userStorage.initiated = false;
      userStorage.users.items.clear();
    }

    if (userStorage.initiated) {
      // make sure the loading flag is off
      userStorage.loading = false;

      // do nothing
      return;
    }

    // set the loading flag and load all users
    userStorage.loading = true;
    await userStorage.users.getAll(userService);

    userStorage.loading = false;
    userStorage.initiated = true;

    userStorage.notifyListeners();
  }

  Future<void> initializeConversations(BuildContext buildContext,
      {bool force = false}) async {
    ConversationService conversationService =
        buildContext.read<ConversationService>();
    MessageService messageService = buildContext.read<MessageService>();

    ConversationStorage conversationStorage =
        Provider.of<ConversationStorage>(buildContext, listen: false);
    MessageStorage messageStorage =
        Provider.of<MessageStorage>(buildContext, listen: false);

    if (force) {
      conversationStorage.initiated = false;
      messageStorage.initiated = false;

      conversationStorage.conversations.items.clear();
      messageStorage.messages.clear();
    }

    if (conversationStorage.initiated && messageStorage.initiated) {
      conversationStorage.loading = false;
      messageStorage.loading = false;

      return;
    }

    conversationStorage.loading = true;
    await conversationStorage.conversations.getAll(conversationService);

    conversationStorage.loading = false;
    conversationStorage.initiated = true;

    conversationStorage.notifyListeners();

    messageStorage.loading = true;
    List<Future<void>> tasks = List<Future<void>>.empty(growable: true);
    for (int c in conversationStorage.conversations.items.keys) {
      Collection<Message> m = Collection<Message>();

      // we load the first message for every conversation
      tasks.add(m.getFirst(messageService.copyWith("$c")));

      messageStorage.messages.putIfAbsent(c, () => m);
    }

    for (Future<void> task in tasks) {
      await task;
    }

    messageStorage.loading = false;
    messageStorage.initiated = true;

    messageStorage.notifyListeners();
  }

  Future<void> initializeMatches(BuildContext buildContext,
      {bool force = false}) async {
    MatchService matchService = buildContext.read<MatchService>();
    MatchStorage matchStorage =
        Provider.of<MatchStorage>(buildContext, listen: false);

    if (force) {
      matchStorage.initiated = false;
      matchStorage.matches.items.clear();
    }

    if (matchStorage.initiated) {
      matchStorage.loading = false;
      return;
    }

    matchStorage.loading = true;
    await matchStorage.matches.getAll(matchService);

    matchStorage.loading = false;

    matchStorage.notifyListeners();
  }

  Future<void> connect(BuildContext buildContext) async {
    const CustomLoveTheme theme = CustomLoveTheme();

    // get the token
    String? token = await JWTApi.retrieveAccessToken();

    // subscribe to a websocket
    socket = WebSocketChannel.connect(
        Uri.parse("${ApiConfig.socketsUrl}/users/socket/$token"));

    UserStorage userStorage =
        Provider.of<UserStorage>(buildContext, listen: false);

    socket?.stream.listen((event) async {
      NotificationModel notification =
          NotificationModel.fromJson(jsonDecode(jsonDecode(event)));
      switch (notification.type) {
        case "message":
          receiveMessage(Message.fromJson(notification.content), buildContext);
          break;
        case "refresh":
          await Provider.of<StateManager>(buildContext, listen: false)
              .initialize(buildContext, force: true);
          break;
        case "match":
          // pull new matches, conversations and messages
          await Provider.of<StateManager>(buildContext, listen: false)
              .initialize(buildContext, force: true);

          int userId = notification.content["user_id"];
          int matchId = notification.content["match_id"];
          User? user = userStorage.users.items[userId];

          if (user == null) {
            print("user $userId was null");
            return;
          }

          // ignore: use_build_context_synchronously
          showDialog(
              context: buildContext,
              builder: (context) {
                return AlertDialog(
                  title: const Text('You have a new match!'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text("You and ${user.firstName} just matched"),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          // hide the popup message
                          Navigator.pop(context);
                        },
                        child: const Text('Dismiss')),
                    TextButton(
                      child: const Text('Say hi'),
                      onPressed: () async {
                        // create a conversation
                        ConversationService conversationService =
                            Provider.of<ConversationService>(context,
                                listen: false);

                        // when the users create the conversation in the same time
                        // one of them will just land in the conversations page
                        try {
                          Conversation conversation = await Provider.of<
                                  ConversationStorage>(context, listen: false)
                              .addConversation(user.id, conversationService);
                          Provider.of<MatchStorage>(context, listen: false)
                              .removeMatch(matchId);

                          // hide the popup message
                          Navigator.pop(context);

                          // navigate to the new conversation
                          Navigator.pushNamed(context, "/home/matches/messages",
                              arguments: MessagesPageRouteArguments(
                                  user, conversation));
                        } catch (e) {
                          await Provider.of<StateManager>(buildContext,
                                  listen: false)
                              .initialize(buildContext, force: true);
                          Navigator.pop(context);
                          Navigator.pushNamed(
                              context, "/home/matches/messages");
                        }
                      },
                    ),
                  ],
                );
              });

        /*
          Fluttertoast.showToast(
            msg: "got a match with user ${notification.content}",
            webShowClose: true,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 20,
            webBgColor: theme.primaryColor,
            textColor: theme.whiteColor,
            backgroundColor: theme.primaryColor,
          ); */
      }
    }, onDone: () {
      // ignore the callback when the closeCode is null
      // the event will be handled in the onError callback
      if (socket?.closeCode == null) {
        // do nothing
        return;
      }

      // update the connected flag
      connected = false;
      notifyListeners();

      if (socket?.closeReason == "logout") {
        _user = null;
        Navigator.of(buildContext).pushNamed(
          "/logout",
          arguments: const LogoutRouteArguments(
              "You have logged in on more than 10 devices. You have been logged out of this device"),
        );

        return;
      }

      // reconnect to the webSocket if the connection has been closed
      unawaited(connect(buildContext));
    }, onError: (error) {
      // update the connected flag
      connected = false;
      notifyListeners();

      // if the retry threshold has been exceeded, logout
      if (loginRetries <= 0) {
        loginRetries = 10;
        _user = null;
        Navigator.of(buildContext).pushNamed(
          "/logout",
          arguments: const LogoutRouteArguments(
              "The server is unreachable, you have been logged out."),
        );

        return;
      }

      // TODO: there should be a sleep(x seconds)
      // TODO: implement a background worker
      loginRetries -= 1;

      // try to reconnect to the socket
      unawaited(connect(buildContext));
    });

    // set the connected flag to true
    try {
      await socket?.ready;
      connected = true;
      notifyListeners();
    } catch (e) {
      // do nothing
    }
  }

  Future<void> receiveMessage(Message message, BuildContext context) async {
    if (!context.mounted) return;
    Provider.of<MessageStorage>(context, listen: false).addMessage(
        message, Provider.of<MessageService>(context, listen: false));
  }

  Future<void> sendMessage(Message message, BuildContext context) async {
    NotificationModel notification =
        NotificationModel("message", message.toJson());
    socket?.sink.add(jsonEncode(notification));
    //if (!context.mounted) return;
  }
}

class ImageStorage extends ChangeNotifier {
  Map<int, bool> flags = {};
  Map<int, Uint8List> bytes = {};

  bool loaded(int id) {
    if (!flags.containsKey(id)) {
      flags.putIfAbsent(id, () => false);
    }

    return flags[id]!;
  }

  Uint8List? getBytes(int id) {
    if (!loaded(id)) {
      return null;
    }

    return bytes[id];
  }

  void load(int id, Uint8List b) {
    bytes[id] = b;
    flags[id] = true;
    notifyListeners();
  }
}

class ProfileImageStorage extends ChangeNotifier {
  // Shows if image with Id int loaded bool
  Map<int, bool> flags = {};
  // Actual image with id int
  Map<int, Uint8List> bytes = {};

  // Is Image with id loaded -> bool
  bool loaded(int id) {
    if (!flags.containsKey(id)) {
      flags.putIfAbsent(id, () => false);
    }

    return flags[id]!;
  }

  // Get Image with id
  Uint8List? getBytes(int id) {
    if (!loaded(id)) {
      return null;
    }

    return bytes[id];
  }

  // put image b with id in storage
  void load(int id, Uint8List b) {
    bytes[id] = b;
    flags[id] = true;
    notifyListeners();
  }
}
