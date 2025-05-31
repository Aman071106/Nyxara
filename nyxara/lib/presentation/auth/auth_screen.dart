import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:nyxara/core/router/routes_consts.dart';
import 'package:nyxara/core/theme/app_colors.dart';
import 'package:nyxara/core/theme/app_dimensions.dart';
import 'package:nyxara/core/theme/app_text_styles.dart';
import 'package:nyxara/presentation/auth/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _shakeController;
  late TextEditingController _otpController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _shakeAnimation;

  bool wantsToLogin = true;
  bool _obscurePassword = true;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        context.goNamed(NyxaraRoutes.dashboardRoute);
      }
    });

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _otpController = TextEditingController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _shakeController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      _isEmailValid = _emailController.text.trim().contains('@');
      _isPasswordValid = _passwordController.text.trim().length >= 6;
    });

    if (!_isEmailValid || !_isPasswordValid) {
      _shakeController.forward().then((_) {
        _shakeController.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Animated background
          _buildAnimatedBackground(),

          // Content
          SafeArea(
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  context.goNamed(NyxaraRoutes.dashboardRoute);
                }
                if (state is SignedUp) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Account Created In Nyxara Database Successfully!",
                      ),
                    ),
                  );
                }
                if (state is NotSignedUp) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Unsuccessful signup attempt!!")),
                  );
                }
                if (state is SendingOTPstate) {
                  Fluttertoast.showToast(
                    toastLength: Toast.LENGTH_LONG,
                    msg: "OTP is being send to ${state.email} ...",
                  );
                }
                if (state is OTPsentState) {
                  Fluttertoast.showToast(
                    toastLength: Toast.LENGTH_LONG,
                    msg: "OTP-Sent Successfully",
                  );

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("Enter OTP"),
                        content: TextField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: InputDecoration(
                            hintText: "Enter 6-digit OTP",
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              final otp = _otpController.text.trim();
                              if (otp.length == 6) {
                                if (otp == state.otp.toString()) {
                                  context.read<AuthBloc>().add(
                                    SignUpRequested(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    ),
                                  );
                                  Fluttertoast.showToast(
                                    msg: "OTP is correct!",
                                  );
                                } else {
                                  Fluttertoast.showToast(msg: "Invalid OTP!");
                                }
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text("Verify"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              builder: (context, state) {
                if (state is Logging || state is SigningUp) {
                  return _buildLoadingState();
                }
                if (state is OTPsentState) {}
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildMainContent(state),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gradientStart.withValues(alpha: 0.05),
            AppColors.gradientEnd.withValues(alpha: 0.1),
            AppColors.background,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Floating particles
          ...List.generate(6, (index) {
            return Positioned(
              top: 50.0 + (index * 120),
              left:
                  (index % 2 == 0)
                      ? -20
                      : MediaQuery.of(context).size.width - 60,
              child: TweenAnimationBuilder<double>(
                duration: Duration(seconds: 3 + index),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(
                      (index % 2 == 0) ? value * 100 : -value * 100,
                      0,
                    ),
                    child: Container(
                      width: 40 + (index * 5),
                      height: 40 + (index * 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: [
                          AppColors.accentBlue,
                          AppColors.accentPurple,
                          AppColors.primary,
                        ][index % 3].withValues(alpha: 0.1),
                        border: Border.all(
                          color: [
                            AppColors.accentBlue,
                            AppColors.accentPurple,
                            AppColors.primary,
                          ][index % 3].withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
          border: Border.all(color: AppColors.borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: AppDimensions.shadowBlur,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            Text(
              wantsToLogin ? 'Authenticating...' : 'Creating Account...',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(AuthState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          children: [
            const SizedBox(height: AppDimensions.paddingXXL),

            // Header section
            _buildHeader(),

            const SizedBox(height: AppDimensions.paddingXXL),

            // Auth form
            _buildAuthForm(state),

            const SizedBox(height: AppDimensions.paddingL),

            // Switch mode button
            _buildSwitchModeButton(),

            const SizedBox(height: AppDimensions.paddingXL),

            // Back to home
            _buildBackToHome(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo/Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryVariant],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: AppDimensions.shadowBlur,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.security,
            color: AppColors.textOnPrimary,
            size: AppDimensions.iconL + 8,
          ),
        ),

        const SizedBox(height: AppDimensions.paddingL),

        Text(
          wantsToLogin ? 'Welcome Back' : 'Join Nyxara',
          style: AppTextStyles.heroTitle.copyWith(fontSize: 36),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppDimensions.paddingS),

        Text(
          wantsToLogin
              ? 'Secure your digital assets with AI-powered protection'
              : 'Start protecting your data with advanced AI security',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAuthForm(AuthState state) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _shakeAnimation.value * 10 * (1 - _shakeAnimation.value),
            0,
          ),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingXL),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(
                AppDimensions.cardBorderRadius,
              ),
              border: Border.all(color: AppColors.borderColor, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: AppDimensions.shadowBlur,
                  offset: const Offset(0, 8),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Email field
                _buildEmailField(),

                const SizedBox(height: AppDimensions.paddingL),

                // Password field
                _buildPasswordField(),

                const SizedBox(height: AppDimensions.paddingXL),

                // Submit button
                _buildSubmitButton(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppDimensions.buttonBorderRadius,
            ),
            border: Border.all(
              color:
                  _isEmailValid ? AppColors.borderColor : AppColors.errorColor,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Enter your email',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color:
                    _isEmailValid
                        ? AppColors.textSecondary
                        : AppColors.errorColor,
                size: AppDimensions.iconM,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(AppDimensions.paddingM),
            ),
            onChanged: (value) {
              if (!_isEmailValid && value.contains('@')) {
                setState(() {
                  _isEmailValid = true;
                });
              }
            },
          ),
        ),
        if (!_isEmailValid)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.paddingS),
            child: Text(
              'Please enter a valid email address',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.errorColor,
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
          'Password',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppDimensions.buttonBorderRadius,
            ),
            border: Border.all(
              color:
                  _isPasswordValid
                      ? AppColors.borderColor
                      : AppColors.errorColor,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color:
                    _isPasswordValid
                        ? AppColors.textSecondary
                        : AppColors.errorColor,
                size: AppDimensions.iconM,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.textSecondary,
                  size: AppDimensions.iconM,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(AppDimensions.paddingM),
            ),
            onChanged: (value) {
              if (!_isPasswordValid && value.length >= 6) {
                setState(() {
                  _isPasswordValid = true;
                });
              }
            },
          ),
        ),
        if (!_isPasswordValid)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.paddingS),
            child: Text(
              'Password must be at least 6 characters',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.errorColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSubmitButton(AuthState state) {
    return ElevatedButton(
      onPressed: () {
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();

        if (email.isEmpty || password.isEmpty) {
          _validateInputs();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please fill in all fields'),
              backgroundColor: AppColors.errorColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
          );
          return;
        }

        _validateInputs();

        if (_isEmailValid && _isPasswordValid) {
          if (wantsToLogin) {
            context.read<AuthBloc>().add(
              LoginRequested(email: email, password: password),
            );
          } else {
            //otp validation
            context.read<AuthBloc>().add(SendOTPevent(email: email));
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 8,
        shadowColor: AppColors.primary.withValues(alpha: 0.3),
        minimumSize: const Size(
          double.infinity,
          AppDimensions.buttonHeightLarge,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            wantsToLogin ? Icons.login : Icons.person_add,
            size: AppDimensions.iconM,
          ),
          const SizedBox(width: AppDimensions.paddingS),
          Text(
            wantsToLogin ? 'Sign In' : 'Create Account',
            style: AppTextStyles.buttonLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchModeButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          wantsToLogin = !wantsToLogin;
          _isEmailValid = true;
          _isPasswordValid = true;
        });
      },
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
          vertical: AppDimensions.paddingM,
        ),
      ),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          children: [
            TextSpan(
              text:
                  wantsToLogin
                      ? "Don't have an account? "
                      : "Already have an account? ",
            ),
            TextSpan(
              text: wantsToLogin ? 'Sign Up' : 'Sign In',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackToHome() {
    return TextButton.icon(
      onPressed: () => context.go('/'),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
          vertical: AppDimensions.paddingM,
        ),
      ),
      icon: Icon(Icons.arrow_back, size: AppDimensions.iconS),
      label: Text('Back to Home', style: AppTextStyles.bodyMedium),
    );
  }
}
