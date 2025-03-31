import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:intl/intl.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

String formatDateKey(DateTime date) {
  return DateFormat("ddMMyyyy").format(date);
}


String formatLastAction(String timestamp) {
  DateTime parsedDate = DateTime.parse(timestamp);
  return DateFormat("yyyy-MM-dd hh:mm a").format(parsedDate); 
}

String decryptionFunction(String encryptedTextBase64, String keyBase64) {
  try {
    // Reconstruct Key and IV
    final key = encrypt.Key.fromBase64(keyBase64);
    print(">>?${DateFormat('ddMMyyyy').format(DateTime.now().toUtc())}");
    // final iv = encrypt.IV.fromUtf8("${DateFormat('ddMMyyyy').format(DateTime.now().toUtc())}-3er#B8K");
    final iv = encrypt.IV.fromUtf8("27082024-3er#B8K");

    // Create Encrypter
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    // Decrypt the text
    final decrypted = encrypter.decrypt64(encryptedTextBase64, iv: iv);

    return decrypted;
  } catch (e) {
    print('Error during decryption: $e');
    return 'Decryption failed';
  }
}


Future<void> generatePDF({required List<dynamic> allData,required String empId}) async {
  final pdf = pw.Document();

  final int rowsPerPage = 20; // Adjust as needed
  final int totalPages = (allData.length / rowsPerPage).ceil();

  for (int page = 0; page < totalPages; page++) {
    final int start = page * rowsPerPage;
    final int end = (start + rowsPerPage) > allData.length ? allData.length : (start + rowsPerPage);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (page == 0) // Show title only on the first page
                pw.Text("Meal Report", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      _pdfCell("Date", isHeader: true),
                      _pdfCell("Tea", isHeader: true),
                      _pdfCell("Lunch", isHeader: true),
                      _pdfCell("Dinner", isHeader: true),
                    ],
                  ),
                  ...allData.sublist(start, end).map((e) => pw.TableRow(children: [
                        _pdfCell(e['date']),
                        _pdfCell(e['orderList'][0]['foodInfo'][0]['count'].toString()),
                        _pdfCell(e['orderList'][0]['foodInfo'][1]['count'].toString()),
                        _pdfCell(e['orderList'][0]['foodInfo'][2]['count'].toString()),
                      ])),
                  if (page == totalPages - 1) // Show totals only on the last page
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey300),
                      children: [
                        _pdfCell("Total", isHeader: true),
                        _pdfCell(_getTotal(type: "tea",allData: allData).toString()),
                        _pdfCell(_getTotal(type: "lunch",allData: allData).toString()),
                        _pdfCell(_getTotal(type: "dinner",allData: allData).toString()),
                      ],
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );}
  final Uint8List pdfBytes = await pdf.save();

  final blob = html.Blob([pdfBytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", "Meal_Report_${empId}-${DateTime.now()}.pdf")
    ..click();
  html.Url.revokeObjectUrl(url);
}

  

    pw.Widget _pdfCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8.0),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal),
      ),
    );
  }

    int _getTotal({required String type,required List<dynamic> allData}) {
    return allData.fold(0, (sum, e) {
      int index = type == "tea" ? 0 : type == "lunch" ? 1 : 2;
      return sum + ((e['orderList'][0]['foodInfo'][index]['count'] ?? 0) as int);
    });
  }