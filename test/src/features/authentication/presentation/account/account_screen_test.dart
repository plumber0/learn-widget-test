import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  /// We can use pumpWidget with:
  /// - very small widgets (Text or buttons)
  /// - the entire app (MyApp)
  testWidgets('Cancel logout', (tester) async {
    final r = AuthRobot(tester);

    await r.pumpAccountScreen();

    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapCancelButton();
    r.expectLogoutDialogNotFound();
  });
  testWidgets('Confirm logout success', (tester) async {
    final r = AuthRobot(tester);

    await r.pumpAccountScreen();

    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapDialogLogoutButton();
    r.expectLogoutDialogNotFound();
    r.expectErrorAlertNotFound();
  });

  testWidgets('Confirm logout failure', (tester) async {
    final r = AuthRobot(tester);

    final authRepository = MockAuthRepository();
    final exception = Exception('Connection Failed');
    when(authRepository.signOut).thenThrow(exception);
    when(authRepository.authStateChanges).thenAnswer((_) =>
        Stream.value(const AppUser(uid: '123', email: 'abcd@gmail.com')));

    await r.pumpAccountScreen(authRepository: authRepository);

    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapDialogLogoutButton();
    r.expectErrorAlertFound();
  });
}
