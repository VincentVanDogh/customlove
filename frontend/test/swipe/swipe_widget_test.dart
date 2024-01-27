import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/app/presentation/swipe/pages/swipe.dart';
import 'package:frontend/src/app/presentation/swipe/util/algo_id_notifier.dart';
import 'package:frontend/src/app/service/swipe_status_service.dart';
import 'package:frontend/src/app/service/user_service.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockUserService extends Mock implements UserService {}

class MockSwipeStatusService extends Mock implements SwipeStatusService {}

void main() {
  testWidgets('Swipe Widget Test', (WidgetTester tester) async {
    // Create mock services
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
          home: Swipe(
            userService: mockUserService,
            swipeStatusService: mockSwipeStatusService,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Swipe), findsOneWidget);

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
