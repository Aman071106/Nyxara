import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nyxara/core/router/routes_consts.dart';
import 'package:nyxara/core/theme/app_colors.dart';
import 'package:nyxara/core/theme/app_dimensions.dart';
import 'package:nyxara/core/theme/app_text_styles.dart';
import 'package:nyxara/domain/entities/breach_analytics_entity.dart';
import 'package:nyxara/presentation/auth/bloc/auth_bloc.dart';
import 'package:nyxara/presentation/common/navbar.dart';
import 'package:nyxara/presentation/dashboard/bloc/breach_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});
  @override
  createState() => _DashBoardScreen();
}

class _DashBoardScreen extends State<DashBoardScreen>
    with TickerProviderStateMixin {
  List<MapEntry<String, int>> Breachdata = [];
  List<MapEntry<String, int>> BreachCateogrydata = [];

  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is! Authenticated) {
        context.goNamed(NyxaraRoutes.loginPageRoute);
      } else {
        context.read<BreachBloc>().add(CheckBreach(email: authState.email));
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NyxaraNavbar(title: "Dashboard"),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: BlocConsumer<BreachBloc, BreachState>(
          builder: (context, state) {
            if (state is NotBreached) {
              return _buildSafeState();
            }
            if (state is CheckingBreach) {
              return _buildLoadingState("Scanning for breaches...");
            } else if (state is AnalyticsFetchedError) {
              return _buildErrorState();
            } else if (state is CheckingAnalytics) {
              return _buildLoadingState("Analyzing threat data...");
            } else if (state is AnalyticsFetched) {
              return _buildBreachedState(state);
            }
            return _buildUnknownState();
          },
          listener: (context, state) {
            if (state is Breached) {
              print("Breached and checking analytics...");
              context.read<BreachBloc>().add(
                CheckBreachAnalytics(email: state.email),
              );
            }
            if (state is AnalyticsFetched) {
              setState(() {
                Breachdata =
                    state.analyticsEntity.yearwiseDetails[0].entries.toList();
                BreachCateogrydata = List.generate(
                  state.adviceResponseEntity.pieLabels.length,
                  (index) => MapEntry(
                    state.adviceResponseEntity.pieLabels[index],
                    state.adviceResponseEntity.piePercentage[index],
                  ),
                );
              });
              try {
                log("here: ${state.analyticsEntity.riskLabel.name}");
              } catch (e) {
                log("Error in RiskLabel: $e");
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildSafeState() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Cyber grid background
          _buildCyberGrid(),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated shield icon
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.success.withValues(
                              alpha: _pulseAnimation.value,
                            ),
                            AppColors.success.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.security_rounded,
                        size: AppDimensions.icon3XL * 2,
                        color: AppColors.success,
                      ),
                    );
                  },
                ),

                SizedBox(height: AppDimensions.space3XL),

                // Safe status text
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Text(
                      "🛡️ SECURE STATUS",
                      style: AppTextStyles.glowText(
                        fontSize: 24,
                        color: AppColors.success,
                        glowColor: AppColors.success.withValues(
                          alpha: _glowAnimation.value,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: AppDimensions.spaceLG),

                Text(
                  "No security breaches detected",
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                SizedBox(height: AppDimensions.space4XL),

                // Security metrics cards
                _buildSecurityMetricsGrid(),

                SizedBox(height: AppDimensions.space3XL),

                // Refresh button
                _buildCyberButton("SCAN AGAIN", Icons.refresh, () {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is Authenticated) {
                    context.read<BreachBloc>().add(
                      CheckBreach(email: authState.email),
                    );
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(String message) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Cyber grid background
          _buildCyberGrid(),

          // Loading content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated loading indicator
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(
                            alpha: _glowAnimation.value,
                          ),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(
                              alpha: _glowAnimation.value * 0.5,
                            ),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        strokeWidth: 3,
                      ),
                    );
                  },
                ),

                SizedBox(height: AppDimensions.space3XL),

                Text(
                  message,
                  style: AppTextStyles.cyberTitle,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppDimensions.spaceLG),

                Text(
                  "Please wait while we analyze your digital footprint...",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _buildCyberGrid(),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.error.withValues(alpha: 0.3),
                        AppColors.error.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    size: AppDimensions.icon3XL * 2,
                    color: AppColors.error,
                  ),
                ),

                SizedBox(height: AppDimensions.space3XL),

                Text(
                  "⚠️ BREACH DETECTED",
                  style: AppTextStyles.glowText(
                    fontSize: 24,
                    color: AppColors.error,
                    glowColor: AppColors.error,
                  ),
                ),

                SizedBox(height: AppDimensions.spaceLG),

                Text(
                  "Error fetching detailed analytics",
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                SizedBox(height: AppDimensions.space3XL),

                _buildCyberButton("RETRY SCAN", Icons.refresh, () {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is Authenticated) {
                    context.read<BreachBloc>().add(
                      CheckBreach(email: authState.email),
                    );
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnknownState() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _buildCyberGrid(),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.help_outline_rounded,
                  size: AppDimensions.icon3XL * 2,
                  color: AppColors.textSecondary,
                ),

                SizedBox(height: AppDimensions.space3XL),

                Text("Unknown Status", style: AppTextStyles.headlineSmall),

                SizedBox(height: AppDimensions.spaceLG),

                Text(
                  "Unable to determine security status",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                SizedBox(height: AppDimensions.space3XL),

                _buildCyberButton("SCAN NOW", Icons.search, () {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is Authenticated) {
                    context.read<BreachBloc>().add(
                      CheckBreach(email: authState.email),
                    );
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreachedState(AnalyticsFetched state) {
    final entity = state.analyticsEntity;

    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          _buildCyberGrid(),

          SingleChildScrollView(
            padding: EdgeInsets.all(AppDimensions.spaceLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Threat alert header
                _buildThreatAlertCard(entity),

                SizedBox(height: AppDimensions.space2XL),

                // Charts section
                _buildChartsSection(state),

                SizedBox(height: AppDimensions.space2XL),

                // Risk metrics
                _buildRiskMetrics(entity),

                SizedBox(height: AppDimensions.space2XL),

                // Exposed categories
                _buildExposedCategories(entity),

                SizedBox(height: AppDimensions.space2XL),

                // Year-wise details
                _buildYearWiseDetails(entity),

                SizedBox(height: AppDimensions.space2XL),

                // Compromised websites
                _buildCompromisedWebsites(entity),

                SizedBox(height: AppDimensions.space2XL),

                // Security advice
                _buildSecurityAdvice(state.adviceResponseEntity),

                SizedBox(height: AppDimensions.space2XL),

                // Action buttons
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCyberGrid() {
    return CustomPaint(size: Size.infinite, painter: CyberGridPainter());
  }

  Widget _buildSecurityMetricsGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.space2XL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMetricCard("SCANNED", "100%", Icons.search, AppColors.primary),
          _buildMetricCard(
            "SECURE",
            "✓",
            Icons.verified_user,
            AppColors.success,
          ),
          _buildMetricCard("THREATS", "0", Icons.shield, AppColors.accentGreen),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCyber),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: AppDimensions.iconLG),
          SizedBox(height: AppDimensions.spaceXS),
          Text(value, style: AppTextStyles.titleSmall.copyWith(color: color)),
          Text(title, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }

  Widget _buildThreatAlertCard(AnalyticsEntity entity) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.spaceLG),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.error.withValues(alpha: 0.1),
            AppColors.cardBackground,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppDimensions.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusCyber,
                  ),
                ),
                child: Icon(
                  Icons.warning_rounded,
                  color: Colors.white,
                  size: AppDimensions.iconLG,
                ),
              ),
              SizedBox(width: AppDimensions.spaceLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "🚨 SECURITY BREACH DETECTED",
                      style: AppTextStyles.cyberTitle.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                    Text(
                      "Your data has been compromised",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.spaceLG),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRiskBadge("Risk Level", entity.riskLabel.name),
              _buildRiskBadge("Risk Score", entity.riskScore.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskBadge(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLG,
        vertical: AppDimensions.spaceSM,
      ),
      decoration: BoxDecoration(
        color: AppColors.containerBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCyber),
        border: Border.all(color: AppColors.borderLine),
      ),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.labelSmall),
          SizedBox(height: AppDimensions.spaceXS),
          Text(
            value,
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.getRiskColor(value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection(AnalyticsFetched state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("📊 THREAT ANALYTICS", style: AppTextStyles.cyberSubtitle),

        SizedBox(height: AppDimensions.spaceLG),

        // Yearly breach chart
        Container(
          height: AppDimensions.chartHeight,
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            border: Border.all(color: AppColors.borderLine),
          ),
          child: SfCartesianChart(
            backgroundColor: Colors.transparent,
            primaryXAxis: CategoryAxis(
              labelStyle: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
              axisLine: AxisLine(color: AppColors.borderLine),
              majorGridLines: MajorGridLines(color: AppColors.gridLine),
            ),
            primaryYAxis: NumericAxis(
              labelStyle: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
              axisLine: AxisLine(color: AppColors.borderLine),
              majorGridLines: MajorGridLines(color: AppColors.gridLine),
            ),
            title: ChartTitle(
              text: 'Yearly Breach Analysis',
              textStyle: AppTextStyles.titleMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            legend: Legend(
              isVisible: true,
              textStyle: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<MapEntry<String, int>, String>>[
              LineSeries<MapEntry<String, int>, String>(
                dataSource: Breachdata,
                xValueMapper: (entry, _) => entry.key,
                yValueMapper: (entry, _) => entry.value,
                name: 'Breaches',
                color: AppColors.error,
                width: 3,
                markerSettings: MarkerSettings(
                  isVisible: true,
                  color: AppColors.error,
                  borderColor: AppColors.background,
                  borderWidth: 2,
                ),
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  textStyle: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: AppDimensions.spaceLG),

        // Category pyramid chart
        Container(
          height: AppDimensions.chartHeight,
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            border: Border.all(color: AppColors.borderLine),
          ),
          child: SfPyramidChart(
            backgroundColor: Colors.transparent,
            title: ChartTitle(
              text: 'Category Analysis',
              textStyle: AppTextStyles.titleMedium.copyWith(
                color: AppColors.secondary,
              ),
            ),
            legend: Legend(
              isVisible: true,
              textStyle: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: PyramidSeries<MapEntry<String, int>, String>(
              dataSource: BreachCateogrydata,
              xValueMapper: (entry, _) => entry.key,
              yValueMapper: (entry, _) => entry.value,
              pointColorMapper:
                  (entry, index) =>
                      AppColors.getChartColorScheme(
                        BreachCateogrydata.length,
                      )[index],
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRiskMetrics(AnalyticsEntity entity) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spaceLG),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(color: AppColors.borderLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🎯 RISK ASSESSMENT", style: AppTextStyles.cyberSubtitle),

          SizedBox(height: AppDimensions.spaceLG),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  "Risk Level",
                  entity.riskLabel.name,
                  Icons.security,
                  AppColors.getRiskColor(entity.riskLabel.name),
                ),
              ),
              SizedBox(width: AppDimensions.spaceLG),
              Expanded(
                child: _buildStatCard(
                  "Risk Score",
                  entity.riskScore.toString(),
                  Icons.speed,
                  AppColors.warning,
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.spaceLG),

          _buildStatCard(
            "Exposed Categories",
            "${entity.exposedCategoryCount ?? 0}",
            Icons.category,
            AppColors.error,
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: EdgeInsets.all(AppDimensions.spaceLG),
      decoration: BoxDecoration(
        color: AppColors.containerBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCyber),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppDimensions.iconLG),
          SizedBox(height: AppDimensions.spaceSM),
          Text(value, style: AppTextStyles.titleLarge.copyWith(color: color)),
          Text(
            title,
            style: AppTextStyles.labelMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExposedCategories(dynamic entity) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spaceLG),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(color: AppColors.borderLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "📁 EXPOSED DATA CATEGORIES",
            style: AppTextStyles.cyberSubtitle,
          ),

          SizedBox(height: AppDimensions.spaceLG),

          ...entity.xposedData.map<Widget>(
            (category) => Container(
              margin: EdgeInsets.only(bottom: AppDimensions.spaceMD),
              padding: EdgeInsets.all(AppDimensions.spaceLG),
              decoration: BoxDecoration(
                color: AppColors.containerBackground,
                borderRadius: BorderRadius.circular(AppDimensions.radiusCyber),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...category.children.map<Widget>(
                    (child) => Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppDimensions.spaceXS,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.security_update_warning,
                            color: AppColors.error,
                            size: AppDimensions.iconSM,
                          ),
                          SizedBox(width: AppDimensions.spaceSM),
                          Expanded(
                            child: Text(child, style: AppTextStyles.bodyMedium),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearWiseDetails(dynamic entity) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spaceLG),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(color: AppColors.borderLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("📅 BREACH TIMELINE", style: AppTextStyles.cyberSubtitle),

          SizedBox(height: AppDimensions.spaceLG),

          ...entity.yearwiseDetails[0].entries.map<Widget>(
            (entry) => Container(
              margin: EdgeInsets.only(bottom: AppDimensions.spaceSM),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceLG,
                  vertical: AppDimensions.spaceSM,
                ),
                tileColor: AppColors.containerBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusCyber,
                  ),
                  side: BorderSide(color: AppColors.borderLine),
                ),
                leading: Icon(
                  Icons.calendar_today,
                  color: AppColors.warning,
                  size: AppDimensions.iconMD,
                ),
                title: Text(entry.key, style: AppTextStyles.titleMedium),
                trailing: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceMD,
                    vertical: AppDimensions.spaceXS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusCyber,
                    ),
                  ),
                  child: Text(
                    entry.value.toString(),
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.error,
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

  Widget _buildCompromisedWebsites(dynamic entity) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spaceLG),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(color: AppColors.borderLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🌐 COMPROMISED WEBSITES", style: AppTextStyles.cyberSubtitle),

          SizedBox(height: AppDimensions.spaceLG),

          ...entity.websites.map<Widget>(
            (site) => Container(
              margin: EdgeInsets.only(bottom: AppDimensions.spaceSM),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceLG,
                  vertical: AppDimensions.spaceSM,
                ),
                tileColor: AppColors.containerBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusCyber,
                  ),
                  side: BorderSide(
                    color: AppColors.error.withValues(alpha: 0.3),
                  ),
                ),
                leading: Icon(
                  Icons.language,
                  color: AppColors.error,
                  size: AppDimensions.iconMD,
                ),
                title: Text(site, style: AppTextStyles.bodyMedium),
                trailing: Icon(
                  Icons.warning_rounded,
                  color: AppColors.error,
                  size: AppDimensions.iconSM,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityAdvice(dynamic adviceEntity) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spaceLG),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(color: AppColors.borderLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "💡 SECURITY RECOMMENDATIONS",
            style: AppTextStyles.cyberSubtitle,
          ),

          SizedBox(height: AppDimensions.spaceLG),

          ...adviceEntity.advices.map<Widget>(
            (advice) => Container(
              margin: EdgeInsets.only(bottom: AppDimensions.spaceMD),
              padding: EdgeInsets.all(AppDimensions.spaceLG),
              decoration: BoxDecoration(
                color: AppColors.containerBackground,
                borderRadius: BorderRadius.circular(AppDimensions.radiusCyber),
                border: Border.all(
                  color: AppColors.info.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.info,
                    size: AppDimensions.iconMD,
                  ),
                  SizedBox(width: AppDimensions.spaceLG),
                  Expanded(
                    child: Text(advice, style: AppTextStyles.bodyMedium),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: AppDimensions.spaceLG),

          Text(
            "📊 BREACH DISTRIBUTION",
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.secondary,
            ),
          ),

          SizedBox(height: AppDimensions.spaceLG),

          Wrap(
            spacing: AppDimensions.spaceMD,
            runSpacing: AppDimensions.spaceSM,
            children: List.generate(
              adviceEntity.pieLabels.length,
              (index) => Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceLG,
                  vertical: AppDimensions.spaceSM,
                ),
                decoration: BoxDecoration(
                  color: AppColors.getChartColorScheme(
                    adviceEntity.pieLabels.length,
                  )[index].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  border: Border.all(
                    color:
                        AppColors.getChartColorScheme(
                          adviceEntity.pieLabels.length,
                        )[index],
                  ),
                ),
                child: Text(
                  "${adviceEntity.pieLabels[index]}: ${adviceEntity.piePercentage[index]}%",
                  style: AppTextStyles.labelMedium.copyWith(
                    color:
                        AppColors.getChartColorScheme(
                          adviceEntity.pieLabels.length,
                        )[index],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCyberButton("RESCAN", Icons.refresh, () {
          final authState = context.read<AuthBloc>().state;
          if (authState is Authenticated) {
            context.read<BreachBloc>().add(CheckBreach(email: authState.email));
          }
        }),
        
      ],
    );
  }

  Widget _buildCyberButton(String text, IconData icon, VoidCallback onPressed) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusCyber),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(
                  alpha: _glowAnimation.value * 0.5,
                ),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, color: AppColors.textPrimary),
            label: Text(text, style: AppTextStyles.buttonMedium),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimary,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.space2XL,
                vertical: AppDimensions.spaceLG,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusCyber),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CyberGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.gridLine
          ..strokeWidth = AppDimensions.cyberLineWidth;

    const double gridSize = AppDimensions.cyberGridSize;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
