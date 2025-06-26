class UserModel {
  final String id;
  final String name;
  final String email;
  final bool isDoctor;
  final String? address;
  final String? phoneNumber;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isDoctor,
    this.address = "",
    this.phoneNumber = "",
  });

  // Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      isDoctor: json['isDoctor'] as bool,
      address: json['address'] as String? ?? "",
      phoneNumber: json['phoneNumber'] as String? ?? "",
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isDoctor': isDoctor,
      'address': address ?? "",
      'phoneNumber': phoneNumber ?? "",
    };
  }
}
