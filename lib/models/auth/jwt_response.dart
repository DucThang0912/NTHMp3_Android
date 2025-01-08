class JwtResponse {
  final String token;
  final int id;
  final String username;
  final String email;
  final String role;
  final String type;

  JwtResponse({
    required this.token,
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.type,
  });

  factory JwtResponse.fromJson(Map<String, dynamic> json) {
    return JwtResponse(
      token: json['token'],
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      type: json['type'],
    );
  }
}
