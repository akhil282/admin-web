import 'package:flutter/material.dart';

showDataDialogViewOrderReport(BuildContext context, List<Map<String, dynamic>> data) async {
 await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Food Order Report"),
        content: SingleChildScrollView(
          child: DataTable(
            columns: const [
              DataColumn(label: Text("Date", style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text("Tea", style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text("Lunch", style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text("Dinner", style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: data.map((row) {
              return DataRow(cells: [
                DataCell(Text(row["date"].toString())),
                DataCell(Text(row["Tea"].toString())),
                DataCell(Text(row["Lunch"].toString())),
                DataCell(Text(row["Dinner"].toString())),
              ]);
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      );
    },
  );
}
