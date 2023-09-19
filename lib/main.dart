import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/controller/state_controller.dart';
import 'package:reminder/view/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StateController()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Reminder Application',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const Home(),
      ),
    );
  }
}
