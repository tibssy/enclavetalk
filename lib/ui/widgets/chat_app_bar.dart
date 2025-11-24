import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:enclavetalk/ui/history_screen.dart';
import 'package:enclavetalk/ui/settings_screen.dart';
import 'package:enclavetalk/ui/utils/slide_from_left_route.dart';
import 'package:enclavetalk/ui/widgets/model_selection_sheet.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkMode
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: colorScheme.surfaceContainerHighest,
        systemNavigationBarIconBrightness: isDarkMode
            ? Brightness.light
            : Brightness.dark,
      ),
      title: const Text("EnclaveTalk"),
      centerTitle: true,
      elevation: 4,
      shadowColor: Colors.black,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surface,
      leading: IconButton(
        icon: const Icon(Icons.history),
        onPressed: () {
          Navigator.of(
            context,
          ).push(SlideFromLeftRoute(page: const HistoryScreen()));
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.psychology),
          tooltip: 'Select AI Model',
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              barrierColor: Colors.transparent,
              builder: (context) => const ModelSelectionSheet(),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
