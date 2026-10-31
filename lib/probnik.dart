import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CartButtonScreen(),
    );
  }
}

class CartButtonScreen extends StatelessWidget {
  const CartButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Пример кнопки'),
      ),
      body: Center(
        child: IconButton(
          icon: const Icon(Icons.delete, size: 360),
          color: Colors.blue,
          onPressed: () {

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Товар добавлен в корзину'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}