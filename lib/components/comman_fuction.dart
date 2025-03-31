import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String getFormattedDate(dynamic date) {
  DateTime dateTime;

  if (date is Timestamp) {
    dateTime = date.toDate(); // Convert Timestamp to DateTime
  } else if (date is String) {
    try {
      dateTime = DateTime.parse(date); // Parse string date
    } catch (e) {
      return "Invalid date"; // Handle incorrect formats
    }
  } else if (date is DateTime) {
    dateTime = date; // Use directly if it's already DateTime
  } else {
    return "Invalid date"; // Return error message for unsupported formats
  }

  return DateFormat("d MMMM yyyy").format(dateTime);
}
