class CloneCardResponse {
  String? message;
  Data? data;

  CloneCardResponse({this.message, this.data});

  CloneCardResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? userId;
  String? status;
  String? type;
  String? cardNumber;
  String? expiryDate;
  String? amount;
  String? cardholderName;
  String? cvv;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data({
    this.userId,
    this.status,
    this.type,
    this.cardNumber,
    this.expiryDate,
    this.amount,
    this.cardholderName,
    this.cvv,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    status = json['status'];
    type = json['type'];
    cardNumber = json['card_number'];
    expiryDate = json['expiry_date'];
    amount = json['amount'];
    cardholderName = json['cardholder_name'];
    cvv = json['cvv'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['type'] = this.type;
    data['card_number'] = this.cardNumber;
    data['expiry_date'] = this.expiryDate;
    data['amount'] = this.amount;
    data['cardholder_name'] = this.cardholderName;
    data['cvv'] = this.cvv;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
