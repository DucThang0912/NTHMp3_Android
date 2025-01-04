class BaseModel {
  int? id;
  DateTime? createdDate;
  DateTime? updatedDate;

  BaseModel({
    this.id,
    this.createdDate,
    this.updatedDate,
  });

  // lấy dữ liệu từ json và gán vào các thuộc tính của model
  BaseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdDate = DateTime.parse(json['createdDate']);
    updatedDate = DateTime.parse(json['updatedDate']);
  }

  // chuyển đổi model sang json để lưu vào database hoặc gửi đi
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdDate': createdDate?.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
    };
  }
}
