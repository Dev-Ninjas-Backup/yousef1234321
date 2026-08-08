class AuthResponseModel {
  final String token;
  final String userId;

  AuthResponseModel({required this.token, required this.userId});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] ?? '',
      userId: json['user']?['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': {'id': userId},
    };
  }
}
