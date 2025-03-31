import 'dart:async';
import 'dart:convert';

import 'package:cater_admin_web/apis/helper.dart';
import 'package:cater_admin_web/components/firebase_collection.dart';
import 'package:cater_admin_web/components/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetEmpReportBloc {
  StreamController<List<dynamic>> empReportStreamController =
      StreamController<List<dynamic>>.broadcast();

      Stream<List<dynamic>> get empReportStream =>
      empReportStreamController.stream;

        final CollectionReference foodOrderCollection =
      FirebaseFirestore.instance.collection(FirebaseString.foodOrderCollection);

        List<dynamic> allData = [];
  List orderData = [];

  int totalTeaCount = 0;
  int totalLunchCount = 0;
  int totalDinnerCount = 0;
  

    Future getOrder({required String docId}) async {
    try {
      orderData.clear();
      DocumentSnapshot doc = await foodOrderCollection.doc(docId).get();
      var orderDataList = (doc.data() as Map<String, dynamic>?)!;
      orderData = orderDataList['data'] ?? [];

      return true;
    } catch (e) {
      print("Error in getting orderData data : $e");
      return false;
    }
  }


    Future checkOrderDocument({required String docId}) async {
    orderData.clear();

    DocumentSnapshot doc = await foodOrderCollection.doc(docId).get();
    bool exists = doc.exists;
    if (exists) {
      print("checkOrderDocument exists!");
      return true;
    } else {
      print("checkOrderDocument does not exist.");
      return false;
    }
  }


        Future<void> fetchDataForSingleEmoyeeDocumentIds({
    required List<String> documentIds,
    required String employeeId,
  }) async {
    allData.clear();
    totalTeaCount = 0;
    totalLunchCount = 0;
    totalDinnerCount = 0;

    List<dynamic> tempData = [];

    for (String id in documentIds) {
      try {
        // Fetch the document
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('foodOrder')
            .doc(id.replaceAll('/', ''))
            .get();

        if (doc.exists) {
          List<dynamic>? data = doc.get('data');
          if (data != null) {
            String decryptedText = decryptionFunction(data[0], data[1]);
            List decryptedList = jsonDecode(decryptedText);

            // Filter the orders for the specific employee
            List filteredOrderList = decryptedList
                .where((order) =>
                    order['userInfo']['empId'].toString() == employeeId)
                .toList();

            // Only add to tempData if there are orders for this employee
            if (filteredOrderList.isNotEmpty) {
              tempData.add({
                "date": id,
                "value": data,
                "orderList": filteredOrderList,
              });
            }
          }else{
            print("No data found in document with ID $id.");

          }
        }else {
          print("Document with ID $id does not exist.");
          empReportStreamController.sink.addError(
              "Document with ID $id does not exist.");
        }
      } catch (e) {
        print("Error fetching document with ID $id: $e");
      }
    }



    // Calculate totals only for the specific employee
    for (var entry in allData) {
      for (var order in entry['orderList']) {
        for (var food in order['foodInfo']) {
          if (food['type'] == 'Tea') {
            totalTeaCount += (food['count'] as int);
          } else if (food['type'] == 'Lunch') {
            totalLunchCount += (food['count'] as int);
          } else if (food['type'] == 'Dinner') {
            totalDinnerCount += (food['count'] as int);
          }
        }
      }
    }

        allData = tempData;
    empReportStreamController.sink.add(allData);
    hidePl();

    print('Total Tea Count for Employee $employeeId: $totalTeaCount');
    print('Total Lunch Count for Employee $employeeId: $totalLunchCount');
    print('Total Dinner Count for Employee $employeeId: $totalDinnerCount');
    print("Filtered allData for Employee $employeeId: ${jsonEncode(allData)}");


  }

}


GetEmpReportBloc getEmpReportBloc = GetEmpReportBloc();