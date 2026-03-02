import 'package:ecommerce_flutter/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  EditProfileView({super.key, required this.profileController});

  ProfileController profileController = Get.find<ProfileController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityOrprovinceController =
      TextEditingController();
  final TextEditingController maleController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = profileController.userProfile.value.user;
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: user?.name);
    final _emailController = TextEditingController(text: user?.email);
    final _phoneController = TextEditingController(text: user?.phone);
    final _addressController = TextEditingController(text: user?.address);
    final _countryController = TextEditingController(text: user?.country);
    final _cityOrprovinceController = TextEditingController(
      text: user?.cityOrProvince,
    );
    final _maleController = TextEditingController(text: user?.sex);
    final _passwordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();

    final initials = _getInitials(user?.name ?? 'U');

    return Scaffold(
      appBar: AppBar(title: const Text('EditProfileView'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                // Avatar
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                          border: Border.all(color: Colors.white, width: 2.5),
                        ),
                        child: GetBuilder<EditProfileController>(
                          builder: (ctrl) {
                            // Show picked image if exists
                            if (ctrl.profileImg != null) {
                              return ClipOval(
                                child: Image.file(
                                  ctrl.profileImg!,
                                  fit: BoxFit.cover,
                                ),
                              );
                            }
                            // Otherwise show user's avatar or initials
                            return user?.avatar != null
                                ? ClipOval(
                                    child: Image.network(
                                      user!.avatar!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      initials,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ),
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  user?.name ?? '—',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user?.email ?? '—',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: nameController.text.trim() == ''
                        ? _nameController
                        : nameController,
                    label: 'Name',
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(height: 12),
                  CustomTextFormField(
                    controller: phoneController.text.trim() == ''
                        ? _phoneController
                        : phoneController,
                    label: 'Phone',
                    prefixIcon: Icons.phone,
                  ),
                  SizedBox(height: 12),
                  CustomTextFormField(
                    controller: addressController.text.trim() == ''
                        ? _addressController
                        : addressController,
                    label: 'Address',
                    prefixIcon: Icons.location_on,
                  ),
                  SizedBox(height: 12),
                  CustomTextFormField(
                    controller: countryController.text.trim() == ''
                        ? _countryController
                        : countryController,
                    label: 'Country',
                    prefixIcon: Icons.location_on,
                  ),
                  SizedBox(height: 12),
                  CustomTextFormField(
                    controller: cityOrprovinceController.text.trim() == ''
                        ? _cityOrprovinceController
                        : cityOrprovinceController,
                    label: 'City/Province',
                    prefixIcon: Icons.location_on,
                  ),
                  SizedBox(height: 12),
                  CustomTextFormField(
                    controller: maleController.text.trim() == ''
                        ? _maleController
                        : maleController,
                    label: 'Sex',
                    prefixIcon: Icons.male,
                    keyboardType: TextInputType.name,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          await controller.updateProfile(
                            name: _nameController.text.trim(),
                            email: _emailController.text.trim(),
                            phone: _phoneController.text.trim(),
                            address: _addressController.text.trim(),
                            country: _countryController.text.trim(),
                            cityOrprovince: _cityOrprovinceController.text
                                .trim(),
                            male: _maleController.text.trim(),
                            image: controller.profileImg,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  // set width and heigt
                  minimumSize: const Size(double.infinity, 50),
                  maximumSize: const Size(double.infinity, 50),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Update Profile',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _getInitials(String name) {
  final parts = name.trim().split(RegExp(r'[\s_]+'));
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2),
        ),
      ),
    );
  }
}
