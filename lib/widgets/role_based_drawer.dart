import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../Login.dart';
import '../constants/Constants.dart';
import '../screens/ComingSoon.dart';
import '../screens/PolicyInformation.dart';
import '../screens/Reports/ClaimsReport.dart';
import '../screens/Reports/CommsReport.dart';
import '../screens/Reports/Executive/CustomersReport.dart';
import '../screens/Reports/Executive/ExecutiveCollectionsReport.dart';
import '../screens/Reports/Executive/ExecutiveCommisionsReport.dart';
import '../screens/Reports/Executive/ExecutiveSalesReport.dart';
import '../screens/Reports/MaintenanceReport.dart';
import '../screens/Reports/MarketingReport.dart';
import '../screens/ReprintsAndCancellations.dart';
import '../screens/Valuetainment/Valuetainment.dart';
import '../services/Sales Agent/MyChats.dart';

// Define drawer items model
class DrawerItem {
  final String title;
  final String iconPath;
  final VoidCallback onTap;
  final bool requiresPassword;
  final String module;

  DrawerItem({
    required this.title,
    required this.iconPath,
    required this.onTap,
    this.requiresPassword = false,
    required this.module,
  });
}

class RoleBasedDrawer {
  static Widget buildDrawer(
    BuildContext context, {
    required String userRole,
    required List<String> userModules,
    required VoidCallback onPasswordRequired,
    required VoidCallback onCommissionPasswordRequired,
  }) {
    // Get filtered drawer items based on role and modules
    List<DrawerItem> drawerItems = _getDrawerItemsForRole(
      userRole,
      userModules,
      context,
      onPasswordRequired,
      onCommissionPasswordRequired,
    );

    return Drawer(
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              // User Profile Header
              _buildUserProfileHeader(context),

              // Dynamic drawer items based on role
              ...drawerItems.map((item) => _buildDrawerListItem(context, item)),

              // Sign Out Button
              _buildSignOutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildUserProfileHeader(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.height,
      color: Colors.grey.withOpacity(0.03),
      child: Container(
        width: MediaQuery.of(context).size.height,
        color: Colors.grey.withOpacity(0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 55),
            Padding(
              padding: const EdgeInsets.only(top: 55.0, bottom: 8),
              child: Container(
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: Constants.ctaColorLight,
                  child: Center(
                    child: Icon(
                      Iconsax.user,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              Constants.myDisplayname,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 18,
                  fontFamily: "TradeGothic",
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16),
              child: Text(
                Constants.myEmail,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontFamily: "TradeGothic",
                    fontSize: 15.5,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDrawerListItem(BuildContext context, DrawerItem item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: ListTile(
            title: Text(
              item.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color(0xff121212),
              ),
            ),
            leading: Container(
              height: 25,
              width: 25,
              child: item.iconPath.endsWith('.svg')
                  ? SvgPicture.asset(
                      item.iconPath,
                      color: Color(0xcc121212),
                    )
                  : Icon(
                      _getIconFromString(item.iconPath),
                      color: Color(0xcc121212),
                    ),
            ),
            onTap: () {
              Navigator.of(context).pop(); // Close drawer first
              item.onTap();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 30),
          child: Container(
            height: 1,
            color: Color(0x33c2c5cc),
          ),
        ),
      ],
    );
  }

  static Widget _buildSignOutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          Constants.isLoggedIn = true;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        },
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: Constants.ctaColorLight,
            borderRadius: BorderRadius.circular(360),
          ),
          child: Center(
            child: Text(
              'Sign Out',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: "TradeGothic",
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static List<DrawerItem> _getDrawerItemsForRole(
    String userRole,
    List<String> userModules,
    BuildContext context,
    VoidCallback onPasswordRequired,
    VoidCallback onCommissionPasswordRequired,
  ) {
    // Define all possible drawer items
    Map<String, DrawerItem> allDrawerItems = {
      'sales': DrawerItem(
        title: 'Sales',
        iconPath: 'assets/icons/sales_logo.svg',
        module: 'sales',
        onTap: () => _navigateToPage(context, ExecutivesSalesReport()),
      ),
      'collections': DrawerItem(
        title: 'Collections',
        iconPath: 'assets/icons/collections_logo.svg',
        module: 'collections',
        onTap: () => _navigateToPage(context, ExecutiveCollectionsReport()),
      ),
      'payments': DrawerItem(
        title: 'Payments',
        iconPath: 'assets/icons/collections_logo.svg',
        module: 'payments',
        onTap: () => _navigateToPage(context,
            ExecutiveCollectionsReport()), // Using collections as placeholder
      ),
      'bordereaux': DrawerItem(
        title: 'Bordereaux',
        iconPath: 'assets/icons/collections_logo.svg',
        module: 'payments',
        onTap: () => _navigateToPage(context,
            ExecutiveCollectionsReport()), // Using collections as placeholder
      ),
      'maintenance': DrawerItem(
        title: 'Maintenance',
        iconPath: 'assets/icons/maintanence_report.svg',
        module: 'maintenance',
        onTap: () => _navigateToPage(context, MaintenanceReport()),
      ),
      'claims': DrawerItem(
        title: 'Claims',
        iconPath: 'assets/icons/claims_logo.svg',
        module: 'claims',
        onTap: () => _navigateToPage(context, ClaimsReport()),
      ),
      'reprints': DrawerItem(
        title: 'Reprints',
        iconPath: 'assets/icons/reprint_logo.svg',
        module: 'reprints',
        onTap: () => _navigateToPage(context, ReprintsCancellations()),
      ),
      'policy_search': DrawerItem(
        title: 'Pol. Search',
        iconPath: 'assets/icons/policy_search.svg',
        module: 'policy_search',
        onTap: () => _navigateToPage(context, PolicyInformation()),
      ),
      'fulfillment': DrawerItem(
        title: 'Comms',
        iconPath: 'assets/icons/commission_logo.svg',
        module: 'fulfillment',
        onTap: () => _navigateToPage(context, CommsReport()),
      ),
      'morale_index': DrawerItem(
        title: 'Morale Index',
        iconPath: 'assets/icons/people_matters.svg',
        module: 'morale_index',
        requiresPassword: true,
        onTap: onPasswordRequired,
      ),
      'attendance': DrawerItem(
        title: 'Attendance',
        iconPath: 'assets/icons/attendance.svg',
        module: 'attendance',
        onTap: () => _navigateToPage(context, ComingSoon()),
      ),
      'commission': DrawerItem(
        title: 'Commission',
        iconPath: 'assets/icons/commission_logo.svg',
        module: 'commission',
        requiresPassword: true,
        onTap: onCommissionPasswordRequired,
      ),
      'prospects': DrawerItem(
        title: 'Prospects',
        iconPath: 'assets/icons/prospects.svg',
        module: 'marketing',
        onTap: () => _navigateToPage(context, MarketingReport()),
      ),
      'customer_profile': DrawerItem(
        title: 'Cust. Profile',
        iconPath: 'assets/icons/customers.svg',
        module: 'customer_profile',
        onTap: () => _navigateToPage(context, CustomersReport()),
      ),
      'micro_learn': DrawerItem(
        title: 'Micro-Learn',
        iconPath: 'assets/icons/micro_l.svg',
        module: 'marketing',
        onTap: () => _navigateToPage(context, VaLuetainmenthome()),
      ),
      'my_chats': DrawerItem(
        title: 'My Chats',
        iconPath: 'assets/icons/my_chats.svg',
        module: 'attendance',
        onTap: () => _navigateToPage(context, myChats()),
      ),
    };

    // Role-based drawer configurations
    Map<String, List<String>> roleDrawerConfig = {
      'insurer': [
        'prospects',
        'sales',
        'bordereaux',
        'collections',
        'claims',
        'customer_profile',
        'fulfillment',
        'commission',
        'maintenance',
        'attendance',
        'policy_search',
        'reprints',
        'morale_index',
        'micro_learn',
      ],
      'executive': [
        'prospects',
        'sales',
        'payments',
        'collections',
        'claims',
        'customer_profile',
        'fulfillment',
        'commission',
        'maintenance',
        'attendance',
        'policy_search',
        'reprints',
        'morale_index',
        'micro_learn',
      ],
      'administrator': [
        'prospects',
        'sales',
        'payments',
        'collections',
        'claims',
        'customer_profile',
        'fulfillment',
        'commission',
        'maintenance',
        'attendance',
        'policy_search',
        'reprints',
        'morale_index',
        'micro_learn',
      ],
      'sales': [
        'sales',
        'collections',
        'commission',
        'my_chats',
        'micro_learn',
      ],
    };

    // Get drawer items for the specific role
    List<String> roleItems = roleDrawerConfig[userRole.toLowerCase()] ?? [];

    // Filter based on user modules and return DrawerItem objects
    return roleItems
        .where((itemKey) {
          DrawerItem? item = allDrawerItems[itemKey];
          return item != null && userModules.contains(item.module);
        })
        .map((itemKey) => allDrawerItems[itemKey]!)
        .toList();
  }

  static void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ).then((_) {
      Constants.pageLevel = 1;
    });
  }

  static IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'cart':
        return CupertinoIcons.cart;
      case 'person':
        return CupertinoIcons.person;
      case 'settings':
        return CupertinoIcons.settings;
      default:
        return Icons.circle;
    }
  }
}
