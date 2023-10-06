import 'package:blog_applicaton/DetailsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Home.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailsProvider>(
      create: (context) => DetailsProvider(),
      child: MaterialApp(debugShowCheckedModeBanner: false,
        title: 'Blogs',
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'BlogView'),
      ),
    );
  }
}


