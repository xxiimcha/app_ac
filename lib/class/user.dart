class User {
  final int id;
  final String name;
  final String username;
  final int userType;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.userType,
  });

  // Factory constructor to handle null values and map data safely
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0, // Provide a default value if id is null
      name: map['name'] ?? '', // Provide a default value if id is null
      username: map['username'] ?? '', // Provide a default value if username is null
      userType: map['user_type'] ?? 0, // Provide a default value if user_type is null
    );
  }
}
