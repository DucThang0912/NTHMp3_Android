import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nthmusicmp3/models/user.dart';
import 'package:nthmusicmp3/services/user_service.dart';
import 'package:nthmusicmp3/services/location_service.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  List<Province> _provinces = [];
  Province? _selectedProvince;
  bool _isEditing = false;
  bool _isLoading = true;
  User? _user;

  final _userService = UserService();
  final _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _loadUserProfile();
    _loadProvinces();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = await _userService.getUserProfile();
      setState(() {
        _user = user;
        _fullNameController.text = user.fullName ?? '';
        _emailController.text = user.email;
        _phoneController.text = user.phone ?? '';
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải thông tin: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadProvinces() async {
    try {
      final provinces = await _locationService.getProvinces();
      setState(() {
        _provinces = provinces;
        if (_user?.location != null) {
          _selectedProvince = _provinces.firstWhere(
            (p) => p.name == _user!.location,
            orElse: () => _provinces.first,
          );
        }
      });
    } catch (e) {
      print('Error loading provinces: $e');
    }
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    final phoneRegex = RegExp(r'^(0|\+84)([0-9]{9})$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Số điện thoại không hợp lệ (VD: 0912345678)';
    }
    return null;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      final updatedUser = _user!.copyWith(
        email: _emailController.text,
        fullName: _fullNameController.text,
        phone: _phoneController.text,
        location: _selectedProvince?.name,
      );

      await _userService.updateProfile(updatedUser);

      setState(() {
        _isEditing = false;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công')),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Thông tin cá nhân',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.save_rounded : Icons.edit_rounded,
              color: Colors.white,
            ),
            onPressed: _isLoading
                ? null
                : () {
                    if (_isEditing) {
                      _saveProfile();
                    } else {
                      setState(() => _isEditing = true);
                    }
                  },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: Text(
                        _user?.fullName?.substring(0, 1).toUpperCase() ??
                            _user?.username.substring(0, 1).toUpperCase() ??
                            'U',
                        style: GoogleFonts.montserrat(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                            label: 'Họ và tên',
                            controller: _fullNameController,
                            enabled: _isEditing,
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Email',
                            controller: _emailController,
                            enabled: _isEditing,
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (!value!.contains('@')) {
                                return 'Email không hợp lệ';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Số điện thoại',
                            controller: _phoneController,
                            enabled: _isEditing,
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: _validatePhone,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: _isEditing
                                    ? AppColors.primary.withOpacity(0.5)
                                    : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: DropdownButtonFormField<Province>(
                              value: _selectedProvince,
                              decoration: InputDecoration(
                                labelText: 'Tỉnh/Thành phố',
                                labelStyle: GoogleFonts.montserrat(
                                  color: _isEditing
                                      ? AppColors.primary
                                      : Colors.grey[400],
                                ),
                                prefixIcon: Icon(
                                  Icons.location_on_outlined,
                                  color: _isEditing
                                      ? AppColors.primary
                                      : Colors.grey[400],
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              style:
                                  GoogleFonts.montserrat(color: Colors.white),
                              dropdownColor: AppColors.surface,
                              items: _provinces.map((Province province) {
                                return DropdownMenuItem<Province>(
                                  value: province,
                                  child: Text(
                                    province.name,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white),
                                  ),
                                );
                              }).toList(),
                              onChanged: _isEditing
                                  ? (Province? newValue) {
                                      setState(() {
                                        _selectedProvince = newValue;
                                      });
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _isEditing
              ? AppColors.primary.withOpacity(0.5)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        style: GoogleFonts.montserrat(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.montserrat(
            color: enabled ? AppColors.primary : Colors.grey[400],
          ),
          prefixIcon: Icon(
            icon,
            color: enabled ? AppColors.primary : Colors.grey[400],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          errorStyle: GoogleFonts.montserrat(color: Colors.red),
        ),
        validator: validator,
      ),
    );
  }
}
