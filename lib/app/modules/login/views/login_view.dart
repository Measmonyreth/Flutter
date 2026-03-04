import 'package:ecommerce_flutter/app/modules/register/views/register_view.dart';
import 'package:ecommerce_flutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginController _controller = Get.find<LoginController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 35),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),

                          // ✅ Default border (soft)
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                              color:
                                  Colors.grey.shade300, // 👈 soft light border
                              width: 1,
                            ),
                          ),

                          // ✅ Focused border (blue accent)
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),

                          // ✅ Error border (optional)
                          errorBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                              color: Colors.red.shade300,
                              width: 1,
                            ),
                          ),

                          // ✅ Focused error border (optional)
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                              color: Colors.red.shade400,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please enter email';
                          if (!GetUtils.isEmail(value))
                            return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                              color:
                                  Colors.grey.shade300, // 👈 soft light border
                              width: 1,
                            ),
                          ),

                          // ✅ Focused border (blue accent)
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),

                          // ✅ Error border (optional)
                          errorBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                              color: Colors.red.shade300,
                              width: 1,
                            ),
                          ),

                          // ✅ Focused error border (optional)
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                              color: Colors.red.shade400,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please enter password';
                          if (value.length < 6)
                            return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),
                Obx(
                  () => ElevatedButton(
                    onPressed: _controller.isLoading.value
                        ? null
                        : () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              await _controller.login(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      minimumSize: const Size(double.infinity, 48),
                      maximumSize: const Size(double.infinity, 48),
                      elevation: 0,
                      shadowColor: const Color.fromARGB(0, 15, 15, 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: _controller.isLoading.value
                          ? Colors.blue.shade200
                          : Colors.blue.shade400,
                    ),

                    child: _controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () async {
                        final result = await Get.toNamed(Routes.REGISTER);
                        if (result != null && result is Map) {
                          _emailController.text = result['email'] ?? '';
                          _passwordController.text = result['password'] ?? '';
                        }
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'or sign in with',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _controller.signInWithGoogle();
                        },
                        icon: const Icon(
                          Icons.g_mobiledata,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        label: const Text(
                          'Google',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),

                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          minimumSize: const Size(double.infinity, 48),
                          maximumSize: const Size(double.infinity, 48),
                          elevation: 0,
                          shadowColor: const Color.fromARGB(0, 15, 15, 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: _controller.isLoading.value
                              ? Colors.blue.shade200
                              : Colors.blue.shade400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _controller.signInWithApple();
                        },
                        icon: const Icon(
                          Icons.apple,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        label: const Text(
                          'Apple',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          minimumSize: const Size(double.infinity, 48),
                          maximumSize: const Size(double.infinity, 48),
                          elevation: 0,
                          shadowColor: const Color.fromARGB(0, 15, 15, 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: _controller.isLoading.value
                              ? Colors.blue.shade200
                              : Colors.blue.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
