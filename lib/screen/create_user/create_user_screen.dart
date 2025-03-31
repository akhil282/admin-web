import 'package:cater_admin_web/components/comman_button.dart';
import 'package:cater_admin_web/components/comman_textfield.dart';
import 'package:cater_admin_web/components/comman_toastnotification.dart';
import 'package:cater_admin_web/components/responsive_builder.dart';
import 'package:cater_admin_web/components/theme_color.dart';
import 'package:cater_admin_web/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  bool allowTea = false;
  String? selectedDepartment;
  bool isSearching = false;
  DashboardController? dashboardController;

  // List of departments
  final List<String> departments = ['The First', 'GNFC'];

  // Filtered departments based on search
  List<String> get filteredDepartments {
    if (searchController.text.isEmpty) {
      return departments;
    }
    return departments
        .where(
          (dept) =>
              dept.toLowerCase().contains(searchController.text.toLowerCase()),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    dashboardController = Get.put(DashboardController());
  }

  @override
  void dispose() {
    usernameController.dispose();
    employeeIdController.dispose();
    passwordController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: _buildContent(true),
        tablet: _buildContent(false),
        desktop: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 800),
            child: _buildContent(false),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Fill-Up Employee Details',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: getHeight(context, 5)),
          buildCommonTextField(
            labelStyle: TextStyle(
              color: themeColor.rubyGreen,
              fontWeight: FontWeight.bold,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: themeColor.rubyGreen),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: themeColor.rubyGreen),
            ),
            label: "Username",
            hint: "Enter username",
            hintText: "Enter username",
            controller: usernameController,
          ),
          SizedBox(height: getHeight(context, 2.5)),
          buildCommonTextField(
            labelStyle: TextStyle(
              color: themeColor.rubyGreen,
              fontWeight: FontWeight.bold,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: themeColor.rubyGreen),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: themeColor.rubyGreen),
            ),
            label: "Employee Id",
            hint: "Enter employee id",
            hintText: "Enter employee id",
            controller: employeeIdController,
          ),
          SizedBox(height: getHeight(context, 2.5)),
          buildCommonTextField(
            labelStyle: TextStyle(
              color: themeColor.rubyGreen,
              fontWeight: FontWeight.bold,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: themeColor.rubyGreen),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: themeColor.rubyGreen),
            ),
            label: "Password",
            hint: "Enter password",
            hintText: "Enter password",
            controller: passwordController,
            obscureText: true,
          ),
          SizedBox(height: getHeight(context, 2.5)),
          buildDepartmentDropdown(),
          SizedBox(height: getHeight(context, 2.5)),
          Container(
            color: Colors.grey.shade200,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Checkbox(
                  value: allowTea,
                  activeColor: themeColor.mint,
                  onChanged: (value) {
                    setState(() {
                      allowTea = value ?? false;
                    });
                  },
                ),
                Text('Allow Tea *'),
              ],
            ),
          ),
          SizedBox(height: getHeight(context, 5)),
          buildCommonColorButton(
            onPressed: () async {
              if (employeeIdController.text.isEmpty ||
                  usernameController.text.isEmpty ||
                  passwordController.text.isEmpty ||
                  selectedDepartment == null) {
                Get.snackbar(
                  'Error',
                  'Please fill all required fields',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }

              try {
                await dashboardController?.addEmployee(
                  empId: employeeIdController.text,
                  userName: usernameController.text,
                  password: passwordController.text,
                  isActive: true,
                  tea: allowTea,
                  department: selectedDepartment!,
                );

                employeeIdController.clear();
                usernameController.clear();
                passwordController.clear();
                setState(() {
                  selectedDepartment = null;
                  allowTea = false;
                });
              } catch (e) {
                print('Error adding employee: $e');
                Get.snackbar(
                  'Error',
                  'Failed to add employee',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            text: "Save Employee Details",
            backgroundColor: themeColor.mint,
          ),
          SizedBox(height: getHeight(context, 2.5)),
          buildCommonColorButton(
            onPressed: () {},
            text: "Bulk Upload",
            backgroundColor: themeColor.mint,
          ),
        ],
      ),
    );
  }

  Widget buildDepartmentDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Department *',
          style: TextStyle(
            color: themeColor.rubyGreen,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: themeColor.rubyGreen),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              // Selected Department Display
              InkWell(
                onTap: () {
                  setState(() {
                    isSearching = !isSearching;
                    if (!isSearching) {
                      searchController.clear();
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDepartment ?? 'Select Department',
                          style: TextStyle(
                            color:
                                selectedDepartment != null
                                    ? Colors.black
                                    : Colors.grey,
                          ),
                        ),
                      ),
                      Icon(
                        isSearching ? Icons.close : Icons.arrow_drop_down,
                        color: themeColor.rubyGreen,
                      ),
                    ],
                  ),
                ),
              ),
              // Search and Dropdown
              if (isSearching) ...[
                Divider(height: 0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search department...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: themeColor.rubyGreen,
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  constraints: BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredDepartments.length,
                    itemBuilder: (context, index) {
                      final dept = filteredDepartments[index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedDepartment = dept;
                            isSearching = false;
                            searchController.clear();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color:
                                selectedDepartment == dept
                                    ? themeColor.rubyGreen.withOpacity(0.1)
                                    : null,
                            border: Border(
                              top: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Text(
                            dept,
                            style: TextStyle(
                              color:
                                  selectedDepartment == dept
                                      ? themeColor.rubyGreen
                                      : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
