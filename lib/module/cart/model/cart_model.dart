class Product {
  String id;
  String farmerId;
  String farmerName;
  String prodId;
  String name;
  double price;
  String image;
  int qty;
  int totalQty;

  Product({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.prodId,
    required this.name,
    required this.price,
    required this.image,
    required this.qty,
    required this.totalQty,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'farmerName': farmerName,
      'prodId': prodId,
      'name': name,
      'price': price,
      'image': image,
      'qty': qty,
      'totalQty': totalQty,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      farmerId: json['farmerId'],
      farmerName: json['farmerName'],
      prodId: json['prodId'],
      name: json['name'],
      price: json['price'].toDouble(),
      image: json['image'],
      qty: json['qty'],
      totalQty: json['totalQty'],
    );
  }
}
