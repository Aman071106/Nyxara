import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nyxara/core/router/routes_consts.dart';
import 'package:nyxara/core/theme/app_colors.dart';
import 'package:nyxara/core/theme/app_dimensions.dart';
import 'package:nyxara/core/theme/app_text_styles.dart';

class NyxaraNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final bool showLogo;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final bool centerTitle;
  final Widget? customTitle;
  final bool showSearch;
  final VoidCallback? onSearchPressed;
  final bool showNotifications;
  final int notificationCount;

  const NyxaraNavbar({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.actions,
    this.showLogo = true,
    this.onBackPressed,
    this.backgroundColor,
    this.centerTitle = true,
    this.customTitle,
    this.showSearch = false,
    this.onSearchPressed,
    this.showNotifications = true,
    this.notificationCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: AppDimensions.shadowBlur,
            offset: const Offset(0, 2),
            spreadRadius: -2,
          ),
        ],
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor, width: 0.5),
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: centerTitle,
        leading:
            showBackButton
                ? _buildBackButton(context)
                : showLogo
                ? _buildLogo()
                : null,
        title: customTitle ?? _buildTitle(),
        actions: actions ?? _buildDefaultActions(context),
        titleSpacing: showLogo ? 0 : NavigationToolbar.kMiddleSpacing,
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingS),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
      ),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.primary,
          size: AppDimensions.iconM,
        ),
        onPressed: onBackPressed ?? () => context.pop(),
        tooltip: 'Back',
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingS),
      padding: const EdgeInsets.all(AppDimensions.paddingS),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryVariant],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: AppDimensions.paddingS,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.security_outlined,
        color: AppColors.textOnPrimary,
        size: AppDimensions.iconM,
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLogo && !showBackButton) ...[
          const SizedBox(width: AppDimensions.paddingS),
          Text(
            'Nyxara',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          if (title.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingS,
              ),
              width: 2,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ],
        if (title.isNotEmpty)
          Flexible(
            child: Text(
              title,
              style: AppTextStyles.h3.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  List<Widget> _buildDefaultActions(BuildContext context) {
    List<Widget> actionWidgets = [];

    // Search button
    if (showSearch) {
      actionWidgets.add(
        Container(
          margin: const EdgeInsets.only(right: AppDimensions.paddingS),
          decoration: BoxDecoration(
            color: AppColors.accentTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: AppColors.accentTeal.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: Icon(
              Icons.search_outlined,
              color: AppColors.accentTeal,
              size: AppDimensions.iconM,
            ),
            onPressed: onSearchPressed ?? () => _showSearchDialog(context),
            tooltip: 'Search',
          ),
        ),
      );
    }

    // Home button
    actionWidgets.add(
      Container(
        margin: const EdgeInsets.only(right: AppDimensions.paddingS),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: Icon(
            Icons.home_outlined,
            color: AppColors.primary,
            size: AppDimensions.iconM,
          ),
          onPressed: () => context.goNamed(NyxaraRoutes.homePageRoute),
          tooltip: 'Home',
        ),
      ),
    );

    // Analytics button
    actionWidgets.add(
      Container(
        margin: const EdgeInsets.only(right: AppDimensions.paddingS),
        decoration: BoxDecoration(
          color: AppColors.accentBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: AppColors.accentBlue.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: Icon(
            Icons.analytics_outlined,
            color: AppColors.accentBlue,
            size: AppDimensions.iconM,
          ),
          onPressed: () => context.goNamed(NyxaraRoutes.dashboardRoute),
          tooltip: 'Analytics',
        ),
      ),
    );

    // Vault button
    actionWidgets.add(
      Container(
        margin: const EdgeInsets.only(right: AppDimensions.paddingS),
        decoration: BoxDecoration(
          color: AppColors.accentOrange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: AppColors.accentOrange.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: Icon(
            Icons.lock_outline,
            color: AppColors.accentOrange,
            size: AppDimensions.iconM,
          ),
          onPressed: () => context.goNamed(NyxaraRoutes.vaultRoute),
          tooltip: 'Vault',
        ),
      ),
    );

    // Profile/Menu button
    actionWidgets.add(
      Container(
        margin: const EdgeInsets.only(right: AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: AppColors.accentPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: AppColors.accentPurple.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: Icon(
            Icons.account_circle_outlined,
            color: AppColors.accentPurple,
            size: AppDimensions.iconM,
          ),
          onPressed: () => context.goNamed(NyxaraRoutes.profileRoute),
          tooltip: 'Profile',
        ),
      ),
    );

    return actionWidgets;
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            title: Text(
              'Search',
              style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
            ),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search threats, logs, settings...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.accentTeal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  borderSide: BorderSide(color: AppColors.accentTeal, width: 2),
                ),
              ),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                // Handle search
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);
}
