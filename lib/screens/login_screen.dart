import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../constants/colors.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../models/auth/social_login_request.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String hintText,
    bool obscureText = false,
    required TextEditingController controller,
    required Widget prefixIcon,
  }) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 60,
      borderRadius: 15,
      blur: 15,
      alignment: Alignment.center,
      border: 1,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.15),
          Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.3),
          Colors.white.withOpacity(0.1),
        ],
      ),
      child: Center(
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: GoogleFonts.montserrat(
              color: Colors.white60,
              fontSize: 16,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: prefixIcon,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 50,
              minHeight: 25,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            alignLabelWithHint: true,
          ),
          textAlignVertical: TextAlignVertical.center,
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GlassmorphicContainer(
      width: 60,
      height: 60,
      borderRadius: 15,
      blur: 20,
      alignment: Alignment.center,
      border: 1,
      linearGradient: LinearGradient(
        colors: [
          color.withOpacity(0.2),
          color.withOpacity(0.1),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          color.withOpacity(0.3),
          color.withOpacity(0.2),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 30),
        onPressed: onPressed,
      ),
    );
  }

  void _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ tài khoản và mật khẩu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final success = await authProvider.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng nhập thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tài khoản hoặc mật khẩu không chính xác'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng nhập thất bại: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleGoogleLogin(BuildContext context) async {
    try {
      // Kiểm tra Google Play Services
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
      );

      print("Bắt đầu đăng nhập Google...");

      // Kiểm tra Google Play Services
      try {
        final status = await googleSignIn.signInSilently();
        print("Google Play Services status: $status");
      } catch (e) {
        print("Lỗi Google Play Services: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng cài đặt Google Play Services'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
        return;
      }

      final isSignedIn = await googleSignIn.isSignedIn();
      print("Đã đăng nhập trước đó: $isSignedIn");

      if (isSignedIn) {
        await googleSignIn.signOut();
        print("Đã đăng xuất tài khoản cũ");
      }

      print("Đang thử đăng nhập...");
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account != null) {
        print("Đăng nhập Google thành công: ${account.email}");
        final GoogleSignInAuthentication auth = await account.authentication;

        final request = SocialLoginRequest(
          accessToken: auth.accessToken!,
          provider: SocialProvider.GOOGLE,
        );

        final success = await Provider.of<AuthProvider>(context, listen: false)
            .socialLogin(request);

        if (success && mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        }
      } else {
        print("Người dùng hủy đăng nhập");
      }
    } catch (e) {
      print("Lỗi chi tiết: $e");
      if (e.toString().contains("8:")) {
        print("Lỗi Google Play Services không khả dụng");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng cài đặt và cập nhật Google Play Services'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _handleFacebookLogin(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final request = SocialLoginRequest(
          accessToken: result.accessToken!.token,
          provider: SocialProvider.FACEBOOK,
        );

        final success = await Provider.of<AuthProvider>(context, listen: false)
            .socialLogin(request);

        if (success && mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập Facebook thất bại: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.mainGradient,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -100,
                  right: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.glowColors['purple']!.withOpacity(0.2),
                          AppColors.glowColors['purple']!.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: -50,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.glowColors['blue']!.withOpacity(0.2),
                          AppColors.glowColors['blue']!.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.4,
                  right: -50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.glowColors['pink']!.withOpacity(0.2),
                          AppColors.glowColors['pink']!.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                              (route) => false,
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 40),
                              ShaderMask(
                                shaderCallback: (bounds) => AppColors
                                    .buttonGradient
                                    .createShader(bounds),
                                child: Text(
                                  'Chào mừng\ntrở lại',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Đăng nhập để tiếp tục',
                                style: GoogleFonts.montserrat(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 50),
                              _buildTextField(
                                hintText: 'Tài khoản',
                                controller: _usernameController,
                                prefixIcon: const Icon(Icons.person_outline,
                                    color: Colors.white70),
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                hintText: 'Mật khẩu',
                                obscureText: true,
                                controller: _passwordController,
                                prefixIcon: const Icon(Icons.lock_outline,
                                    color: Colors.white70),
                              ),
                              const SizedBox(height: 40),
                              Container(
                                width: double.infinity,
                                height: 55,
                                decoration: BoxDecoration(
                                  gradient: AppColors.buttonGradient,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF5E69)
                                          .withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed:
                                      auth.isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    'Đăng nhập',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Center(
                                child: Text(
                                  'Hoặc đăng nhập với',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildSocialButton(
                                    icon: FontAwesomeIcons.google,
                                    color: Colors.red,
                                    onPressed: () =>
                                        _handleGoogleLogin(context),
                                  ),
                                  const SizedBox(width: 20),
                                  _buildSocialButton(
                                    icon: FontAwesomeIcons.facebook,
                                    color: const Color(0xFF1877F2),
                                    onPressed: () =>
                                        _handleFacebookLogin(context),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Chưa có tài khoản? ",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white70),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterScreen()),
                                      );
                                    },
                                    child: Text(
                                      'Đăng ký',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
