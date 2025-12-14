import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ViAuo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 54, 45, 94),
      ),
      home: const MyHomePage(title: 'ViAuo'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 34, 27, 68),

        leading: const Icon(Icons.person, color: Colors.white),

        title: Text(widget.title, style: const TextStyle(color: Colors.white)),

        centerTitle: true,

        actions: const [Icon(Icons.more_vert, color: Colors.white)],
      ),

      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }
}
