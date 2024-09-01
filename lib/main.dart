import 'package:flutter/material.dart';
import 'package:practical_task_2/provider/product_provider.dart';
import 'package:practical_task_2/product/view/product_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
          theme: ThemeData(
            useMaterial3: false,
            primarySwatch: Colors.purple, // Primary theme colorr
            primaryColor: Colors.blue,
            // Accent color
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: ProductListScreen()),
    );
  }
}
