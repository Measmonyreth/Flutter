import 'package:ecommerce_flutter/app/modules/address/addresses/controllers/addresses_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';


class AddressesView extends GetView<AddressesController> {
  const AddressesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddressesView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AddressesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
