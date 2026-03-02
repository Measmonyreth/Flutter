import 'dart:io';

import 'package:ecommerce_flutter/app/data/providers/api_provider.dart';
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
        isLoading.value = false;
        Get.snackbar("Update Profile", "You have update profile success");
        Get.back();
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
