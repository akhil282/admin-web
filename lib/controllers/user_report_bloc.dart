import 'dart:async';

import 'package:cater_admin_web/components/firebase_collection.dart';
import 'package:cater_admin_web/components/globle_value.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserReportBloc {
  StreamController<List<QueryDocumentSnapshot>> userReportController = StreamController<List<QueryDocumentSnapshot>>.broadcast();
  Stream<List<QueryDocumentSnapshot>> get userReportStream => userReportController.stream;
    final CollectionReference userReportCollection =
      FirebaseFirestore.instance.collection(FirebaseString.employeeCollection);

  List<QueryDocumentSnapshot> employees = [];

    Future<void> fetchEmployees({String? searchText}) async {
         employees.clear();

    try {
      Query query;

        query = userReportCollection.orderBy('userName');



      QuerySnapshot querySnapshot = await query.get();
      List<QueryDocumentSnapshot> newEmployees = querySnapshot.docs;

      if (newEmployees.isNotEmpty) {
        employees = newEmployees;

        userReportController.sink.add(employees);

        print("employees   $employees");
      } else {
        userReportController.sink.addError(globleValue.noDataFound);
      }
    } catch (e) {
      print('Error fetching employees: $e');
    }
  }
}

UserReportBloc userReportBloc = UserReportBloc();