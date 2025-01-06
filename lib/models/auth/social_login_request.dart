enum SocialProvider { GOOGLE, FACEBOOK }

class SocialLoginRequest {
  final String accessToken;
  final SocialProvider provider;

  SocialLoginRequest({
    required this.accessToken,
    required this.provider,
  });

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'provider': provider.toString().split('.').last,
      };
}
