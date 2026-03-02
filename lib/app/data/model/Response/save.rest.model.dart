class SaveResponse {
  List<SavedProducts>? savedProducts;
  int? count;

  SaveResponse({this.savedProducts, this.count});

  SaveResponse.fromJson(Map<String, dynamic> json) {
    if (json['saved_products'] != null) {
      savedProducts = <SavedProducts>[];
      json['saved_products'].forEach((v) {
        savedProducts!.add(new SavedProducts.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.savedProducts != null) {
      data['saved_products'] = this.savedProducts!
          .map((v) => v.toJson())
          .toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class SavedProducts {
  int? id;
  int? userId;
  int? productId;
  String? status;
  String? createdAt;
  String? updatedAt;

  SavedProducts({
    this.id,
    this.userId,
    this.productId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  SavedProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
