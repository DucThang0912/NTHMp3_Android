class JwtResponse {
  final String token;
  final String type;
  final int id;
  final String username;
  final String email;
  final String role;

  JwtResponse({
    required this.token,
    this.type = "Bearer",
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });

  factory JwtResponse.fromJson(Map<String, dynamic> json) {
    return JwtResponse(
      token: json['token'],
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
    );
  }
}
