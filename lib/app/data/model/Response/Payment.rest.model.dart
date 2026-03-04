class PaymentResponse {
  String? message;
  List<Payments>? payments;

  PaymentResponse({this.message, this.payments});

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['payments'] != null) {
      payments = <Payments>[];
      json['payments'].forEach((v) {
        payments!.add(new Payments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.payments != null) {
      data['payments'] = this.payments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payments {
  int? id;
  int? cartId;
  int? userId;
  String? amount;
  String? paymentMethod;
  String? status;
  String? paymentDate;
  String? task;
  String? createdAt;
  String? updatedAt;

  Payments({
    this.id,
    this.cartId,
    this.userId,
    this.amount,
    this.paymentMethod,
    this.status,
    this.paymentDate,
    this.task,
    this.createdAt,
    this.updatedAt,
  });

  Payments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cartId = json['cart_id'];
    userId = json['user_id'];
    amount = json['amount'];
    paymentMethod = json['payment_method'];
    status = json['status'];
    paymentDate = json['payment_date'];
    task = json['task'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cart_id'] = this.cartId;
    data['user_id'] = this.userId;
    data['amount'] = this.amount;
    data['payment_method'] = this.paymentMethod;
    data['status'] = this.status;
    data['payment_date'] = this.paymentDate;
    data['task'] = this.task;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
