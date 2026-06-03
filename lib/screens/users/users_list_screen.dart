import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import '../../services/firebase_service.dart';
import '../../services/messaging_service.dart';
import '../../models/user_model.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({Key? key}) : super(key: key);

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final FirebaseService _firebaseService = FirebaseService();
  final MessagingService _messagingService = MessagingService();
  final _searchController = TextEditingController();
  late String _currentUserId;
  bool _isLoading = true;
  List<UserModel> _allUsers = [];
  List<UserModel> _filteredUsers = [];

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

    _initializeScreen();
  }

  void _initializeScreen() {
    final user = _firebaseService.getCurrentUser();
    if (user != null) {
      _currentUserId = user.uid;
      _loadUsers();
    }
  }

  Future<void> _loadUsers() async {
    try {
      // In a real app, fetch from Firestore
      // For now, using mock data
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _filteredUsers = _allUsers;
        _isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les utilisateurs',
        backgroundColor: AppTheme.errorColor,
        colorText: AppTheme.backgroundColor,
      );
      setState(() => _isLoading = false);
    }
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = _allUsers;
      } else {
        _filteredUsers = _allUsers
            .where((user) =>
                user.firstName.toLowerCase().contains(query.toLowerCase()) ||
                user.lastName.toLowerCase().contains(query.toLowerCase()) ||
                user.email.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _startConversation(UserModel user) async {
    try {
      final conversationId = await _messagingService.createOrGetConversation(
        _currentUserId,
        user.uid,
      );

      Get.snackbar(
        'Succès',
        'Conversation créée!',
        backgroundColor: AppTheme.successColor,
        colorText: AppTheme.backgroundColor,
      );

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        e.toString(),
        backgroundColor: AppTheme.errorColor,
        colorText: AppTheme.backgroundColor,
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(
          'UTILISATEURS',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        elevation: 0,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primaryColor.withOpacity(0.2),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryColor,
                ),
              ),
            )
          : Column(
              children: [
                // Search bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppTheme.primaryColor.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterUsers,
                    decoration: InputDecoration(
                      hintText: 'Rechercher un utilisateur...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                // Users list
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _filteredUsers.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 64,
                                  color: AppTheme.primaryColor
                                      .withOpacity(0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Aucun utilisateur trouvé',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppTheme.textSecondaryColor,
                                      ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: _filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = _filteredUsers[index];
                              return _buildUserTile(user);
                            },
                          ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildUserTile(UserModel user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(12),
        color: AppTheme.surfaceColor,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryColor,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                user.firstName.characters.first.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryColor.withOpacity(0.7),
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Message button
          GestureDetector(
            onTap: () => _startConversation(user),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryColor,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.message,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
