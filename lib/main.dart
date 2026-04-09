import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/project_list_screen.dart';
import 'theme/quest_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('open_quest');
  runApp(const ProviderScope(child: OpenQuestApp()));
}

class OpenQuestApp extends StatelessWidget {
  const OpenQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenQuest',
      debugShowCheckedModeBanner: false,
      theme: QuestTheme.darkTheme,
      home: const ProjectListScreen(),
    );
  }
}
