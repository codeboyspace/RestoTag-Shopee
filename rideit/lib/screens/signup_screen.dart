import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rideit/screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String _password = '';
  double _passwordStrength = 0;

  // Colors to match the design
  final Color orangeColor = Color(0xFFFF6600);
  final Color textColor = Color(0xFF333333);
  final Color hintColor = Color(0xFF9E9E9E);

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength() {
    String password = _passwordController.text;
    setState(() {
      _password = password;

      if (password.isEmpty) {
        _passwordStrength = 0;
      } else {
        // Check password strength
        int length = password.length;
        bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
        bool hasLowercase = password.contains(RegExp(r'[a-z]'));
        bool hasNumbers = password.contains(RegExp(r'[0-9]'));
        bool hasSpecialChars = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

        int strength = 0;
        if (length > 7) strength += 1;
        if (length > 11) strength += 1;
        if (hasUppercase) strength += 1;
        if (hasLowercase) strength += 1;
        if (hasNumbers) strength += 1;
        if (hasSpecialChars) strength += 1;

        _passwordStrength = strength / 6;
      }
    });
  }

  Color _getPasswordStrengthColor() {
    if (_passwordStrength <= 0.3) return Colors.red;
    if (_passwordStrength <= 0.7) return Colors.orange;
    return Colors.green;
  }

  String _getPasswordStrengthText() {
    if (_passwordStrength <= 0) return '';
    if (_passwordStrength <= 0.3) return 'Weak';
    if (_passwordStrength <= 0.7) return 'Good';
    return 'Strong';
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to the login screen upon successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );

    } catch (e) {
      String errorMessage = "Registration failed";

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = "This email is already registered";
            break;
          case 'invalid-email':
            errorMessage = "Invalid email format";
            break;
          case 'weak-password':
            errorMessage = "Password is too weak";
            break;
          default:
            errorMessage = e.message ?? errorMessage;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 20),
                        _buildEmailField(),
                        SizedBox(height: 24),
                        _buildPasswordField(),
                        if (_password.isNotEmpty) ...[
                          SizedBox(height: 12),
                          _buildPasswordStrengthIndicator(),
                        ],
                        SizedBox(height: 40),
                        _buildCreateAccountButton(),
                        SizedBox(height: 24),
                        _buildSignInLink(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: 40, bottom: 20),
      decoration: BoxDecoration(
        color: orangeColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: orangeColor.withOpacity(0.3),
            offset: Offset(0, 4),
            blurRadius: 8,
          )
        ],
      ),
      width: double.infinity,
      child: Column(
        children: [
          Text(
            "RestoTag Shopee",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset(
              'assets/wave_line.png',
              height: 30,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 30,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: WaveLinePainter(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color.fromARGB(0, 250, 250, 250),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: orangeColor,
                selectionColor: orangeColor.withOpacity(0.3),
                selectionHandleColor: orangeColor,
              ),
            ),
            child: TextFormField(
              controller: _emailController,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
              cursorWidth: 1.5,
              cursorRadius: Radius.circular(2),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: orangeColor,
                    width: 2,
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red[400]!,
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red[400]!,
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.grey[400],
                  size: 20,
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                hintText: "Enter your email address",
                hintStyle: TextStyle(
                  color: hintColor,
                  fontSize: 15,
                ),
                errorStyle: TextStyle(
                  color: Colors.red[400],
                  fontSize: 12,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: orangeColor,
                selectionColor: orangeColor.withOpacity(0.3),
                selectionHandleColor: orangeColor,
              ),
            ),
            child: TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
              cursorWidth: 1.5,
              cursorRadius: Radius.circular(2),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: orangeColor,
                    width: 2,
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red[400]!,
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red[400]!,
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Colors.grey[400],
                  size: 20,
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                  splashRadius: 20,
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                hintText: "Enter your password",
                hintStyle: TextStyle(
                  color: hintColor,
                  fontSize: 15,
                ),
                errorStyle: TextStyle(
                  color: Colors.red[400],
                  fontSize: 12,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _password = value;
                  // Calculate password strength - will call via listener
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: _passwordStrength,
                backgroundColor: Colors.transparent,
                color: _getPasswordStrengthColor(),
                minHeight: 6,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Text(
          _getPasswordStrengthText(),
          style: TextStyle(
            color: _getPasswordStrengthColor(),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccountButton() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: orangeColor.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _register,
        child: _isLoading
          ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : Text(
              "Create Account",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
        style: ElevatedButton.styleFrom(
          backgroundColor: orangeColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          minimumSize: Size(double.infinity, 55),
        ),
      ),
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Text(
            "Sign In",
            style: TextStyle(
              color: orangeColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          style: TextButton.styleFrom(
            minimumSize: Size(0, 0),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}

// Custom painter for the wave line if image is not available
class WaveLinePainter extends CustomPainter {
  final Color color;

  WaveLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Path path = Path();
    path.moveTo(0, size.height / 2);

    // Fixed version - using an integer index and calculating position with doubles
    for (int i = 0; i < 10; i++) {
      double startX = i * (size.width / 10);
      double controlX = startX + (size.width / 20);
      double endX = startX + (size.width / 10);
      double controlY = i % 2 == 0 ? 0 : size.height; // Using modulo on integer

      path.quadraticBezierTo(
        controlX,
        controlY,
        endX,
        size.height / 2
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
