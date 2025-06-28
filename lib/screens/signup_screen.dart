import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meetmax/screens/signIn_screen.dart';
import '../mock_server/user_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();

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
                  if (val != null) setState(() => _selectedLanguage = val);
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
                      icon: const FaIcon(FontAwesomeIcons.google,
                          color: Colors.black54, size: 16),
                      label: const Text('Log in with Google',
                          style: TextStyle(color: Colors.black87)),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const FaIcon(FontAwesomeIcons.apple,
                          color: Colors.black87, size: 18),
                      label: const Text('Log in with Apple',
                          style: TextStyle(color: Colors.black87)),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                      _inputDecoration(hint: 'Your Email', icon: FontAwesomeIcons.at),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Please enter your email';
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(v)) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Name
                    TextFormField(
                      controller: _nameController,
                      decoration:
                      _inputDecoration(hint: 'Your Name', icon: FontAwesomeIcons.user),
                      validator: (v) => v == null || v.length < 2
                          ? 'Name must be at least 2 characters'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: _inputDecoration(
                        hint: 'Create Password',
                        icon: FontAwesomeIcons.lock,
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          color: Colors.grey,
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (v) => v == null || v.length < 6
                          ? 'Password must be at least 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Date of Birth
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      decoration: _inputDecoration(
                          hint: 'Date of birth', icon: FontAwesomeIcons.calendar),
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
                      validator: (v) =>
                      v == null || v.isEmpty ? 'Please select DOB' : null,
                    ),
                    const SizedBox(height: 20),

                    // Gender selector
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          // 1) Static bold black male symbol
                          const Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: Center(
                              child: Icon(
                                FontAwesomeIcons.mars,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          // 2) Male option
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 2,
                            child: InkWell(
                              onTap: () => setState(() => _gender = 'Male'),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Radio<String>(
                                    value: 'Male',
                                    groupValue: _gender,
                                    onChanged: (v) => setState(() => _gender = v!),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  const Text('Male'),
                                ],
                              ),
                            ),
                          ),

                          // 3) Female option
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 2,
                            child: InkWell(
                              onTap: () => setState(() => _gender = 'Female'),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Radio<String>(
                                    value: 'Female',
                                    groupValue: _gender,
                                    onChanged: (v) => setState(() => _gender = v!),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  const Text('Female'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Sign Up button
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
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sign In prompt
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?',
                            style: TextStyle(color: Colors.black54)),
                        TextButton(
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SignInScreen()),
                          ),
                          child: const Text('Sign In',
                              style:
                              TextStyle(color: Color(0xFF2979FF))),
                        ),
                      ],
                    ),
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

      if (await _userService.isEmailAlreadyRegistered(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This email is already registered.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await _userService.registerUser(
          name: name, email: email, password: password, birthdate: dob);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
            Text('Registration successful! Redirecting to Sign In...'),
            backgroundColor: Colors.green),
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => SignInScreen()));
      });
    }
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
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
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}
