import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meetmax/screens/forgot_password_screen.dart';
import 'package:meetmax/screens/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _rememberMe = false;
  bool _obscurePassword = true;
  String _selectedLanguage = 'English (UK)';
  final _languages = ['English (UK)', 'বাংলা'];
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue),
              const SizedBox(width: 6),
              const Text(
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth > 600 ? 80 : 24,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome section
                  SizedBox(height: constraints.maxHeight > 800 ? 40 : 20),
                  const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Welcome back, you've been missed!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: constraints.maxHeight > 800 ? 40 : 30),

                  // Side-by-side social login buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildSocialButton(
                          icon: FontAwesomeIcons.google,
                          label: 'Login with Google',
                          color: Colors.black54,
                          onPressed: () {
                            // TODO: Implement Google Sign-In
                            // Backend Integration Point:
                            // Use Firebase Authentication or your preferred auth service
                            // Example:
                            // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
                            // final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
                            // final credential = GoogleAuthProvider.credential(
                            //   accessToken: googleAuth?.accessToken,
                            //   idToken: googleAuth?.idToken,
                            // );
                            // await FirebaseAuth.instance.signInWithCredential(credential);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSocialButton(
                          icon: FontAwesomeIcons.apple,
                          label: 'Login with Apple',
                          color: Colors.black87,
                          onPressed: () {
                            // TODO: Implement Apple Sign-In
                            // Backend Integration Point:
                            // Use Sign In with Apple for iOS 13+ devices
                            // Example:
                            // final credential = await SignInWithApple.getAppleIDCredential(
                            //   scopes: [
                            //     AppleIDAuthorizationScopes.email,
                            //     AppleIDAuthorizationScopes.fullName,
                            //   ],
                            // );
                            // final oauthCredential = OAuthProvider("apple.com").credential(
                            //   idToken: credential.identityToken,
                            //   accessToken: credential.authorizationCode,
                            // );
                            // await FirebaseAuth.instance.signInWithCredential(oauthCredential);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // OR divider
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey, thickness: 0.8)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text('OR', style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold)),
                      ),
                      Expanded(child: Divider(color: Colors.grey, thickness: 0.8)),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Email input field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Your Email',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 12),
                        child: Icon(FontAwesomeIcons.at, color: Colors.grey[600]),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password input field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Create Password',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 12),
                        child: Icon(Icons.lock, color: Colors.grey[600]),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Remember me and Forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Remember me checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value!;
                              });
                            },
                            activeColor: const Color(0xFF2979FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const Text('Remember me',
                              style: TextStyle(color: Colors.black54)),
                        ],
                      ),

                      // Forgot password
                      TextButton(
                        onPressed: () {
                          // TODO: Implement Forgot Password functionality
                          // Backend Integration Point:
                          // Send password reset email to the user
                          // Example:
                          // try {
                          //   await FirebaseAuth.instance
                          //     .sendPasswordResetEmail(email: _emailController.text);
                          //   showSuccessDialog('Password reset email sent!');
                          // } catch (e) {
                          //   showErrorDialog('Failed to send reset email: ${e.toString()}');
                          // }
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                          );
                        },
                        child: const Text('Forgot Password?',
                            style: TextStyle(color: Color(0xFF2979FF))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Sign In button
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement Email/Password Sign-In
                      // Backend Integration Point:
                      // Validate and authenticate user credentials
                      // Example:
                      // try {
                      //   final userCredential = await FirebaseAuth.instance
                      //     .signInWithEmailAndPassword(
                      //       email: _emailController.text,
                      //       password: _passwordController.text,
                      //     );
                      //   // Navigate to home screen
                      // } on FirebaseAuthException catch (e) {
                      //   if (e.code == 'user-not-found') {
                      //     showErrorDialog('No user found for that email.');
                      //   } else if (e.code == 'wrong-password') {
                      //     showErrorDialog('Wrong password provided.');
                      //   }
                      // }
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2979FF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Sign up prompt
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("You haven't any account?",
                          style: TextStyle(color: Colors.black54)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => SignUpScreen()),
                          );
                        },
                        child: const Text('Sign Up',
                          style: TextStyle(
                            color: Color(0xFF2979FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: constraints.maxHeight > 800 ? 40 : 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Social button widget
  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade100,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}