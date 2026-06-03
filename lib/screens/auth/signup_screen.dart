import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/country_codes.dart';
import '../../screens/dialogs/country_picker_dialog.dart';
import '../../models/user_model.dart';
import '../../services/firebase_service.dart';
import '../../core/utils/validators.dart';
import '../auth/verification_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _postNameController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late CountryCode _selectedCountry;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _selectedCountry = CountryCodes.countries[0]; // Default to US

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _postNameController.dispose();
    _birthdateController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Sign up with email and password
        final userCredential = await _firebaseService.signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (userCredential != null && userCredential.user != null) {
          // Create full phone number
          final fullPhoneNumber =
              '${_selectedCountry.dialCode}${_phoneController.text.trim()}';

          // Create user model
          final userModel = UserModel(
            uid: userCredential.user!.uid,
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            postName: _postNameController.text.trim(),
            birthDate: _birthdateController.text.trim(),
            phoneNumber: fullPhoneNumber,
            email: _emailController.text.trim(),
            createdAt: DateTime.now(),
          );

          // Save to Firestore
          await _firebaseService.saveUserData(userModel);

          // Send verification email
          await _firebaseService.sendVerificationEmail();

          Get.snackbar(
            'Succès',
            'Inscription réussie! Vérifiez votre email.',
            backgroundColor: AppTheme.successColor,
            colorText: AppTheme.backgroundColor,
          );

          // Navigate to verification screen
          Get.offAll(
            () => VerificationScreen(
              email: _emailController.text.trim(),
              phoneNumber: fullPhoneNumber,
              isEmailVerification: true,
            ),
          );
        }
      } catch (e) {
        Get.snackbar(
          'Erreur',
          e.toString(),
          backgroundColor: AppTheme.errorColor,
          colorText: AppTheme.backgroundColor,
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              _buildMatrixBackground(),
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back button
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.primaryColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Title
                        Text(
                          'INSCRIPTION',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rejoignez le système',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                        ),
                        const SizedBox(height: 32),
                        // Form
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // First name
                              TextFormField(
                                controller: _firstNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Prénom',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                validator: Validators.validateName,
                              ),
                              const SizedBox(height: 16),
                              // Last name
                              TextFormField(
                                controller: _lastNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Nom',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                validator: Validators.validateName,
                              ),
                              const SizedBox(height: 16),
                              // Post name
                              TextFormField(
                                controller: _postNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Post-nom',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                validator: Validators.validateName,
                              ),
                              const SizedBox(height: 16),
                              // Birthdate
                              TextFormField(
                                controller: _birthdateController,
                                decoration: const InputDecoration(
                                  labelText: 'Date de naissance (JJ/MM/AAAA)',
                                  prefixIcon: Icon(Icons.calendar_today),
                                ),
                                validator: Validators.validateDate,
                              ),
                              const SizedBox(height: 16),
                              // Phone with country picker
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              CountryPickerDialog(
                                            initialCountry: _selectedCountry,
                                            onCountrySelected: (country) {
                                              setState(() {
                                                _selectedCountry = country;
                                              });
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppTheme.primaryColor
                                                .withOpacity(0.3),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: AppTheme.surfaceColor,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Pays',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    color: AppTheme
                                                        .textSecondaryColor,
                                                  ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Text(
                                                  _selectedCountry.flag,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  _selectedCountry.dialCode,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        color: AppTheme
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                      controller: _phoneController,
                                      decoration: const InputDecoration(
                                        labelText: 'Téléphone',
                                        prefixIcon: Icon(Icons.phone),
                                        hintText: '123456789',
                                      ),
                                      validator:
                                          Validators.validatePhoneNumber,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Email
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                ),
                                validator: Validators.validateEmail,
                              ),
                              const SizedBox(height: 16),
                              // Password
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Mot de passe',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(
                                        () => _obscurePassword =
                                            !_obscurePassword,
                                      );
                                    },
                                    child: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                ),
                                validator: Validators.validatePassword,
                              ),
                              const SizedBox(height: 16),
                              // Confirm password
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                decoration: InputDecoration(
                                  labelText: 'Confirmer le mot de passe',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(
                                        () => _obscureConfirmPassword =
                                            !_obscureConfirmPassword,
                                      );
                                    },
                                    child: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                ),
                                validator: (value) => Validators
                                    .validateConfirmPassword(
                                      value,
                                      _passwordController.text,
                                    ),
                              ),
                              const SizedBox(height: 24),
                              // Signup Button
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed:
                                      _isLoading ? null : _handleSignup,
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            AppTheme.backgroundColor,
                                          ),
                                        )
                                      : const Text('S\'INSCRIRE'),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Link to login
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Déjà inscrit? ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                  GestureDetector(
                                    onTap: () => Get.back(),
                                    child: Text(
                                      'Se connecter',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppTheme.primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatrixBackground() {
    return CustomPaint(
      painter: MatrixRainPainter(),
      size: Size.infinite,
    );
  }
}

class MatrixRainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor.withOpacity(0.03)
      ..strokeWidth = 1;

    for (int i = 0; i < size.width; i += 50) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
