class User {
  final String id;
  final String email;
  final String? name;
  final String? image;

  User({required this.id, required this.email, this.name, this.image});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      image: json['image'] as String?,
    );
  }
}
