import 'dart:io';

import 'package:ecommerce_flutter/app/data/providers/api_provider.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterController extends GetxController {
  //TODO: Implement RegisterController
  final _provider = Get.find<APIProvider>();
  final _imagePicker = ImagePicker();
  File? profileImg;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final faker = Faker();
  RxBool isLoading = false.obs;

  /// optional
  ///

  // init state
  @override
  void onInit() {
    generateUser();
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

  void generateUser() {
    nameController.text = faker.person.name();
    emailController.text = faker.internet.email();
    passController.text = "123123123";
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _provider.register(
        name: name,
        email: email,
        password: password,
        image: profileImg,
      );
      if (response.statusCode == 200) {
        isLoading.value = true;
        // success
        Get.dialog(
          AlertDialog(
            title: const Text('Success'),
            content: const Text('Registration successful'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.back(result: {'email': email, 'password': password});
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      Get.defaultDialog(title: "Error", content: Text("${e.toString()}"));
    } finally {
      isLoading.value = false; // ✅ Always reset loading when done
    }
  }
}
