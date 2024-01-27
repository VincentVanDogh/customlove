import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/app/presentation/home/pages/home.dart';
import 'package:frontend/src/app/service/swipe_status_service.dart';
import 'package:frontend/src/app/service/user_service.dart';
import 'package:frontend/src/app/presentation/swipe/util/algo_id_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockUserService extends Mock implements UserService {}

class MockSwipeStatusService extends Mock implements SwipeStatusService {}

void main() {
  testWidgets('HomeScreen Widget Test', (WidgetTester tester) async {
    final MockUserService mockUserService = MockUserService();
    final MockSwipeStatusService mockSwipeStatusService =
        MockSwipeStatusService();
    final AlgoIdNotifier algoIdNotifier = AlgoIdNotifier();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<SwipeStatusService>.value(value: mockSwipeStatusService),
          Provider<UserService>.value(value: mockUserService),
          ChangeNotifierProvider<AlgoIdNotifier>.value(value: algoIdNotifier),
        ],
        child: MaterialApp(
          home: HomeScreen(
              userService: mockUserService,
              swipeStatusService: mockSwipeStatusService),
        ),
      ),
    );

    expect(find.byType(HomeScreen), findsOneWidget);

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Swipe'), findsOneWidget);
    expect(find.text('Matches'), findsOneWidget);
  });
}
