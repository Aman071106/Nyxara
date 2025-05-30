import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nyxara/core/router/routes_consts.dart';
import 'package:nyxara/core/theme/app_colors.dart';
import 'package:nyxara/core/theme/app_dimensions.dart';
import 'package:nyxara/core/theme/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Animated background gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.gradientStart.withValues(alpha: 0.1),
                  AppColors.gradientEnd.withValues(alpha: 0.05),
                ],
              ),
            ),
          ),

          // Floating geometric shapes
          _buildFloatingShapes(),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppDimensions.paddingXXL),

                        // Hero section
                        _buildHeroSection(),

                        const SizedBox(height: AppDimensions.paddingXXL),

                        // Security metrics dashboard
                        _buildSecurityMetrics(),

                        const SizedBox(height: AppDimensions.paddingXL),

                        // Feature cards
                        _buildFeatureGrid(),

                        const SizedBox(height: AppDimensions.paddingXXL),

                        // CTA section
                        _buildCtaSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingShapes() {
    return Stack(
      children: [
        Positioned(
          top: 100,
          right: -50,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accentBlue.withValues(alpha: 0.1),
                    border: Border.all(
                      color: AppColors.accentBlue.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 200,
          left: -30,
          child: Transform.rotate(
            angle: 0.5,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                color: AppColors.accentPurple.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppColors.accentPurple.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
          decoration: BoxDecoration(
            color: AppColors.accentBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            border: Border.all(
              color: AppColors.accentBlue.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.security,
                color: AppColors.accentBlue,
                size: AppDimensions.iconS,
              ),
              const SizedBox(width: AppDimensions.paddingXS),
              Text(
                'AI-Powered Security',
                style: AppTextStyles.captionBold.copyWith(
                  color: AppColors.accentBlue,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.paddingL),

        Text('Nyxara', style: AppTextStyles.heroTitle),

        const SizedBox(height: AppDimensions.paddingS),

        Text(
          'Predict. Prevent. Protect.',
          style: AppTextStyles.heroSubtitle.copyWith(
            color: AppColors.accentPurple,
          ),
        ),

        const SizedBox(height: AppDimensions.paddingM),

        Text(
          'Advanced AI algorithms analyze your digital footprint to predict and prevent data breaches before they happen.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityMetrics() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        border: Border.all(color: AppColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: AppDimensions.shadowBlur,
            offset: const Offset(0, 4),
            spreadRadius: -1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingS),
                decoration: BoxDecoration(
                  color: AppColors.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: AppColors.successColor,
                  size: AppDimensions.iconM,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Want a Security Status !!', style: AppTextStyles.h3),
                    Text(
                      'Real-time threat assessment',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: Text(
                  'SECURE',
                  style: AppTextStyles.captionBold.copyWith(
                    color: AppColors.successColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.paddingL),

          Row(
            children: [
              _buildMetricItem('99.9%', 'Uptime', AppColors.accentBlue),
              _buildMetricItem('0', 'Active Threats', AppColors.successColor),
              _buildMetricItem('24/7', 'Monitoring', AppColors.accentPurple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: AppTextStyles.metricValue.copyWith(color: color)),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Key Features', style: AppTextStyles.h2),
        const SizedBox(height: AppDimensions.paddingL),

        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.radar,
                title: 'Threat Detection',
                description: 'Advanced AI algorithms detect anomalies',
                color: AppColors.warningColor,
                delay: 0,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.shield_outlined,
                title: 'Real-time Protection',
                description: 'Continuous monitoring & alerts',
                color: AppColors.accentBlue,
                delay: 200,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.paddingM),

        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.analytics_outlined,
                title: 'Predictive Analytics',
                description: 'Forecast potential vulnerabilities',
                color: AppColors.accentPurple,
                delay: 400,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.auto_fix_high,
                title: 'Auto Response',
                description: 'Automated threat mitigation',
                color: AppColors.successColor,
                delay: 600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            height: 140,
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(
                AppDimensions.cardBorderRadius,
              ),
              border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.1),
                  blurRadius: AppDimensions.shadowBlur,
                  offset: const Offset(0, 4),
                  spreadRadius: -1,
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingS),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                    ),
                    child: Icon(icon, color: color, size: AppDimensions.iconM),
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  Text(
                    title,
                    style: AppTextStyles.h4,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.paddingXS),
                  Text(
                    description,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCtaSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryVariant],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: AppDimensions.shadowBlur * 2,
            offset: const Offset(0, 8),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Start Your Security Journey',
            style: AppTextStyles.h2.copyWith(color: AppColors.textOnPrimary),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.paddingM),

          Text(
            'Join thousands of organizations protecting their digital assets with Nyxara\'s advanced AI security platform.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textOnPrimary.withValues(alpha: 0.9),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.paddingL),

          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseAnimation.value - 0.9) * 0.1,
                child: ElevatedButton(
                  onPressed: () => context.go(NyxaraRoutes.loginPageRoute),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cardBackground,
                    foregroundColor: AppColors.primary,
                    elevation: 8,
                    shadowColor: AppColors.textOnPrimary.withValues(alpha: 0.3),
                    minimumSize: const Size(
                      double.infinity,
                      AppDimensions.buttonHeightLarge,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.buttonBorderRadius,
                      ),
                    ),
                  ),

                  child: GestureDetector(
                    onTap: () => context.goNamed(NyxaraRoutes.loginPageRoute),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Get Started Now',
                          style: AppTextStyles.buttonLarge,
                        ),
                        const SizedBox(width: AppDimensions.paddingS),
                        Icon(Icons.arrow_forward, size: AppDimensions.iconM),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
