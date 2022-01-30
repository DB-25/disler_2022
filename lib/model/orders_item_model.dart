class OrderItemModel {
  OrderItemModel(
      {this.quantity,
      this.size,
      this.price,
      this.name,
      this.orderDetailId,
      this.status});

  int quantity;
  String size;
  double price;
  String name;
  String orderDetailId;
  String status;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'quantity': quantity,
        'size': size,
        'price': price,
        'name': name,
        'orderDetailId': orderDetailId,
        'status': status
      };
  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
        quantity: map.containsKey('quantity') ? (map['quantity'] ?? 0) : 0,
        size: map.containsKey('size') ? (map['size'] ?? '') : '',
        price: map.containsKey('price') ? (map['price'] + 0.0 ?? 0.0) : 0.0,
        name: map.containsKey('name') ? (map['name'] ?? '') : '',
        orderDetailId: map.containsKey('orderDetailId')
            ? (map['orderDetailId'] ?? '')
            : '',
        status: map.containsKey('status') ? (map['status'] ?? '') : '');
  }

  OrderItemModel.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    size = json['size'];
    name = json['name'];
    price = json['price'] + 0.0;
    orderDetailId = json['orderDetailId'];
    status = json['status'];
  }
}
