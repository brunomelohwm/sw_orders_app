class TokenResponseModel {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;
  final String scope;
  TokenResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
    required this.scope,
  });

  factory TokenResponseModel.fromJson(Map<String, dynamic> json) {
    return TokenResponseModel(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      expiresIn: json['expires_in'] ?? '',
      tokenType: json['token_type'] ?? '',
      scope: json['scope'],
    );
  }
}
