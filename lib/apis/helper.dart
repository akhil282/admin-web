import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cater_admin_web/components/firebase_collection.dart';
import 'package:cater_admin_web/components/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart' as exc;



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



Future<void> pickLoadAndUploadExcel({required BuildContext context}) async {
  showPl(context);
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.single.bytes; // Web, iOS, Android
      String? filePath = result.files.single.path; // Windows, Android

      Uint8List? excelBytes;
      if (fileBytes != null) {
        excelBytes = fileBytes;
      } else if (filePath != null) {
        excelBytes = await File(filePath).readAsBytes();
      }

      if (excelBytes != null) {
        var excel = Excel.decodeBytes(excelBytes);

        // Assuming data is in the first sheet
        var sheet = excel.tables.keys.first;
        var rows = excel.tables[sheet]?.rows ?? [];

        if (rows.isEmpty) {
          print('No data found in the Excel file.');
          return;
        }

        List<Map<String, dynamic>> parsedData = [];

        // Skip the first row (headers) and process from second row
        for (int i = 1; i < rows.length; i++) {
          var row = rows[i];
          var rowData = {
            'userName': row[0]?.value.toString() ?? '',
            'empId': row[1]?.value.toString() ?? '',
            'password': row[2]?.value.toString() ?? '',
            'department': row[3]?.value.toString() ?? '',
            'tea': row[4]?.value.toString() == 'true',
            'isActive': true
          };
          parsedData.add(rowData);
        }

        print('Parsed Data: ${jsonEncode(parsedData)}');

        // Uploading to Firestore
        List<String> existingEmpIds = [];
        final CollectionReference employeeCollection =
            FirebaseFirestore.instance.collection(FirebaseString.newTempEmployeeCollection);

        for (var data in parsedData) {
          String empId = data['empId'];
          if (empId.isNotEmpty) {
            var docRef = employeeCollection.doc(empId);
            var docSnapshot = await docRef.get();

            if (docSnapshot.exists) {
              existingEmpIds.add(empId);
            } else {
              await docRef.set(data);
            }
          }
        }

        if (existingEmpIds.isNotEmpty) {
          print('The following empIds already exist in the collection: $existingEmpIds');
        } else {
          print('All data successfully uploaded to Firestore.');
        }
      }
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    hidePl();
  }
}





Future<void> downloadFormExcelForBulk() async {
  try {
    // Create an Excel file
    final Excel excel = Excel.createExcel();
    final Sheet sheet = excel['Sheet1'];

    // Add header row
    sheet.appendRow([
      TextCellValue('Username'),
      TextCellValue('Employee Id'),
      TextCellValue('Password'),
      TextCellValue('Department'),
      TextCellValue('Allow Tea'),
    ]);

    // Encode the Excel file
    final List<int>? bytes = excel.encode();
    if (bytes == null) throw Exception("Failed to encode Excel file");

    final Uint8List byteData = Uint8List.fromList(bytes);

    // Use FileSaver to save the file
    await FileSaver.instance.saveFile(
      name: "emp_form_format_${DateTime.now().millisecondsSinceEpoch}.xlsx",
      bytes: byteData,
      ext: "xlsx",
      mimeType: MimeType.other,
    );

    print('Excel file successfully saved.');
  } catch (e) {
    print('Error saving Excel file: $e');
  }
}
