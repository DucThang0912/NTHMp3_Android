enum SocialProvider { GOOGLE, FACEBOOK }

class SocialLoginRequest {
  final String idToken;
  final SocialProvider provider;

  SocialLoginRequest({
    required this.idToken,
    required this.provider,
  });

  Map<String, dynamic> toJson() => {
        'accessToken': idToken,
        'provider': provider.toString().split('.').last,
      };
}
