import 'package:flutter/material.dart';
import 'package:frontend/src/app/api/expert_sys_api.dart';
import 'package:frontend/src/app/api/picture_api.dart';
import 'package:frontend/src/app/presentation/authentification/pages/logout_page.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_location.dart';
import 'package:frontend/src/app/presentation/swipe/util/swipe_state_notifier.dart';
import 'package:frontend/src/app/presentation/swipe/util/algo_id_notifier.dart';
import 'package:frontend/src/app/presentation/utils/CustomScrollBehaviour.dart';
import 'package:frontend/src/app/service/conversation_service.dart';
import 'package:frontend/src/app/service/expert_sys_service.dart';
import 'package:frontend/src/app/service/image_service.dart';
import 'package:frontend/src/app/service/match_service.dart';
import 'package:frontend/src/app/service/message_service.dart';
import 'package:frontend/src/app/api/registration_api.dart';
import 'package:frontend/src/app/service/registration_service.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:frontend/src/app/presentation/authentification/pages/login_page.dart';
import 'package:frontend/src/app/presentation/home/pages/home.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'app/api/conversation_api.dart';
import 'app/api/login_api.dart';
import 'app/api/match_api.dart';
import 'app/api/message_api.dart';
import 'app/api/user_api.dart';
import 'app/api/swipe_status_api.dart';
import 'app/service/login_service.dart';
import 'app/service/user_service.dart';
import 'app/service/swipe_status_service.dart';
import 'config/app_state.dart';

enum CustomLoveRoute { login, profile, swipe, matches, messages }

void main() {
  runApp(const CustomLove());
}

class CustomLove extends StatelessWidget {
  const CustomLove({Key? key}) : super(key: key);

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  @override
  Widget build(BuildContext context) {
    final http.Client httpClient = http.Client();
    return MultiProvider(
      providers: [
        //ChangeNotifierProvider<CustomLoveState>(create: (context) => CustomLoveState()),
        ChangeNotifierProvider<StateManager>(create: (_) => StateManager()),
        ChangeNotifierProvider<UserStorage>(create: (_) => UserStorage()),
        ChangeNotifierProvider<ConversationStorage>(
            create: (_) => ConversationStorage()),
        ChangeNotifierProvider<MessageStorage>(create: (_) => MessageStorage()),
        ChangeNotifierProvider<MatchStorage>(create: (_) => MatchStorage()),
        ChangeNotifierProvider<ImageStorage>(create: (_) => ImageStorage()),
        ChangeNotifierProvider<ProfileImageStorage>(
            create: (_) => ProfileImageStorage()),
        ChangeNotifierProvider(create: (context) => AlgoIdNotifier()),
        ChangeNotifierProvider(create: (context) => SwipeStateNotifier()),
        Provider<http.Client>.value(value: httpClient),
        ProxyProvider<http.Client, UserApi>(
          update: (_, httpClient, __) => UserApi(httpClient),
        ),
        ProxyProvider<UserApi, UserService>(
          update: (_, userApi, __) => UserService(userApi),
        ),
        ProxyProvider<http.Client, LoginApi>(
          update: (_, httpClient, __) => LoginApi(httpClient: httpClient),
        ),
        ProxyProvider<LoginApi, LoginService>(
          update: (_, loginApi, __) => LoginService(loginApi),
        ),
        ProxyProvider<http.Client, RegistrationApi>(
          update: (_, httpClient, __) =>
              RegistrationApi(httpClient: httpClient),
        ),
        ProxyProvider<RegistrationApi, RegistrationService>(
          update: (_, registrationApi, __) =>
              RegistrationService(registrationApi),
        ),
        ProxyProvider<http.Client, ConversationApi>(
          update: (_, httpClient, __) => ConversationApi(httpClient),
        ),
        ProxyProvider<ConversationApi, ConversationService>(
          update: (_, conversationApi, __) =>
              ConversationService(conversationApi),
        ),
        ProxyProvider<http.Client, MatchApi>(
          update: (_, httpClient, __) => MatchApi(httpClient),
        ),
        ProxyProvider<MatchApi, MatchService>(
          update: (_, matchApi, __) => MatchService(matchApi),
        ),
        ProxyProvider<http.Client, MessageApi>(
          update: (_, httpClient, __) => MessageApi(httpClient),
        ),
        ProxyProvider<MessageApi, MessageService>(
          update: (_, messageApi, __) => MessageService(messageApi),
        ),
        ProxyProvider<http.Client, SwipeStatusApi>(
          update: (_, httpClient, __) => SwipeStatusApi(httpClient: httpClient),
        ),
        ProxyProvider<SwipeStatusApi, SwipeStatusService>(
          update: (_, swipeStatusApi, __) => SwipeStatusService(swipeStatusApi),
        ),
        ProxyProvider<http.Client, PictureApi>(
            update: (_, httpClient, __) => PictureApi(httpClient)),
        ProxyProvider<PictureApi, ImageService>(
            update: (_, pictureApi, __) => ImageService(pictureApi)),
        ProxyProvider<http.Client, ExpertSysApi>(
          update: (_, httpClient, __) => ExpertSysApi(httpClient: httpClient),
        ),
        ProxyProvider<ExpertSysApi, ExpertSysService>(
          update: (_, expertSysApi, __) => ExpertSysService(expertSysApi),
        ),
      ],
      child: MaterialApp(
        title: 'CustomLove',
        debugShowCheckedModeBanner: false,
        scrollBehavior: CustomScrollBehaviour(),
        theme: _customLoveTheme.toThemeData(),
        initialRoute: '/',
        routes: {
          '/': (context) {
            final loginService = Provider.of<LoginService>(context);
            final userService = Provider.of<UserService>(context);
            final conversationService =
                Provider.of<ConversationService>(context);
            final matchService = Provider.of<MatchService>(context);
            final messageService = Provider.of<MessageService>(context);
            final swipeStatusService = Provider.of<SwipeStatusService>(context);
            return LoginPage(
                loginService: loginService, userService: userService);
          },
          '/home/profile': (context) {
            final loginService = Provider.of<LoginService>(context);
            final userService = Provider.of<UserService>(context);
            return HomeScreen(userService: userService);
          },
          '/home/swipe': (context) {
            final loginService = Provider.of<LoginService>(context);
            final userService = Provider.of<UserService>(context);
            final swipeStatusService = Provider.of<SwipeStatusService>(context);
            return HomeScreen(
                userService: userService,
                swipeStatusService: swipeStatusService);
          },
          '/home/matches': (context) {
            final loginService = Provider.of<LoginService>(context);
            final userService = Provider.of<UserService>(context);
            final conversationService =
                Provider.of<ConversationService>(context);
            final matchService = Provider.of<MatchService>(context);
            final messageService = Provider.of<MessageService>(context);
            return HomeScreen(userService: userService);
          },
          '/home/matches/messages': (context) {
            final userService = Provider.of<UserService>(context);
            return HomeScreen(userService: userService);
          },
          '/logout': (context) {
            return const LogoutPage();
          },
          '/registration': (context) {
            // DO NOT CHANGE TO CONST, OTHERWISE WILL MESS WITH LISTS
            return RegistrationLocation(
                firstName: null,
                lastName: null,
                email: null,
                password: null,
                birthdate: null,
                gender: null,
                preference: [],
                profilePicture: null,
                userInterestIdList: [],
                location: null,
                searchRadius: null,
                job: null,
                bio: null,
                languages: [],
            );
          }
        },
      ),
    );
  }
}
