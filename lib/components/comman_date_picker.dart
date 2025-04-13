import 'package:cater_admin_web/components/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const DatePickerField({Key? key, required this.onDateSelected}) : super(key: key);

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime? selectedDate = DateTime.now();

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: selectedDate,
      helpText: "Select Date",
      cancelText: "CANCEL",
      confirmText: "SELECT",
      errorFormatText: "Enter valid date",
      errorInvalidText: "Enter a date in valid range",
      fieldHintText: "Select Date",
      builder: (context, child) {
        return child!;
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        widget.onDateSelected(picked);
      });
    }
  }

  String formatDate(DateTime date) {
    return DateFormat("dd MMM-yyyy").format(date).toUpperCase(); // Convert to uppercase
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: pickDate,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        width: double.infinity, // Full width for better alignment
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center align
          children: [
            Icon(Icons.calendar_today, size: 20, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              selectedDate == null ? "Select Date" : formatDate(selectedDate!),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}




class DateRangePickerField extends StatefulWidget {
  final Function(DateTimeRange) onDateSelected;

  DateRangePickerField({Key? key, required this.onDateSelected}) : super(key: key);

  @override
  _DateRangePickerFieldState createState() => _DateRangePickerFieldState();
}

class _DateRangePickerFieldState extends State<DateRangePickerField> {
  DateTimeRange? selectedRange;

  Future<void> pickDateRange() async {
    DateTime lastAvailableDate = DateTime.now();

    // Ensure initial range does not exceed lastDate
    DateTime startRange = DateTime.now().subtract(Duration(days: 30));
    if (startRange.isAfter(lastAvailableDate)) {
      startRange = lastAvailableDate.subtract(Duration(days: 1));
    }

    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: lastAvailableDate, // Ensure last date is valid
      initialDateRange: selectedRange ?? DateTimeRange(
        start: lastAvailableDate.subtract(Duration(days: 7)),
        end: lastAvailableDate,
      ),
      helpText: "Select Date Range",
      cancelText: "CANCEL",
      confirmText: "SELECT",
      saveText: "SAVE",
      errorFormatText: "Enter valid date range",
      errorInvalidText: "Enter date range in valid range",
      fieldStartHintText: "Start Date",
      fieldEndHintText: "End Date",
      builder: (context, child) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            width: 350,
            child: child,
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedRange = picked;
        widget.onDateSelected(picked);
      });
    }
  }

  String formatDate(DateTime date) {
    return DateFormat("dd-MM-yyyy").format(date).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: pickDateRange,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 20, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              selectedRange == null
                  ? "Select Date Range"
                  : "${formatDate(selectedRange!.start)}  TO  ${formatDate(selectedRange!.end)}",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
