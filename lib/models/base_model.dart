class BaseModel {
  int? id;
  DateTime? createdDate;
  DateTime? updatedDate;

  BaseModel({
    this.id,
    this.createdDate,
    this.updatedDate,
  });

  BaseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdDate = DateTime.parse(json['createdDate']);
    updatedDate = DateTime.parse(json['updatedDate']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdDate': createdDate?.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
    };
  }
}