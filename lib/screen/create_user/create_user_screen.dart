import 'package:cater_admin_web/components/comman_button.dart';
import 'package:cater_admin_web/components/comman_textfield.dart';
import 'package:cater_admin_web/components/responsive_builder.dart';
import 'package:cater_admin_web/components/theme_color.dart';
import 'package:flutter/material.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool allowTea = false;

  @override
  void dispose() {
    usernameController.dispose();
    employeeIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Employee'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [IconButton(icon: Icon(Icons.download), onPressed: () {})],
      ),
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
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                elevation: 0,
                borderRadius: BorderRadius.circular(10),
                padding: EdgeInsets.symmetric(horizontal: 12),
                isExpanded: true,
                hint: Text('Department*'),
                items:
                    ['Department 1', 'Department 2', 'Department 3'].map((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (_) {},
              ),
            ),
          ),
          SizedBox(height: 24),
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
            onPressed: () {},
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
}
