import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {

  const OrderPage({super.key, required this.tableNumber});

  final int tableNumber;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Order for table ${widget.tableNumber}'),
      ),
      body: const Center(
        child: Text('Order'),
      ),
    );
  }
}