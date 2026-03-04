import 'dart:io';

import 'package:ecommerce_flutter/app/data/providers/api_provider.dart';
import 'package:ecommerce_flutter/app/modules/profile/controllers/profile_controller.dart';
import 'package:ecommerce_flutter/app/routes/app_pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  //TODO: Implement EditProfileController
  final _apiProvider = Get.find<APIProvider>();
  final _imagePicker = ImagePicker();
  File? profileImg;
  final faker = Faker();
  final isLoading = false.obs;
  final ProfileController profileController = Get.find<ProfileController>();
  RxSet<int> LoadingUser = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void pickImage() async {
    final file = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      //assign to a global file
      profileImg = File(file.path); // convert from Xfile to file
      // update to refresh the UI
      update();
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? country,
    String? cityOrprovince,
    String? male,
    File? image,
  }) async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.updartProfile(
        name: name,
        email: email,
        image: image,
        phone: phone,
        address: address,
        country: country,
        cityOrprovince: cityOrprovince,
        male: male,
      );
      if (response.statusCode == 200) {
        await profileController.fetchProfile();
        isLoading.value = false;
        LoadingUser.add(profileController.userProfile.value.user!.id!);

        Get.dialog(
          AlertDialog(
            title: const Text('Success'),
            content: const Text('Update profile successful'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // close dialog

                  Get.back(); // go to profile page
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        Get.snackbar("Update Profile", "You have update profile failed");
      }
      print("=== UPDATE PROFILE RESPONSE ===");
      print(response.statusCode);
      print("=======data======");
      print(response.data);
    } catch (e) {
      isLoading.value = false;
      Get.defaultDialog(title: "Error", content: Text(e.toString()));
    }
  }
}
