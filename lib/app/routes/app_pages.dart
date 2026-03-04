import 'package:get/get.dart';

import '../modules/address/add_address/bindings/add_address_binding.dart';
import '../modules/address/add_address/views/add_address_view.dart';
import '../modules/address/addresses/bindings/addresses_binding.dart';
import '../modules/address/edit_address/bindings/edit_address_binding.dart';
import '../modules/address/edit_address/views/edit_address_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main/bindings/home_binding.dart';
import '../modules/main/views/home_view.dart';
import '../modules/product-detail/bindings/product_detail_binding.dart';
import '../modules/product-detail/views/product_detail_view.dart';
import '../modules/products/bindings/products_binding.dart';
import '../modules/products/views/products_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/search_product/bindings/search_product_binding.dart';
import '../modules/search_product/views/search_product_view.dart';
import '../modules/view_all_product/bindings/view_all_product_binding.dart';
import '../modules/view_all_product/views/view_all_product_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.MAIN;

  static final routes = [
    GetPage(name: _Paths.MAIN, page: () => MainView(), binding: MainBinding()),
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
    GetPage(
      name: _Paths.PRODUCTS,
      page: () => const ProductsView(),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAIL,
      page: () => ProductDetailView(product: Get.arguments),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: _Paths.VIEW_ALL_PRODUCT,
      page: () => ViewAllProductView(),
      binding: ViewAllProductBinding(),
    ),
    GetPage(
      name: _Paths.ADDRESSES,
      page: () => const AddAddressView(),
      binding: AddressesBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ADDRESS,
      page: () => const AddAddressView(),
      binding: AddAddressBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_ADDRESS,
      page: () => const EditAddressView(),
      binding: EditAddressBinding(),
    ),
    GetPage(name: _Paths.CART, page: () => CartView(), binding: CartBinding()),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => EditProfileView(profileController: Get.arguments),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_PRODUCT,
      page: () => SearchProductView(),
      binding: SearchProductBinding(),
    ),
    GetPage(
      name: _Paths.CHECKOUT,
      page: () => CheckoutView(),
      binding: CheckoutBinding(),
    ),
  ];
}
