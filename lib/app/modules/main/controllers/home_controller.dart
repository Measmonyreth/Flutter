import 'package:ecommerce_flutter/app/modules/cart/bindings/cart_binding.dart';
import 'package:ecommerce_flutter/app/modules/cart/views/cart_view.dart';
import 'package:ecommerce_flutter/app/modules/home/bindings/home_binding.dart';
import 'package:ecommerce_flutter/app/modules/home/views/home_view.dart';
import 'package:ecommerce_flutter/app/modules/profile/bindings/profile_binding.dart';
import 'package:ecommerce_flutter/app/modules/profile/views/profile_view.dart';
import 'package:ecommerce_flutter/app/modules/search_product/bindings/search_product_binding.dart';
import 'package:ecommerce_flutter/app/modules/search_product/views/search_product_view.dart';
import 'package:ecommerce_flutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  //TODO: Implement HomeController
  final pages = <String>[
    Routes.HOME,
    Routes.SEARCH_PRODUCT,
    Routes.CART,
    Routes.PROFILE,
  ];
  var currentIndex = 0.obs;

  void onTab(index) {
    if (currentIndex == index) return;
    currentIndex.value = index;
    Get.offNamed(pages[index], id: 1);
  }

  //TODO: Implement MainController
  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == Routes.HOME) {
      return GetPageRoute(
        settings: settings,
        page: () => HomeView(),
        binding: HomeBinding(),
      );
    }
    if (settings.name == Routes.SEARCH_PRODUCT) {
      return GetPageRoute(
        settings: settings,
        transition: Transition.fadeIn,
        page: () => SearchProductView(),
        binding: SearchProductBinding(),
      );
    }
    if (settings.name == Routes.CART) {
      return GetPageRoute(
        settings: settings,
        page: () => CartView(),
        binding: CartBinding(),
      );
    }
    if (settings.name == Routes.PROFILE) {
      return GetPageRoute(
        settings: settings,
        page: () => ProfileView(),
        binding: ProfileBinding(),
      );
    }
    // if (settings.name == Routes.EDIT_PROFILE) {
    //   return GetPageRoute(
    //     settings: settings,
    //     page: () => EditProfileView(),
    //     binding: EditProfileBinding(),
    //   );
    // }
  }
}
