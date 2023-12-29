import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../data/model.dart';


class OrderPage extends StatefulWidget {

  const OrderPage({super.key, required this.tableNumber});

  final int tableNumber;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late final DatabaseHelper _database;
  late final List<Category> categories;
  late final List<Product> products;
  late final Order order;

  @override
  void initState() {
    _initData();
    super.initState();
  }

  Future<void> _initData() async {
    _database = DatabaseHelper.instance;
    categories = await _database.getCategories();
    products = await _database.getProducts();
    order = await _database.createOrder(widget.tableNumber);
    print(order);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Order for table ${widget.tableNumber}'),
      ),
      body: categories.isEmpty || products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                var i = category.id;
                return ExpansionTile(
                  title: Text(category.name),
                  children: [
                    for (var product in products.where((p) => p.categoryId == i))
                      ListTile(
                        title: Text(product.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            final orderItem = await _database.addOrderItem(order.id, product.id);
                            print(orderItem);
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
    );
  }

}