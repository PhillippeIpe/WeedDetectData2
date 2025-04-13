import 'package:flutter/material.dart';
import 'database_helper.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showError('Please fill all fields');
      return;
    }

    if (password != confirmPassword) {
      _showError('Passwords do not match');
      return;
    }

    try {
      final isRegistered = await DatabaseHelper.instance.isEmailRegistered(email);
      if (isRegistered) {
        _showError('Email already registered');
        return;
      }

      await DatabaseHelper.instance.createUser(email, password);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful! Please sign in.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      _showError('Registration failed: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/topography.png", fit: BoxFit.cover),
          Container(color: const Color(0xFF5D6253).withOpacity(0.9)),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF26129),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              "WEED",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Text(
                            "DETECTION",
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Email",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "Poppins",
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black54,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "Poppins",
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black54,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Confirm Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "Poppins",
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black54,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF26129),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Register",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                color: Color(0xFFF26129),
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}