import 'package:cater_admin_web/components/comman_toastnotification.dart';
import 'package:cater_admin_web/components/firebase_collection.dart';
import 'package:cater_admin_web/components/theme_color.dart';
import 'package:cater_admin_web/screen/create_user/create_user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<QueryDocumentSnapshot> _employeesList =
      <QueryDocumentSnapshot>[].obs;

  // Getter for the employees list
  List<QueryDocumentSnapshot> get employees => _employeesList;

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore
              .collection(FirebaseString.newTempEmployeeCollection)
              .get();
      _employeesList.value = querySnapshot.docs;

      print('Fetched employees: ${_employeesList.value}'); // Debug print
      update();
    } catch (e) {
      print('Error fetching employees: $e');
    }
  }

  // Update employee status
  Future<void> updateEmployeeStatus({
    required String docId,
    required bool newValue,
  }) async {
    try {
      await _firestore.collection('newTempEmployee').doc(docId).update({
        'isActive': newValue,
      });

      await fetchEmployees(); // Refresh the list
    } catch (e) {
      print('Error updating status: $e');
      Get.snackbar(
        'Error',
        'Failed to update status',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Delete employee
  Future<void> deleteEmployee({
    required String docId,
    required BuildContext context,
  }) async {
    try {
      await _firestore.collection('newTempEmployee').doc(docId).delete();

      await fetchEmployees(); // Refresh the list

      Get.snackbar(
        'Success',
        'Employee deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error deleting employee: $e');
      Get.snackbar(
        'Error',
        'Failed to delete employee',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Add new employee
  Future<bool> addEmployee({
    required String empId,
    required String userName,
    required String password,
    required bool isActive,
    required bool tea,
    required String department,
  }) async {
    try {
      await _firestore
          .collection(FirebaseString.newTempEmployeeCollection)
          .doc(empId)
          .set({
            'empId': empId,
            'userName': userName,
            'password': password,
            'isActive': isActive,
            'tea': tea,
            'department': department,
          });

      await fetchEmployees(); // Refresh the list
      return true;
    } catch (e) {
      print('Error adding employee: $e');
      return false;
    }
  }

  // Update existing employee
  Future<void> updateEmployee({
    required String docId,
    required String empId,
    required String userName,
    required String password,
    required bool isActive,
    required bool tea,
    required String department,
  }) async {
    try {
      print('Updating document with ID: $docId'); // Debug print

      final updateData = {
        'empId': empId,
        'userName': userName,
        'password': password,
        'isActive': isActive,
        'tea': tea,
        'department': department,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      print('Update data: $updateData'); // Debug print

      await _firestore
          .collection('newTempEmployee')
          .doc(docId)
          .update(updateData);

      print('Document updated successfully'); // Debug print

      // Refresh the employees list
      await fetchEmployees();
    } catch (e) {
      print('Error in updateEmployee: $e'); // Debug print
      throw e; // Rethrow to handle in UI
    }
  }
}
