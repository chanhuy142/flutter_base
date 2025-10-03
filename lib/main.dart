import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'features/posts/presentation/pages/posts_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PostsPage(),
    );
  }
}
 
