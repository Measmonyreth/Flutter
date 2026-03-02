class Cart {
  Carts? carts;
  double? total;
  int? count;

  Cart({this.carts, this.total, this.count});

  Cart.fromJson(Map<String, dynamic> json) {
    final cartJson = json['carts'] ?? json['cart'];
    carts = cartJson != null
        ? Carts.fromJson(Map<String, dynamic>.from(cartJson))
        : null;
    final _t = json['total'];
    if (_t == null) {
      total = null;
    } else if (_t is int) {
      total = _t.toDouble();
    } else if (_t is double) {
      total = _t;
    } else {
      total = double.tryParse(_t.toString());
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.carts != null) {
      data['carts'] = this.carts!.toJson();
    }
    data['total'] = this.total;
    data['count'] = this.count;
    return data;
  }
}

class Carts {
  int? id;
  int? userId;
  dynamic total;
  String? status;
  List<Items>? items;

  Carts({this.id, this.userId, this.total, this.status, this.items});

  Carts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    total = json['total'];
    status = json['status'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['total'] = this.total;
    data['status'] = this.status;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  int? cartId;
  int? productId;
  int? quantity;
  String? price;
  String? createdAt;
  String? updatedAt;
  Product? product;

  Items({
    this.id,
    this.cartId,
    this.productId,
    this.quantity,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cartId = json['cart_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product = json['product'] != null
        ? new Product.fromJson(json['product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cart_id'] = this.cartId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? description;
  String? price;
  String? image;
  bool? isFeatured;
  int? categoryId;
  String? createdAt;
  String? updatedAt;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.image,
    this.isFeatured,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    image = json['image'];
    isFeatured = json['is_featured'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['image'] = this.image;
    data['is_featured'] = this.isFeatured;
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
