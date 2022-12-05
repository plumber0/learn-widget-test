import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// We can use pumpWidget with:
  /// - very small widgets (Text or buttons)
  /// - the entire app (MyApp)
  testWidgets('Cancel logout', (tester) async {
    /// we must always add any parent widgets that are needed
    /// (MaterialApp, ProviderScope...)
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: AccountScreen())),
    );
    final logoutButton = find.text('Logout');
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);

    /// The test environment does NOT update the UI
    /// after we perform an interaction(ex. tap on a button)
    /// tester.pump() will trigger a new frame
    ///
    /// When you interact with the UI using the tester,
    /// you must 'await tester.pump()'
    /// before you use the finder again
    /// This gives you a lot of control, as you are in charge of when the UI should update

    await tester.pump();

    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsOneWidget);

    final cancelButton = find.text('Cancel');
    expect(cancelButton, findsOneWidget);
    await tester.tap(cancelButton);
    await tester.pump();

    // It's ok to reuse a finder by writing multiple expectations against it
    expect(dialogTitle, findsNothing);
  });
}
