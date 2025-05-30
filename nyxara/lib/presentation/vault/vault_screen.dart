import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nyxara/core/router/routes_consts.dart';
import 'package:nyxara/core/theme/app_colors.dart';
import 'package:nyxara/presentation/auth/bloc/auth_bloc.dart';
import 'package:nyxara/presentation/common/navbar.dart';
import 'package:o3d/o3d.dart';

class VaultItem {
  final String id;
  final String title;
  final String key;
  final String value;

  VaultItem({
    required this.id,
    required this.title,
    required this.key,
    required this.value,
  });
}

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});
  @override
  createState() => _VaultScreen();
}

class _VaultScreen extends State<VaultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _gradientController;
  late Animation<double> _radiusAnimation;
  O3DController o3dController = O3DController();
  bool _isLocked = true;
  bool _isAnimationPlaying = false;
  final TextEditingController _searchController = TextEditingController();
  List<VaultItem> _vaultItems = [];
  List<VaultItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();

    // Initialize gradient animation
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _radiusAnimation = Tween<double>(begin: 0.5, end: 0.8).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );

    // Initialize vault items
    _initializeVaultItems();
  }

  void _initializeVaultItems() {
    _vaultItems = [
      VaultItem(
        id: '1',
        title: 'Email Password',
        key: 'user@example.com',
        value: '********',
      ),
      VaultItem(
        id: '2',
        title: 'WiFi Password',
        key: 'Home Network',
        value: 'securepassword123',
      ),
      VaultItem(
        id: '3',
        title: 'Bank Account',
        key: 'Account Number',
        value: '**** **** **** 1234',
      ),
      VaultItem(
        id: '4',
        title: 'SSH Key',
        key: 'server-01',
        value: 'rsa-2048-key',
      ),
      VaultItem(
        id: '5',
        title: 'API Token',
        key: 'Payment Gateway',
        value: 'sk_live_*******',
      ),
    ];
    _filteredItems = _vaultItems;
  }

  void _toggleLock() {
    setState(() {
      _isLocked = !_isLocked;
      _isAnimationPlaying = !_isAnimationPlaying;

      if (_isAnimationPlaying) {
        o3dController.play();
      } else {
        o3dController.resetAnimation();
        o3dController.pause();
      }
    });
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems =
          _vaultItems.where((item) {
            return item.title.toLowerCase().contains(query.toLowerCase());
          }).toList();
    });
  }

  void _handleAdd() {
    log("Add button pressed");
    // Implement add functionality
  }

  void _handleUpdate() {
    log("Update button pressed");
    // Implement update functionality
  }

  void _handleDelete() {
    log("Delete button pressed");
    // Implement delete functionality
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NyxaraNavbar(title: "NyxVault"),
      body: Stack(
        children: [
          // Background with animated gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                opacity: 1,
                image: AssetImage('vault_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: AnimatedBuilder(
              animation: _radiusAnimation,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      radius: _radiusAnimation.value,
                      colors: [
                        AppColors.primaryVariant.withValues(alpha: 0.2),
                        AppColors.primaryVariant.withValues(alpha: 0.1),
                        AppColors.primaryVariant.withValues(alpha: 0.05),
                        AppColors.appleColor.withValues(alpha: 0.3),
                        AppColors.appleColor.withValues(alpha: 0.2),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 3D Lock Model
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height / 3,
                child: O3D(
                  src: 'assets/play_chess_in_reverse_to_open_2.glb',
                  controller: o3dController,
                  ar: false,
                  autoPlay: false,
                  autoRotate: false,
                  cameraControls: true,
                  cameraOrbit: CameraOrbit(-150, 80, 100),
                ),
              ),
            ),
          ),

          // Lock Control Button
          Positioned(
            top: MediaQuery.of(context).size.height / 3,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: _toggleLock,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: AppColors.accentBlue, // border color
                    width: 0.5, // border width
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: AppColors.background.withValues(alpha: 0.7),
                child: Icon(
                  _isLocked ? Icons.lock_open : Icons.lock,
                  size: 32,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          // Vault Content (visible when unlocked)
          if (!_isLocked) ...[
            // Search Bar
            Positioned(
              top: MediaQuery.of(context).size.height / 2.5,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterItems,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search by title...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.white),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.white),
                              onPressed: () {
                                _searchController.clear();
                                _filterItems('');
                              },
                            )
                            : null,
                  ),
                ),
              ),
            ),

            // Vault Items List
            Positioned(
              top: MediaQuery.of(context).size.height / 2,
              bottom: 80,
              left: 0,
              right: 0,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return _buildVaultCard(item);
                },
              ),
            ),

            // Action Buttons
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(Icons.add, 'Add', _handleAdd),
                  _buildActionButton(Icons.edit, 'Update', _handleUpdate),
                  _buildActionButton(Icons.delete, 'Delete', _handleDelete),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVaultCard(VaultItem item) {
    return Card(
      color: Colors.black.withValues(alpha: 0.3),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: AppColors.accentBlue.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Key: ',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      item.key,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text(
                      'Value: ',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      item.value,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 50,
              width: 50,
              child: O3D.asset(
                src: 'assets/rubik_key.glb',
                autoRotate: true,
                cameraControls: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        FloatingActionButton(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.5, color: AppColors.primaryVariant),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          heroTag: label,
          onPressed: onPressed,
          backgroundColor: AppColors.background.withValues(alpha: 0.3),
          mini: true,
          child: Icon(icon, color: AppColors.primaryLight),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
