class Category {
  int id;
  String name;

  Category({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}

class Product {
  int id;
  int categoryId;
  String name;

  Product({required this.id, required this.categoryId, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'categoryId': categoryId, 'name': name};
  }
}

class Order {
  int id;
  int tableNumber;

  Order({required this.id, required this.tableNumber});

  Map<String, dynamic> toMap() {
    return {'id': id, 'tableNumber': tableNumber};
  }
}

class OrderItem {
  int id;
  int orderId;
  int productId;
  int quantity;

  OrderItem({required this.id, required this.orderId, required this.productId, required this.quantity});

  Map<String, dynamic> toMap() {
    return {'id': id, 'orderId': orderId, 'productId': productId, 'quantity': quantity};
  }
}