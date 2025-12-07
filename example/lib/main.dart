// ignore_for_file: avoid_print

import 'package:app_assets/assets.gen.dart';
import 'package:env/env.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Env Builder CLI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Env Builder CLI'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String baseUrl = '';
  final appFlavor = AppFlavor.production();

  // Just to simulate the use of EnvValue
  void createUser(EnvValue env) {
    // final url = env(Env.createUserUrl);
    final baseUrl = env(Env.baseUrl);

    print('Response: $baseUrl');
  }

  @override
  void initState() {
    if (mounted) {
      setState(() {
        baseUrl = appFlavor.getEnv(Env.baseUrl);
      });
    }
    createUser(appFlavor.getEnv);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: Assets.images.icon.provider),
          ),
        ),
        actions: [
          // 
          Assets.images.icon.svg(width: 24, height: 24),
          const SizedBox(width: 20),
        ],
      ),
      body: Center(
        child: Assets.images.homescreen.image(width: 200, height: 200),
      ),
    );
  }
}
