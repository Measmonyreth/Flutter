import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _nameController = TextEditingController();
    final RegisterController _controller = Get.find<RegisterController>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // const SizedBox(height: 8),
                const Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Welcome to register page',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 70),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
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
                            return 'Please enter name';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
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
                          border: OutlineInputBorder(),
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

                const SizedBox(height: 40),
                Obx(
                  () => ElevatedButton(
                    onPressed: _controller.isLoading.value
                        ? null
                        : () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              await _controller.register(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
                            'Register',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('  Already have an account?'),
                    // const SizedBox(width: 2),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        'login',
                        style: TextStyle(fontSize: 14, color: Colors.blue),
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
