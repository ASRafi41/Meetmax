import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meetmax/screens/signIn_screen.dart';
import '../mock_server/user_service.dart'; // Backend service

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService(); // Hive backend service

  bool _obscurePassword = true;
  String _gender = 'Male';
  String _selectedLanguage = 'English (UK)';
  final _languages = ['English (UK)', 'বাংলা'];

  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue),
              SizedBox(width: 6),
              Text(
                'Meetmax',
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        leadingWidth: 150,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLanguage,
                items: _languages
                    .map((lang) => DropdownMenuItem(
                  value: lang,
                  child: Text(lang, style: TextStyle(fontSize: 14)),
                ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedLanguage = val;
                    });
                  }
                },
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Getting Started',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Create an account to continue and connect\nwith the people.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 30),

              // Social login buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const FaIcon(FontAwesomeIcons.google, color: Colors.black54, size: 16),
                      label: const Text('Log in with Google', style: TextStyle(color: Colors.black87)),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        backgroundColor: Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const FaIcon(FontAwesomeIcons.apple, color: Colors.black87, size: 18),
                      label: const Text('Log in with Apple', style: TextStyle(color: Colors.black87)),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        backgroundColor: Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // OR divider
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey, thickness: 0.5)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('OR', style: TextStyle(color: Colors.black54)),
                  ),
                  Expanded(child: Divider(color: Colors.grey, thickness: 0.5)),
                ],
              ),
              const SizedBox(height: 24),

              // Registration form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration(
                        hint: 'Your Email',
                        icon: FontAwesomeIcons.at,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration(
                        hint: 'Your Name',
                        icon: FontAwesomeIcons.user,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        if (value.length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: _inputDecoration(
                        hint: 'Create Password',
                        icon: FontAwesomeIcons.lock,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      decoration: _inputDecoration(
                        hint: 'Date of birth',
                        icon: FontAwesomeIcons.calendar,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your date of birth';
                        }
                        return null;
                      },
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          _dobController.text =
                          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // Gender radio buttons
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              value: 'Male',
                              groupValue: _gender,
                              onChanged: (value) => setState(() => _gender = value!),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const FaIcon(FontAwesomeIcons.mars, size: 18, color: Colors.blue),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Male'),
                                ],
                              ),
                              dense: true,
                            ),
                          ),
                          Container(height: 30, width: 1, color: Colors.grey.shade400),
                          Expanded(
                            child: RadioListTile<String>(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              value: 'Female',
                              groupValue: _gender,
                              onChanged: (value) => setState(() => _gender = value!),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.pink.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const FaIcon(FontAwesomeIcons.venus, size: 18, color: Colors.pink),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Female'),
                                ],
                              ),
                              dense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Sign Up Button
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2979FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sign In Prompt
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?', style: TextStyle(color: Colors.black54)),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => SignInScreen()),
                            );
                          },
                          child: const Text('Sign In', style: TextStyle(color: Color(0xFF2979FF))),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final name = _nameController.text.trim();
      final password = _passwordController.text.trim();
      final dob = _dobController.text.trim();

      final emailExists = await _userService.isEmailAlreadyRegistered(email);

      if (emailExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This email is already registered.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await _userService.registerUser(
        name: name,
        email: email,
        password: password,
        birthdate: dob,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Redirecting to Sign In...'),
          backgroundColor: Colors.green,
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      });
    }
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      prefixIcon: Container(
        margin: const EdgeInsets.only(right: 12, left: 8),
        padding: const EdgeInsets.only(left: 8),
        child: FaIcon(icon, size: 18, color: Colors.grey[700]),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 32),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    );
  }
}
