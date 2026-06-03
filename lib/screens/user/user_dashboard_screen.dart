import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import '../../models/user_model.dart';
import '../../services/firebase_service.dart';
import '../../services/messaging_service.dart';
import '../messenger/messenger_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({Key? key}) : super(key: key);

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final FirebaseService _firebaseService = FirebaseService();
  final MessagingService _messagingService = MessagingService();
  UserModel? _userModel;
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final currentUser = _firebaseService.getCurrentUser();
      if (currentUser != null) {
        final userData = await _firebaseService.getUserData(currentUser.uid);
        setState(() {
          _userModel = userData;
          _isLoading = false;
        });
        _animationController.forward();
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        e.toString(),
        backgroundColor: AppTheme.errorColor,
        colorText: AppTheme.backgroundColor,
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(
          'Déconnexion',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: Text(
          'Êtes-vous sûr de vouloir vous déconnecter?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Annuler',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              try {
                await _firebaseService.signOut();
                Get.offAllNamed('/welcome');
              } catch (e) {
                Get.snackbar(
                  'Erreur',
                  e.toString(),
                  backgroundColor: AppTheme.errorColor,
                  colorText: AppTheme.backgroundColor,
                );
              }
            },
            child: Text(
              'Déconnecter',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.errorColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          _buildMatrixBackground(),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                  ),
                )
              : SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildContent(),
                  ),
                ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildContent() {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        const MessengerScreen(),
        _buildProfileView(),
        _buildSettingsView(),
      ],
    );
  }

  Widget _buildProfileView() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryColor,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  _userModel?.firstName.characters.first ?? 'U',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // User info
            Text(
              _userModel?.fullName ?? 'Utilisateur',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _userModel?.email ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // User details
            _buildInfoCard('Prénom', _userModel?.firstName ?? 'N/A'),
            _buildInfoCard('Nom', _userModel?.lastName ?? 'N/A'),
            _buildInfoCard('Post-nom', _userModel?.postName ?? 'N/A'),
            _buildInfoCard('Date de naissance', _userModel?.birthDate ?? 'N/A'),
            _buildInfoCard(
              'Téléphone',
              _userModel?.phoneNumber ?? 'N/A',
            ),
            const SizedBox(height: 24),
            // Edit profile button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () {
                  Get.snackbar(
                    'Info',
                    'Modification du profil bientôt disponible',
                    backgroundColor: AppTheme.secondaryColor,
                    colorText: AppTheme.backgroundColor,
                  );
                },
                child: const Text('MODIFIER LE PROFIL'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsView() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PARAMÈTRES',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 24),
            // Settings items
            _buildSettingsTile(
              'Notifications',
              'Gérer vos notifications',
              Icons.notifications,
              () {
                Get.snackbar(
                  'Info',
                  'Paramètres de notifications bientôt disponibles',
                  backgroundColor: AppTheme.secondaryColor,
                  colorText: AppTheme.backgroundColor,
                );
              },
            ),
            _buildSettingsTile(
              'Confidentialité',
              'Contrôler votre confidentialité',
              Icons.security,
              () {
                Get.snackbar(
                  'Info',
                  'Paramètres de confidentialité bientôt disponibles',
                  backgroundColor: AppTheme.secondaryColor,
                  colorText: AppTheme.backgroundColor,
                );
              },
            ),
            _buildSettingsTile(
              'Sécurité',
              'Gérer la sécurité de votre compte',
              Icons.lock,
              () {
                Get.snackbar(
                  'Info',
                  'Paramètres de sécurité bientôt disponibles',
                  backgroundColor: AppTheme.secondaryColor,
                  colorText: AppTheme.backgroundColor,
                );
              },
            ),
            _buildSettingsTile(
              'À propos',
              'Informations sur l\'application',
              Icons.info,
              () {
                Get.snackbar(
                  'À propos',
                  'Arcane-Ops v1.0.0\nMatrix Hacker Theme',
                  backgroundColor: AppTheme.secondaryColor,
                  colorText: AppTheme.backgroundColor,
                );
              },
            ),
            const SizedBox(height: 32),
            // Logout button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorColor,
                ),
                child: const Text('DÉCONNEXION'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(12),
        color: AppTheme.surfaceColor,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppTheme.primaryColor,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor.withOpacity(0.7),
              ),
        ),
        trailing: const Icon(
          Icons.arrow_forward,
          color: AppTheme.primaryColor,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(8),
        color: AppTheme.surfaceColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        color: AppTheme.surfaceColor,
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        backgroundColor: AppTheme.surfaceColor,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondaryColor.withOpacity(0.5),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }

  Widget _buildMatrixBackground() {
    return CustomPaint(
      painter: MatrixBackgroundPainter(),
      size: Size.infinite,
    );
  }
}

class MatrixBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor.withOpacity(0.05)
      ..strokeWidth = 1;

    for (int i = 0; i < size.width; i += 40) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }

    for (int i = 0; i < size.height; i += 40) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
