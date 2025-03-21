import 'package:cater_admin_web/components/responsive_builder.dart';
import 'package:cater_admin_web/components/theme_color.dart';
import 'package:cater_admin_web/screen/create_user/create_user_screen.dart';
import 'package:cater_admin_web/screen/dashboard/dashboard_screen.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:collapsible_sidebar/collapsible_sidebar/collapsible_item.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  List<Widget> get screens {
    return [DashboardScreen(), CreateUserScreen()];
  }

  List<CollapsibleItem> get items {
    return [
      CollapsibleItem(
        text: 'Dashboard',
        //`iconImage` has priority over `icon` property
        icon: Icons.view_compact_sharp,
        onPressed: () => setState(() => selectedIndex = 0),
        isSelected: selectedIndex == 0,
      ),
      CollapsibleItem(
        text: 'Create User',
        //`iconImage` has priority over `icon` property
        icon: Icons.person_add_alt_1_rounded,
        onPressed: () => setState(() => selectedIndex = 1),
        isSelected: selectedIndex == 1,
      ),
      CollapsibleItem(
        text: 'View Counter',
        //`iconImage` has priority over `icon` property
        icon: Icons.supervised_user_circle_sharp,
        // onPressed: () => setState(() => selectedIndex = 2),
        onPressed: () {},
        isSelected: selectedIndex == 2,
      ),
      CollapsibleItem(
        text: 'User Report',
        //`iconImage` has priority over `icon` property
        icon: Icons.report,
        // onPressed: () => setState(() => selectedIndex = 3),
        onPressed: () {},
        isSelected: selectedIndex == 3,
      ),
      CollapsibleItem(
        text: 'Menu',

        //`iconImage` has priority over `icon` property
        icon: Icons.restaurant_menu,
        // onPressed: () => setState(() => selectedIndex = 4),
        onPressed: () {},
        isSelected: selectedIndex == 4,
      ),
      CollapsibleItem(
        text: 'Feedbacks',
        //`iconImage` has priority over `icon` property
        icon: Icons.feedback,
        // onPressed: () => setState(() => selectedIndex = 5),
        onPressed: () {},
        isSelected: selectedIndex == 5,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CollapsibleSidebar(
        title: 'Cater Admin',
        avatarBackgroundColor: themeColor.mint300,
        backgroundColor: themeColor.mint,
        curve: Curves.linear,
        borderRadius: 15,
        collapseOnBodyTap: true,
        isCollapsed: true,
        sidebarBoxShadow: [
          BoxShadow(
            color: themeColor.black.withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
        duration: Duration(milliseconds: 200),
        unselectedIconColor: themeColor.white,
        selectedIconColor: themeColor.mint,
        selectedTextColor: themeColor.mint,

        unselectedTextColor: themeColor.white,
        items: items,
        body: screens[selectedIndex],
      ),
    );
  }
}
