class UserModel {
  final String id;
  final String name;
  final String email;
  final bool isDoctor;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isDoctor,
  });

  // Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      isDoctor: json['isDoctor'] as bool,
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isDoctor': isDoctor,
    };
  }
}
