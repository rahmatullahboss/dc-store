class User {
  final String id;
  final String email;
  final String? name;
  final String? image;
  final String? phone;
  final String? gender;
  final String? dateOfBirth;

  User({
    required this.id,
    required this.email,
    this.name,
    this.image,
    this.phone,
    this.gender,
    this.dateOfBirth,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      image: json['image'] as String?,
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
    );
  }
}
