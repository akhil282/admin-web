import 'package:cater_admin_web/components/comman_textfield.dart';
import 'package:cater_admin_web/components/comman_ui.dart';
import 'package:cater_admin_web/components/globle_value.dart';
import 'package:cater_admin_web/components/responsive_builder.dart';
import 'package:cater_admin_web/components/text_comman.dart';
import 'package:cater_admin_web/components/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:material_table_view/material_table_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Employees List',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            buildCommonTextField(
              label: "Search",
              hint: "Search Employee",
              hintText: "Search Employee",
              controller: searchController,
              onChanged: (value) {},
              fillColor: themeColor.rubyGreen.withOpacity(0.3),
              filled: true,
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
            ),
            SizedBox(height: 16),
            Expanded(
              child: Responsive(
                mobile: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,

                    childAspectRatio: 3,
                  ),
                  itemBuilder:
                      (context, index) => UserView(
                        name: globleValue.employeesList[index]['name'],
                        id: globleValue.employeesList[index]['employee_id'],
                        department:
                            globleValue.employeesList[index]['department'],
                        isSelected:
                            globleValue.employeesList[index]['isSelected'],
                      ),
                ),
                tablet: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,

                    childAspectRatio: 3,
                  ),
                  itemBuilder:
                      (context, index) => UserView(
                        name: globleValue.employeesList[index]['name'],
                        id: globleValue.employeesList[index]['employee_id'],
                        department:
                            globleValue.employeesList[index]['department'],
                        isSelected:
                            globleValue.employeesList[index]['isSelected'],
                      ),
                ),
                desktop: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,

                    childAspectRatio: 3,
                  ),
                  itemBuilder:
                      (context, index) => UserView(
                        name: globleValue.employeesList[index]['name'],
                        id: globleValue.employeesList[index]['employee_id'],
                        department:
                            globleValue.employeesList[index]['department'],
                        isSelected:
                            globleValue.employeesList[index]['isSelected'],
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
