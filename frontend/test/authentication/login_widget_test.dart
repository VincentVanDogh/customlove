import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/app/presentation/authentification/components/sign_in_button.dart';
import 'package:frontend/src/app/presentation/authentification/pages/login_page.dart';
import 'package:frontend/src/app/service/login_service.dart';
import 'package:frontend/src/app/service/user_service.dart';

import 'package:mockito/mockito.dart';

class MockLoginService extends Mock implements LoginService {}

class MockUserService extends Mock implements UserService {}

void main() {
  testWidgets('LoginPage UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.

    final MockLoginService mockLoginService = MockLoginService();
    final MockUserService mockUserService = MockUserService();

    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(
          loginService: mockLoginService,
          userService:
              mockUserService, // You need to provide a mock or actual login service here.
        ),
      ),
    );

    // Verify the presence of certain widgets in the UI.

    // Check for the 'CUSTOMLOVE' text.
    expect(find.text('CUSTOMLOVE'), findsOneWidget);

    // Check for the 'Next Level Dating for Everybody' text.
    expect(find.text('Next Level Dating for Everybody'), findsOneWidget);

    // Check for the email textfield.
    expect(find.byKey(const Key('emailTextField')), findsOneWidget);

    // Check for the password textfield.
    expect(find.byKey(const Key('passwordTextField')), findsOneWidget);

    // Check for the 'Forgot Password?' text.
    expect(find.text('Forgot Password?'), findsOneWidget);

    // Check for the sign-in button.
    expect(find.byType(LoginButton), findsOneWidget);

    // Check for the 'Or continue with' text.
    expect(find.text('Or continue with'), findsOneWidget);

    // Check for the 'Not a member? Register now' text.
    expect(find.text('Not a member?'), findsOneWidget);
    expect(find.text('Register now'), findsOneWidget);
  });

  // You can add more tests based on specific interactions and validations.
}
