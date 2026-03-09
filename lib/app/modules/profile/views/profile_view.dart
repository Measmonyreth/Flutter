import 'package:ecommerce_flutter/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:ecommerce_flutter/app/modules/home/controllers/home_controller.dart';
import 'package:ecommerce_flutter/app/modules/product-detail/views/product_detail_view.dart';
import 'package:ecommerce_flutter/app/modules/services/storage_service.dart';
import 'package:ecommerce_flutter/app/modules/widget/saveProductCart.dart';
import 'package:ecommerce_flutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'package:ecommerce_flutter/app/modules/theme/theme_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});
  final controller = Get.find<ProfileController>();
  final themeController = Get.find<ThemeController>();
  final token = StorageService.read(key: 'token');

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = Theme.of(context);

      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              )
            : _buildBody(context, theme),
      );
    });
  }

  Widget _buildBody(BuildContext context, ThemeData theme) {
    final user = controller.userProfile.value.user;
    final isDark = themeController.isDarkMode.value;

    return token == null || token.toString().isEmpty
        ? Center(
            child: ElevatedButton(
              onPressed: () => Get.toNamed(Routes.LOGIN),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Login to view profile'),
            ),
          )
        : CustomScrollView(
            slivers: [
              // ── Sliver App Bar ──────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: isDark
                    ? const Color(0xFF1A1A2E)
                    : theme.colorScheme.primary,
                actions: [
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: isDark
                          ? Colors.white
                          : theme.colorScheme.onPrimary,
                    ),
                    onSelected: (value) => _handleMenu(value),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit Profile'),
                        onTap: () {
                          Get.toNamed(
                            Routes.EDIT_PROFILE,
                            arguments: controller,
                          );
                          // Navigator.push(
                        },
                      ),
                      const PopupMenuItem(
                        value: 'logout',
                        child: Text('Log Out'),
                      ),
                    ],
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeader(theme, user, isDark),
                ),
              ),

              // ── Content ─────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info Card
                      _sectionTitle('Account Information', theme),
                      const SizedBox(height: 8),
                      _buildInfoCard(user, theme, isDark),

                      const SizedBox(height: 24),

                      // Activity / Stats
                      _sectionTitle('Activity', theme),
                      const SizedBox(height: 8),
                      _buildStatsRow(theme, isDark),

                      const SizedBox(height: 24),

                      // Appearance
                      _sectionTitle('Appearance', theme),
                      const SizedBox(height: 8),
                      _buildAppearanceCard(theme, isDark),

                      const SizedBox(height: 24),

                      // About
                      _sectionTitle('About', theme),
                      const SizedBox(height: 8),
                      _buildAboutCard(theme, isDark),

                      const SizedBox(height: 24),

                      // Danger zone
                      _buildLogoutButton(theme),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  // ── Header ─────────────────────────────────────────────────────────
  Widget _buildHeader(ThemeData theme, dynamic user, bool isDark) {
    final bgColor = isDark
        ? const Color(0xFF1A1A2E)
        : theme.colorScheme.primary;
    final initials = _getInitials(user?.name ?? 'U');

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
              : [theme.colorScheme.primary, theme.colorScheme.secondary],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            // Avatar
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                  child: user?.avatar != null
                      ? ClipOval(
                          child: Image.network(
                            user!.avatar!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                ),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              user?.name ?? '—',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              user?.email ?? '—',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Info Card ──────────────────────────────────────────────────────
  Widget _buildInfoCard(dynamic user, ThemeData theme, bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;

    final items = [
      _InfoItem(Icons.badge_outlined, 'User ID', '${user?.id ?? '—'}'),
      _InfoItem(Icons.person_outline, 'Username', user?.name ?? '—'),
      _InfoItem(Icons.email_outlined, 'Email', user?.email ?? '—'),
      _InfoItem(
        user?.emailVerifiedAt != null
            ? Icons.verified_outlined
            : Icons.pending_outlined,
        'Email Verified',
        user?.emailVerifiedAt != null ? 'Verified' : 'Not Verified',
        valueColor: user?.emailVerifiedAt != null
            ? const Color(0xFF10B981)
            : const Color(0xFFF59E0B),
      ),
      _InfoItem(
        Icons.calendar_today_outlined,
        'Member Since',
        _formatDate(user?.createdAt),
      ),
      _InfoItem(
        Icons.update_outlined,
        'Last Updated',
        _formatDate(user?.updatedAt),
      ),
    ];

    return _card(
      cardColor,
      isDark,
      Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      size: 20,
                      color: theme.colorScheme.primary.withOpacity(0.8),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
                    Text(
                      item.value,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color:
                            item.valueColor ?? theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
              if (i < items.length - 1)
                Divider(
                  height: 1,
                  indent: 48,
                  color: isDark
                      ? Colors.white10
                      : Colors.black.withOpacity(0.06),
                ),
            ],
          );
        }),
      ),
    );
  }

  // ── Stats Row ──────────────────────────────────────────────────────
  Widget _buildStatsRow(ThemeData theme, bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;

    final stats = [
      _StatItem('Posts', '24', Icons.grid_view_rounded),
      _StatItem('Following', '138', Icons.people_outline),
      _StatItem('Followers', '512', Icons.favorite_border),
    ];

    return Row(
      children: stats.map((s) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: stats.indexOf(s) == 0 ? 0 : 6,
              right: stats.indexOf(s) == stats.length - 1 ? 0 : 6,
            ),
            child: _card(
              cardColor,
              isDark,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Icon(s.icon, color: theme.colorScheme.primary, size: 22),
                    const SizedBox(height: 6),
                    Text(
                      s.value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s.label,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Appearance Card ────────────────────────────────────────────────
  Widget _buildAppearanceCard(ThemeData theme, bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;

    return _card(
      cardColor,
      isDark,
      Column(
        children: [
          Obx(
            () => SwitchListTile(
              secondary: Icon(
                themeController.isDarkMode.value
                    ? Icons.dark_mode
                    : Icons.light_mode,
                color: theme.colorScheme.primary,
              ),
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                themeController.isDarkMode.value
                    ? 'Using dark theme'
                    : 'Using light theme',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              value: themeController.isDarkMode.value,
              onChanged: (_) => themeController.toggleTheme(),
              activeColor: theme.colorScheme.primary,
            ),
          ),
          Divider(
            height: 1,
            indent: 16,
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.06),
          ),
          ListTile(
            leading: Icon(
              Icons.notifications_outlined,
              color: theme.colorScheme.primary,
            ),
            title: const Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Manage alerts',
              style: TextStyle(
                fontSize: 12,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.snackbar('Coming soon', 'Notification settings'),
          ),
          Divider(
            height: 1,
            indent: 16,
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.06),
          ),
          ListTile(
            leading: Icon(
              Icons.language_outlined,
              color: theme.colorScheme.primary,
            ),
            title: const Text(
              'Language',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'English (US)',
              style: TextStyle(
                fontSize: 12,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.snackbar('Coming soon', 'Language settings'),
          ),
          ListTile(
            leading: Icon(
              Icons.favorite_outline,
              color: theme.colorScheme.primary,
            ),
            title: const Text(
              'Saved',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'products you saved',
              style: TextStyle(
                fontSize: 12,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.to(const SavedProductsView()),
          ),
        ],
      ),
    );
  }

  // ── About Card ─────────────────────────────────────────────────────
  Widget _buildAboutCard(ThemeData theme, bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;

    final items = [
      _AboutItem(Icons.info_outline, 'App Version', '1.0.0'),
      _AboutItem(Icons.description_outlined, 'Terms of Service', null),
      _AboutItem(Icons.privacy_tip_outlined, 'Privacy Policy', null),
      _AboutItem(Icons.star_outline, 'Rate the App', null),
      _AboutItem(Icons.help_outline, 'Help & Support', null),
    ];

    return _card(
      cardColor,
      isDark,
      Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          return Column(
            children: [
              ListTile(
                leading: Icon(item.icon, color: theme.colorScheme.primary),
                title: Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: item.trailing != null
                    ? Text(
                        item.trailing!,
                        style: TextStyle(
                          color: theme.textTheme.bodySmall?.color,
                          fontSize: 13,
                        ),
                      )
                    : const Icon(Icons.chevron_right, size: 18),
                onTap: () => Get.snackbar(item.title, 'Coming soon'),
              ),
              if (i < items.length - 1)
                Divider(
                  height: 1,
                  indent: 16,
                  color: isDark
                      ? Colors.white10
                      : Colors.black.withOpacity(0.06),
                ),
            ],
          );
        }),
      ),
    );
  }

  // ── Logout Button ──────────────────────────────────────────────────
  Widget _buildLogoutButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFEF4444),
          side: const BorderSide(color: Color(0xFFEF4444)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.logout),
        label: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        onPressed: () => _confirmLogout(),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────
  Widget _sectionTitle(String title, ThemeData theme) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _card(Color color, bool isDark, Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: child),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'[\s_]+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '—';
    try {
      final dt = DateTime.parse(dateStr);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return dateStr;
    }
  }

  void _handleMenu(String value) {
    if (value == 'edit') {
      Get.snackbar('Edit Profile', 'Coming soon');
    } else if (value == 'logout') {
      _confirmLogout();
    }
  }

  void _confirmLogout() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.logout();
              // Get.back();
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Themes ─────────────────────────────────────────────────────────
}

// ── Data classes ───────────────────────────────────────────────────────
class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  _InfoItem(this.icon, this.label, this.value, {this.valueColor});
}

class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  _StatItem(this.label, this.value, this.icon);
}

class _AboutItem {
  final IconData icon;
  final String title;
  final String? trailing;
  _AboutItem(this.icon, this.title, this.trailing);
}
