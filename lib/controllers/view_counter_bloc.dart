import 'dart:async';
import 'dart:convert';

import 'package:cater_admin_web/apis/helper.dart';
import 'package:cater_admin_web/components/comman_dialog.dart';
import 'package:cater_admin_web/components/comman_toastnotification.dart';
import 'package:cater_admin_web/components/firebase_collection.dart';
import 'package:cater_admin_web/components/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewCounterBloc {
  final _viewCounterController = StreamController<List<Map<String, dynamic>>>.broadcast(); // Broadcast stream

  Stream<List<Map<String, dynamic>>> get viewCounterStream => _viewCounterController.stream;

  void addData(List<Map<String, dynamic>> data) {
    _viewCounterController.sink.add(data);
  }

  void dispose() {
    _viewCounterController.close();
  }

  final CollectionReference foodOrderCollection =
      FirebaseFirestore.instance.collection(FirebaseString.foodOrderCollection);

  List<Map<String, dynamic>> dataToUploadOnStore = [];

  Future checkOrderDocument({required String docId}) async {
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

  Future<void> fetchFoodOrdersByDate(
      String dateKey, BuildContext context) async {
    if (dataToUploadOnStore.isNotEmpty) {
      print("---------------Data already fetched, returning cached data---------------");
      addData(dataToUploadOnStore);
      hidePl();
    }

    CollectionReference usersCollection = FirebaseFirestore.instance
        .collection("newFoodOrder")
        .doc(dateKey)
        .collection("users");

    print("usersCollection:----------->${usersCollection}");

    QuerySnapshot snapshot = await usersCollection.get();

    if (snapshot.docs.isEmpty) {
      print("---------------No records found for the date: ---------------$dateKey");
      addData([]);
      hidePl();
      return;
    }

    List<Map<String, dynamic>> foodOrders = [];

    for (var doc in snapshot.docs) {
      var data = doc["data"];

      if (data is Map<String, dynamic>) {
        foodOrders.add(data); // Add the `data` map directly
      } else {
        print("Unexpected data format in Firestore: $data");
        continue;
      }
    }

    // Sort by `lastAction` (most recent first)
    foodOrders.sort((a, b) {
      DateTime timeA =
          DateTime.tryParse(a["lastAction"] ?? "") ?? DateTime(2000);
      DateTime timeB =
          DateTime.tryParse(b["lastAction"] ?? "") ?? DateTime(2000);
      return timeB.compareTo(timeA); // Descending order (latest first)
    });

    print("Fetched & Sorted Food Orders: ${jsonEncode(foodOrders)}");

    // Store all fetched data in `dataToUploadOnStore`
    if (foodOrders.isNotEmpty) {
      dataToUploadOnStore = foodOrders;
      addData(dataToUploadOnStore);
      hidePl();
    }
  }

  getInitialDataTemp(
    BuildContext context, {
    dynamic docIdDate,
  }) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dataToUploadOnStore.clear();
      addData(dataToUploadOnStore); // Clear previous data

      print("dataToUploadOnStore:------------>${dataToUploadOnStore}");

      if (await checkOrderDocument(
          docId: DateFormat("ddMMyyyy").format(docIdDate!).toString())) {
        await fetchFoodOrdersByDate(
            DateFormat("ddMMyyyy").format(docIdDate!).toString(), context);
      } else {
        dataToUploadOnStore.clear();
        print("dataToUploadOnStore:------------>${dataToUploadOnStore}");
        addData(dataToUploadOnStore);
        hidePl();

        showAppSnackBar(
            title: "Generate Order List",
            message: "No data found for this date",
            context: context);
      }
    });
  }
}

ViewCounterBloc viewCounterBloc = ViewCounterBloc();

class ViewCounteOnly {
  StreamController<List<Map<String, dynamic>>> viewCounterOnlyController = StreamController<List<Map<String, dynamic>>>.broadcast(); // Broadcast stream
  Stream<List<Map<String, dynamic>>> get viewCounterOnlyStream => viewCounterOnlyController.stream;
  List<Map<String, dynamic>> counterReportData = [];

  fetchFoodOrderReportInRange({
    required DateTime startDate,
    required DateTime endDate,
    required BuildContext context,
  }) async {
    List<Map<String, dynamic>> reportData = [];
    Map<String, Map<String, int>> dateWiseSummary = {};
    DateFormat dateFormat = DateFormat("ddMMyyyy");

    viewCounterOnlyController.sink.add([]); // Clear previous data

    for (DateTime date = startDate;
        date.isBefore(endDate.add(Duration(days: 1)));
        date = date.add(Duration(days: 1))) {
      String dateKey = dateFormat.format(date); // Convert to Firestore format

      print("Fetching data for dateKey:-----> $dateKey");

      try {
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection("newFoodOrder")
            .doc(dateKey)
            .collection("users")
            .get();

        int teaCount = 0, lunchCount = 0, dinnerCount = 0;

        for (var userDoc in userSnapshot.docs) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          if (userData.containsKey("data")) {
            Map<String, dynamic> data = userData["data"];

            List<dynamic> foodInfo = data["foodInfo"] ?? [];
            for (var food in foodInfo) {
              if (food["type"] == "Tea") {
                teaCount += (food["count"] ?? 0) as int;
              } else if (food["type"] == "Lunch") {
                lunchCount += (food["count"] ?? 0) as int;
              } else if (food["type"] == "Dinner") {
                dinnerCount += (food["count"] ?? 0) as int;
              }
            }
          }
        }

        if (teaCount > 0 || lunchCount > 0 || dinnerCount > 0) {
          dateWiseSummary[dateKey] = {
            "Tea": teaCount,
            "Lunch": lunchCount,
            "Dinner": dinnerCount
          };
        }
      } catch (e) {
        print("Error fetching data for $dateKey: $e");
      }
    }

    dateWiseSummary.forEach((date, counts) {
      reportData.add({
        "date":
            "${date.substring(0, 2)}/${date.substring(2, 4)}/${date.substring(4, 8)}", // Format date as DD/MM/YYYY
        "Tea": counts["Tea"]!,
        "Lunch": counts["Lunch"]!,
        "Dinner": counts["Dinner"]!,
      });
    });

    // Add total at the bottom
    reportData.add({
      "date": "Total",
      "Tea": reportData.fold(0, (sum, item) => sum + (item["Tea"] as int)),
      "Lunch": reportData.fold(0, (sum, item) => sum + (item["Lunch"] as int)),
      "Dinner":
          reportData.fold(0, (sum, item) => sum + (item["Dinner"] as int)),
    });

    counterReportData = reportData;
    print("Final counterReportData:-----> $counterReportData");

    viewCounterOnlyController.sink.add(counterReportData);

    showDataDialogViewOrderReport(context, viewCounterOnlyBloc.counterReportData);
  }
}

ViewCounteOnly viewCounterOnlyBloc = ViewCounteOnly();