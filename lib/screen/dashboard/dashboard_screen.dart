import 'dart:math';

import 'package:cater_admin_web/components/comman_button.dart';
import 'package:cater_admin_web/components/comman_textfield.dart';
import 'package:cater_admin_web/components/comman_toastnotification.dart';
import 'package:cater_admin_web/components/comman_ui.dart';
import 'package:cater_admin_web/components/firebase_collection.dart';
import 'package:cater_admin_web/components/globle_value.dart';
import 'package:cater_admin_web/components/responsive_builder.dart';
import 'package:cater_admin_web/components/text_comman.dart';
import 'package:cater_admin_web/components/theme_color.dart';
import 'package:cater_admin_web/controllers/dashboard_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:material_table_view/material_table_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController searchController = TextEditingController();
  DashboardController? dashBoardController;
  String searchValue = '';

  @override
  void initState() {
    dashBoardController = Get.put(DashboardController());
    dashBoardController!.fetchEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: themeColor.white,
      body: Padding(
        padding: EdgeInsets.all(width < 600 ? 8.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      SizedBox(height:       getHeight(context, 3.5),),

            Text(
              'Employees List',
              style: TextStyle(
                fontSize: width < 600 ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: themeColor.rubyGreen,
              ),
            ),
            SizedBox(height: width < 600 ? 8 : 16),
            buildCommonTextField(
              label: "Search",
              hint: "Search Employee",
              hintText: "Search Employee",
              labelStyle: TextStyle(color: themeColor.rubyGreen),
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchValue = value;
                });

              },
              fillColor: Colors.white,
              filled: true,
              icon: Icons.search,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: themeColor.rubyGreen),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: themeColor.rubyGreen),
              ),
            ),
            SizedBox(height: width < 600 ? 8 : 16),
            Expanded(
              child:
                  width < 772
                      ? Obx(
                        () => _buildMobileView(
                          dashBoardController!.employees.isEmpty
                              ? <QueryDocumentSnapshot>[]
                              : dashBoardController!.employees,
                        ),
                      )
                      : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _buildTableView(dashBoardController!.employees),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileView(List<QueryDocumentSnapshot> employees) {
    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        final employeeData = employee.data() as Map<String, dynamic>;

        

        return employeeData['userName'].toString().contains(searchValue.toString())?  Container(
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color:
                employeeData['isActive'] ?? false
                    ? themeColor.rubyGreen.withOpacity(0.1)
                    : themeColor.rubyRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  employeeData['isActive'] ?? false
                      ? themeColor.rubyGreen
                      : themeColor.rubyRed,
              width: 1,
            ),
          ),
          child: ListTile(
            title: Text(employeeData['userName'] ?? ''),
            subtitle: Text('ID: ${employeeData['empId'] ?? ''}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                    inactiveTrackColor: themeColor.white,

                  value: employeeData['isActive'] ?? false,
                  onChanged: (value) async {
                    await dashBoardController!.updateEmployeeStatus(
                      docId: employee.id,
                      newValue: value,
                    );
                  },
                  activeColor: themeColor.rubyGreen,
                ),
                IconButton(
                  padding: EdgeInsets.all(4),
                  constraints: BoxConstraints(),
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: themeColor.rubyGreen,
                  ),
                  onPressed: () => showEditDialog(context, employee),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () async {
                    await dashBoardController!.deleteEmployee(
                      docId: employee.id,
                      context: context,
                    );
                  },
                ),
              ],
            ),
          ),
        ):SizedBox();
      },
    );
  }

  Widget _buildTableView(List<QueryDocumentSnapshot> employeesTempList) {
    return Obx(() => Container(
      width: max(772, getWidth(context, 100 - 32)), // Minimum width of 772px
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(2), // Employee Name
          1: FlexColumnWidth(2), // Employee ID
          2: FlexColumnWidth(2), // Department
          3: FlexColumnWidth(1), // Status
          4: FlexColumnWidth(1.5), // Actions
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade100),
            children: [
              _buildHeaderCell('Employee Name'),
              _buildHeaderCell('Employee ID'),
              _buildHeaderCell('Department'),
              _buildHeaderCell('Status'),
              _buildHeaderCell('Actions'),
            ],
          ),
...employeesTempList.where((employee) {
  return employee['userName']
      .toString()
      .contains(searchValue.toString());
}).map((employee) {
  print("final employee data:--------->${employee.data()}");
  return TableRow(
    children: [
      _buildTableCell(employee['userName'] ?? ''),
      _buildTableCell(employee['empId'] ?? ''),
      _buildTableCell(employee['department'] ?? ''),
      _buildTableCell(
        '',
        child: Switch(
          value: employee['isActive'] ?? false,
          inactiveTrackColor: themeColor.white,
          onChanged: (value) async {
            // Update the value in Firestore
            await dashBoardController!.updateEmployeeStatus(
              docId: employee.id,
              newValue: value,
            );

            // Refresh the UI by re-fetching the data or updating the local list
            setState(() {
              final employeeData = dashBoardController!.employees
                  .firstWhere((e) => e.id == employee.id)
                  .data();
              if (employeeData != null) {
                (employeeData as Map<String, dynamic>)['isActive'] =
                    value;
              }
            });
          },
          activeColor: themeColor.rubyGreen,
        ),
      ),
      _buildTableCell(
        '',
        child: Row(
          children: [
            IconButton(
              padding: EdgeInsets.all(4),
              constraints: BoxConstraints(),
              icon: Icon(
                Icons.edit_outlined,
                size: 18,
                color: themeColor.rubyGreen,
              ),
              onPressed: () async {
                await showEditDialog(context, employee);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: themeColor.rubyRed),
              onPressed: () {
                dashBoardController!.deleteEmployee(
                  docId: employee.id,
                  context: context,
                );
              },
            ),
          ],
        ),
      ),
    ],
  );
}).toList(),
        ],
      ),
    )
 ,); }

  Widget _buildHeaderCell(String text) {
    return TableCell(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTableCell(String text, {Widget? child}) {
    return TableCell(
      child: Padding(padding: EdgeInsets.all(16), child: child ?? Text(text)),
    );
  }

 showEditDialog(BuildContext context, QueryDocumentSnapshot employee) {
    final employeeData = employee.data() as Map<String, dynamic>;
    final TextEditingController nameController = TextEditingController(
      text: employeeData['userName'] ?? '',
    );
    final TextEditingController idController = TextEditingController(
      text: employeeData['empId'] ?? '',
    );
    String? selectedDepartment = employeeData['department'];
    bool allowTea = employeeData['tea'] ?? false;
    bool isActive = employeeData['isActive'] ?? false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: 400),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Employee',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeColor.rubyGreen,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                buildCommonTextField(
                  label: "Username",
                  hint: "Enter username",
                  hintText: "Enter username",
                  controller: nameController,
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
                buildCommonTextField(
                  label: "Employee ID",
                  hintText: "Enter employee id",
                  hint: "Enter employee id",
                  controller: idController,
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
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    border: Border.all(color: themeColor.rubyGreen),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedDepartment,

                      padding: EdgeInsets.symmetric(horizontal: 12),
                      borderRadius: BorderRadius.circular(10),

                      hint: Text('Select Department'),
                      dropdownColor: themeColor.white,

                      items:
                          ['The First', 'GNFC'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,

                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (newValue) {
                        selectedDepartment = newValue;
                        (context as Element).markNeedsBuild();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Text('Allow Tea'),
                            Spacer(),
                            Switch(
                    inactiveTrackColor: themeColor.white,

                              value: allowTea,
                              onChanged: (value) {
                                allowTea = value;
                                (context as Element).markNeedsBuild();
                              },
                              activeColor: themeColor.mint,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                buildCommonColorButton(
                  onPressed: () async {
                    try {
                      await dashBoardController!.updateEmployee(
                        docId: employee.id,
                        empId: idController.text,
                        userName: nameController.text,
                        password:
                            employeeData['password'], // Keep existing password
                        isActive: isActive,
                        tea: allowTea,
                        department: selectedDepartment ?? '',
                      );
                      Navigator.pop(context);
                      showAppSnackBar(
                        title: 'Employee updated successfully',
                        message: 'Employee updated successfully',
                        bgColor: themeColor.rubyGreen,
                      );
                    } catch (e) {
                      print("utdate time error:----------->$e");
                      showAppSnackBar(
                        title: 'Error',
                        message: 'Failed to update employee',
                        bgColor: themeColor.rubyRed,
                      );
                    }
                  },
                  text: "Update Employee",
                  backgroundColor: themeColor.mint,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
