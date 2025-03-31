import 'dart:async';

import 'package:cater_admin_web/components/firebase_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FeedbackBloc {
  final StreamController<List<Map<String, dynamic>>> feedbackStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get feedbackStream =>
      feedbackStreamController.stream;

  final CollectionReference feedBackCollection = FirebaseFirestore.instance
      .collection(FirebaseString.feedBackCollection);

  List<Map<String, dynamic>> feedbackList = [];

  Future<void> getFeedbackByMonth(DateTime selectedMonth) async {
    try {
      String startDate = DateFormat(
        "ddMMyyyy",
      ).format(DateTime(selectedMonth.year, selectedMonth.month, 1));
      String endDate = DateFormat(
        "ddMMyyyy",
      ).format(DateTime(selectedMonth.year, selectedMonth.month + 1, 0));

      print("Fetching feedback from $startDate to $endDate");

      QuerySnapshot snapshot = await feedBackCollection.get();

      print("Found ${snapshot.docs.length} documents");

      feedbackList = [];

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        if (data['feedbackList'] != null) {
          List<dynamic> dayFeedback = data['feedbackList'];
          feedbackList.addAll(
            dayFeedback.map((item) => Map<String, dynamic>.from(item)),
          );
        }
      }

      print("Total feedback entries: ${feedbackList.length}");

      feedbackStreamController.sink.add(feedbackList);
    } catch (e) {
      print("Error fetching feedback: $e");
      feedbackStreamController.sink.addError(e.toString());
    }
  }

  void dispose() {
    feedbackStreamController.close();
  }
}

FeedbackBloc feedbackBloc = FeedbackBloc();
