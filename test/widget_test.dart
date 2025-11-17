import 'package:enclavetalk/services/theme_provider.dart';
import 'package:enclavetalk/ui/chat_screen.dart';
import 'package:enclavetalk/ui/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:enclavetalk/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App starts and can navigate to settings', (
    WidgetTester tester,
  ) async {
    // This prevents the test from trying to access the actual device storage.
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const EnclaveTalkApp(),
      ),
    );

    // loading state settle and the main UI to appear.
    await tester.pumpAndSettle();

    // --- VERIFY THE CHAT SCREEN ---

    // Verify that the ChatScreen is visible.
    expect(find.byType(ChatScreen), findsOneWidget);

    // Verify that our AppBar title is present.
    expect(find.text('EnclaveTalk'), findsOneWidget);

    // Verify the text input field is present.
    expect(find.byType(TextField), findsOneWidget);

    // --- INTERACT AND VERIFY NAVIGATION ---

    // Find the settings icon and tap it.
    await tester.tap(find.byIcon(Icons.settings));

    // Wait for the navigation animation to complete.
    await tester.pumpAndSettle();

    // Verify that the SettingsScreen is now visible.
    expect(find.byType(SettingsScreen), findsOneWidget);

    // Verify a key piece of text on the settings screen is present.
    expect(find.text('Appearance'), findsOneWidget);

    // Verify that the ChatScreen is no longer visible.
    expect(find.byType(ChatScreen), findsNothing);
  });
}
