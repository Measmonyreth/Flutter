class Cart {
  Carts? carts;
  double? total;
  int? count;

  Cart({this.carts, this.total, this.count});

  Cart.fromJson(Map<String, dynamic> json) {
    final cartJson = json['carts'] ?? json['cart'];
    if (cartJson == null) {
      carts = null;
    } else if (cartJson is Map) {
      carts = Carts.fromJson(Map<String, dynamic>.from(cartJson));
    } else if (cartJson is List) {
      // API may return the items list directly (including an empty list)
      carts = Carts.fromJson({'items': cartJson});
    } else {
      carts = null;
    }
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
  num? price; // Changed from String? to num?
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

    // Handle price conversion properly
    final priceValue = json['price'];
    if (priceValue is int) {
      price = priceValue.toDouble(); // Convert int to double
    } else if (priceValue is double) {
      price = priceValue;
    } else if (priceValue is String) {
      price = double.tryParse(priceValue) ?? 0.0;
    } else {
      price = 0.0;
    }

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product = json['product'] != null
        ? Product.fromJson(json['product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cart_id'] = cartId;
    data['product_id'] = productId;
    data['quantity'] = quantity;
    data['price'] = price
        ?.toString(); // Convert back to string for API if needed
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? description;
  num? price;
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
    // Handle price conversion properly
    final priceValue = json['price'];
    if (priceValue is int) {
      price = priceValue.toDouble(); // Convert int to double
    } else if (priceValue is double) {
      price = priceValue;
    } else if (priceValue is String) {
      price = double.tryParse(priceValue) ?? 0.0;
    } else {
      price = 0.0;
    }
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
