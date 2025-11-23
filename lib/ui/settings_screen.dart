import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enclavetalk/services/theme_provider.dart';
import 'package:enclavetalk/ui/model_management_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  final List<Color> accentColors = const [
    Colors.purple,
    Colors.blue,
    Colors.teal,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.pink,
    Colors.grey,
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // --- APPEARANCE SECTION ---
          _SettingsSection(
            title: 'Appearance',
            children: [
              ListTile(
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (isDark) {
                    themeProvider.changeThemeMode(
                      isDark ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                ),
              ),
              ListTile(
                title: const Text('Accent Color'),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _AccentColorSelector(
                    availableColors: accentColors,
                    selectedColor: themeProvider.seedColor,
                    onColorSelected: (color) {
                      themeProvider.changeSeedColor(color);
                    },
                  ),
                ),
              ),
            ],
          ),

          // --- MODEL MANAGEMENT SECTION ---
          _SettingsSection(
            title: 'Model Management',
            children: [
              ListTile(
                title: const Text('Manage Models'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ModelManagementScreen(),
                    ),
                  );
                },
              ),
              ListTile(title: const Text('Manage Knowledge Base')),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }
}

class _AccentColorSelector extends StatelessWidget {
  final List<Color> availableColors;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const _AccentColorSelector({
    required this.availableColors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.spaceBetween,
      children: availableColors.map((color) {
        bool isSelected = color.value == selectedColor.value;
        return InkWell(
          onTap: () => onColorSelected(color),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 3,
                    )
                  : null,
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color:
                        ThemeData.estimateBrightnessForColor(color) ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}
