class Token {
  final String token;
  final DateTime expiration;

  const Token({required this.token, required this.expiration});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token'],
      expiration: DateTime.parse(json['expiration']),
    );
  }

  bool get isExpired {
    return DateTime.now().isAfter(expiration);
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'expiration': expiration.toIso8601String()};
  }
}
