import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../constants/colors.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    required Widget prefixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 60,
        borderRadius: 15,
        blur: 10,
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
            keyboardType: keyboardType,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              hintStyle: GoogleFonts.montserrat(
                color: Colors.white70,
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
      ),
    );
  }

  void _handleRegister() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      final success = await authProvider.register(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công! Vui lòng đăng nhập'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng ký thất bại: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Container(
                height: screenHeight,
                decoration: const BoxDecoration(
                  gradient: AppColors.mainGradient,
                ),
                child: Stack(
                  children: [
                    // Hiệu ứng ánh sáng 1
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
                    // Hiệu ứng ánh sáng 2
                    Positioned(
                      bottom: screenHeight * 0.3,
                      left: -150,
                      child: Container(
                        width: 350,
                        height: 350,
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
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back_ios_new,
                                      color: Colors.white),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                const SizedBox(width: 8),
                                ShaderMask(
                                  shaderCallback: (bounds) => AppColors
                                      .buttonGradient
                                      .createShader(bounds),
                                  child: Text(
                                    'Tạo tài khoản mới',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),

                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Welcome text
                                    ShaderMask(
                                      shaderCallback: (bounds) => AppColors
                                          .buttonGradient
                                          .createShader(bounds),
                                      child: Text(
                                        'Chào mừng bạn!',
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Hãy điền thông tin để tạo tài khoản',
                                      style: GoogleFonts.montserrat(
                                        color: AppColors.textSecondary,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 30),

                                    // Form fields
                                    _buildTextField(
                                      hintText: 'Tài khoản',
                                      controller: _usernameController,
                                      prefixIcon: const Icon(
                                          Icons.account_circle_outlined,
                                          color: Colors.white70),
                                    ),
                                    _buildTextField(
                                      hintText: 'Email',
                                      controller: _emailController,
                                      prefixIcon: const Icon(
                                          Icons.email_outlined,
                                          color: Colors.white70),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    _buildTextField(
                                      hintText: 'Mật khẩu',
                                      controller: _passwordController,
                                      prefixIcon: const Icon(Icons.lock_outline,
                                          color: Colors.white70),
                                      obscureText: true,
                                    ),
                                    const SizedBox(height: 30),
                                  ],
                                ),
                              ),
                            ),

                            // Register button
                            Container(
                              width: double.infinity,
                              height: 55,
                              decoration: BoxDecoration(
                                gradient: AppColors.buttonGradient,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed:
                                    auth.isLoading ? null : _handleRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  'Đăng ký',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            // Login link
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Đã có tài khoản? ",
                                    style: GoogleFonts.montserrat(
                                        color: AppColors.textSecondary),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: ShaderMask(
                                      shaderCallback: (bounds) => AppColors
                                          .buttonGradient
                                          .createShader(bounds),
                                      child: Text(
                                        'Đăng nhập',
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (auth.isLoading)
                const Center(child: CircularProgressIndicator()),
              if (auth.error != null)
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Text(
                    auth.error!,
                    style: GoogleFonts.montserrat(color: Colors.red),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
