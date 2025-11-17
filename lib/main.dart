import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:enclavetalk/services/theme_provider.dart';
import 'package:enclavetalk/ui/chat_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const EnclaveTalkApp(),
    ),
  );
}

class EnclaveTalkApp extends StatelessWidget {
  const EnclaveTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    if (themeProvider.isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'EnclaveTalk',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeProvider.seedColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeProvider.seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      home: const ChatScreen(),
    );
  }
}
