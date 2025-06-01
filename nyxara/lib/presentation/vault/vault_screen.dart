import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:nyxara/core/router/routes_consts.dart';
import 'package:nyxara/core/theme/app_colors.dart';
import 'package:nyxara/core/theme/app_text_styles.dart';
import 'package:nyxara/presentation/auth/bloc/auth_bloc.dart';
import 'package:nyxara/presentation/common/navbar.dart';
import 'package:nyxara/presentation/vault/bloc/vault_bloc.dart';
import 'package:nyxara/presentation/vault/masterkey_popup.dart';
import 'package:o3d/o3d.dart';

class VaultItem {
  final String title;
  final String key;
  final String value;

  VaultItem({required this.title, required this.key, required this.value});
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

    //auth

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AuthState authState = context.read<AuthBloc>().state;

      if (authState is! Authenticated) {
        context.goNamed(NyxaraRoutes.loginPageRoute);
      } else {
        //check vault presence from here
        context.read<VaultBloc>().add(VaultCheckEvent(email: authState.email));
      }
    });

    // Initialize gradient animation
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _radiusAnimation = Tween<double>(begin: 0.5, end: 0.8).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );
  }

  void _toggleLock() {
    if (_isLocked) {
      setState(() {
        _isAnimationPlaying = true;
      });
      showDialog(
        context: context,
        builder:
            (context) => MasterKeyVerificationPopup(
              onVerified: (masterKey) async {
                AuthState authstate = context.read<AuthBloc>().state;
                if (authstate is Authenticated) {
                  log("Event added 1");

                  context.read<VaultBloc>().add(
                    VaultOpenEvent(
                      masterKey: masterKey,
                      email: authstate.email,
                    ),
                  );

                  log("Event added");
                }
              },
            ),
      );
    } else {
      context.read<VaultBloc>().add(VaultCloseEvent());
      setState(() {
        _isAnimationPlaying = false;
      });
    }

    if (_isAnimationPlaying) {
      o3dController.play();
    } else {
      o3dController.resetAnimation();
      o3dController.pause();
    }
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

          BlocConsumer<VaultBloc, VaultState>(
            listener: (context, state) {
              if (state is ClosedVaultState) {
                Fluttertoast.showToast(msg: "Closing Vault...");
                setState(() {
                  _isLocked = true;
                  _isAnimationPlaying = false;
                });
              }
              if (state is VaultPresenceCheckingState) {
                Fluttertoast.showToast(
                  msg: "Checking vault in database.....",
                  toastLength: Toast.LENGTH_LONG,
                  webPosition: "center",
                );
              }
              if (state is VaultcreateErrorState) {
                Fluttertoast.showToast(
                  msg: "Unknown Error occured while creating vault",
                  toastLength: Toast.LENGTH_LONG,
                  webPosition: "center",
                );
              }
              if (state is OpenedVaultState) {
                setState(() {
                  log("Setting items...");
                  _vaultItems =
                      state.secrets
                          .map(
                            (secret) => VaultItem(
                              title: secret['title']!,
                              key: secret['key']!,
                              value: secret['value']!,
                            ),
                          )
                          .toList();
                  log(_vaultItems[0].title.toString());
                  _filterItems('');
                  _isLocked = false;
                  _isAnimationPlaying = true;
                });
              }
              if (state is OpeningVaultState) {
                Fluttertoast.showToast(
                  msg: "Revealing secrets..",
                  toastLength: Toast.LENGTH_SHORT,
                );
              }
              if (state is OpenFailureVaultState) {
                Fluttertoast.showToast(
                  msg: "Error opening vault",
                  textColor: Colors.red,
                  toastLength: Toast.LENGTH_LONG,
                );
              }
            },
            builder: (context, state) {
              if (state is VaultInitial) {
                return loader('Loading....');
              }

              if (state is VaultPresenceCheckingState) {
                return loader("");
              }
              if (state is VaultPresentState || state is OpenedVaultState) {
                return Stack(
                  children: [
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
                          backgroundColor: AppColors.background.withValues(
                            alpha: 0.7,
                          ),
                          child: Icon(
                            _isLocked ? Icons.lock_open : Icons.lock,
                            size: 32,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    // Lock Control Button;
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
                            color: AppColors.cardBackground.withValues(
                              alpha: 0.5,
                            ),
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
                                        icon: Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                        ),
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
                            _buildActionButton(
                              Icons.edit,
                              'Update',
                              _handleUpdate,
                            ),
                            _buildActionButton(
                              Icons.delete,
                              'Delete',
                              _handleDelete,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              }
              if (state is VaultNotPresentState) {
                return Center(
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.lock_sharp,
                      color: AppColors.textOnPrimary,
                    ),
                    label: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Create NyxVault",
                        style: AppTextStyles.withColor(
                          AppTextStyles.authButtonText,
                          AppColors.textOnPrimary,
                        ),
                      ),
                    ),
                    onPressed: () => {_openForm(context)},
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        AppColors.glowBlue,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.5,
                            color: AppColors.authCardBackground,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                );
              }
              if (state is VaultPresenceCheckingErrorState) {
                return Center(
                  child: Text(
                    "Vault Check Error",
                    style: AppTextStyles.errorText,
                  ),
                );
              }
              if (state is VaultCreatingState) {
                return loader('Creating vault...');
              }
              if (state is VaultCreatedState) {
                return Dialog(
                  backgroundColor: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  elevation: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header with icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.amber[600],
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "SECURITY ALERT",
                              style: TextStyle(
                                color: Colors.amber[600],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Warning message
                        Text(
                          "Your Master Key can be viewed only once!",
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Store it securely before closing this dialog.",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Master Key Display
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.blueAccent.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "MASTER KEY",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 12,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SelectableText(
                                state.masterKey,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  fontFamily: 'monospace',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Copy button with security warning
                        Column(
                          children: [
                            Tooltip(
                              message: "Copy to clipboard",
                              child: IconButton(
                                icon: Icon(
                                  Icons.content_copy,
                                  color: Colors.blue[300],
                                ),
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: state.masterKey),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Master Key copied to clipboard",
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Text(
                              "Ensure clipboard is cleared after use",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Close button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<VaultBloc>().add(
                                PopMasterKeyEvent(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[900],
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              softWrap: true,
                              textAlign: TextAlign.center,
                              "I HAVE SECURELY STORED THE KEY",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Text("still handling");
            },
          ),
        ],
      ),

      //building
      // return Text("Still UNDER Process..");
    );
  }

  Widget loader(String label) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text(label, style: AppTextStyles.displayMedium),
        ],
      ),
    );
  }

  Widget _buildVaultCard(VaultItem item) {
    log("I am trigerred...");
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
                      item.value.length > 7
                          ? '${item.value.substring(0, 7)}${'•' * 3}'
                          : item.value,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
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

  void _openForm(BuildContext context) {
    _showMasterKeyPopup(context);
  }
}

void _showMasterKeyPopup(BuildContext context) {
  showDialog(context: context, builder: (context) => const MasterKeyPopup());
}

class MasterKeyPopup extends StatefulWidget {
  const MasterKeyPopup({super.key});

  @override
  State<MasterKeyPopup> createState() => _MasterKeyPopupState();
}

class _MasterKeyPopupState extends State<MasterKeyPopup> {
  final _formKey = GlobalKey<FormState>();
  final _masterKeyController = TextEditingController();

  @override
  void dispose() {
    _masterKeyController.dispose();
    super.dispose();
  }

  String? _validateMasterKey(String? value) {
    if (value == null || value.isEmpty) {
      return 'Master key is required';
    }
    if (value.length < 6) {
      return 'Key must be at least 6 characters';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Add special characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Include uppercase letters';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process the secure key here
      AuthState authstate = context.read<AuthBloc>().state;
      if (authstate is Authenticated) {
        context.read<VaultBloc>().add(
          VaultCreateEvent(
            email: authstate.email,
            masterKey: _masterKeyController.text,
          ),
        );
      }
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Creating NyxVault...'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.lock, color: Colors.blue[700], size: 32),
                  const SizedBox(width: 12),
                  Text(
                    'SECURE ACCESS',
                    style: TextStyle(
                      color: Colors.blue[300],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Master Key Field
              TextFormField(
                controller: _masterKeyController,
                obscureText: true,
                obscuringCharacter: '*',
                validator: _validateMasterKey,
                style: const TextStyle(color: Colors.white, letterSpacing: 2),
                decoration: InputDecoration(
                  labelText: 'Enter Master Key',
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.vpn_key, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.lightBlue),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                  shadowColor: Colors.blueAccent,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_user, color: Colors.lightBlue),
                    SizedBox(width: 10),
                    Text(
                      'ENTER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
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
}
