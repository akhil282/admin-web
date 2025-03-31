import 'dart:convert';

import 'package:cater_admin_web/apis/helper.dart';
import 'package:cater_admin_web/components/comman_button.dart';
import 'package:cater_admin_web/components/comman_date_picker.dart';
import 'package:cater_admin_web/components/comman_textfield.dart';
import 'package:cater_admin_web/components/comman_toastnotification.dart';
import 'package:cater_admin_web/components/comman_ui.dart';
import 'package:cater_admin_web/components/globle_value.dart';
import 'package:cater_admin_web/components/loader.dart';
import 'package:cater_admin_web/components/responsive_builder.dart';
import 'package:cater_admin_web/components/text_comman.dart';
import 'package:cater_admin_web/components/theme_color.dart';
import 'package:cater_admin_web/controllers/get_emp_report_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewEmployeeReportScreen extends StatefulWidget {
  QueryDocumentSnapshot<Object?> employeeData;

  ViewEmployeeReportScreen({super.key, required this.employeeData});

  @override
  State<ViewEmployeeReportScreen> createState() => _ViewEmployeeReportScreenState();
}

class _ViewEmployeeReportScreenState extends State<ViewEmployeeReportScreen> {
    DateTimeRange selectedReportDate = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
    List<String> dates = [];
  List dataToUploadOnStore = [];

  

      getInitialData({dynamic docIdDate}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
showPl(context);


      dataToUploadOnStore = [];
      setState(() {});

      if (await getEmpReportBloc.checkOrderDocument(
          docId: DateFormat("ddMMyyyy").format(docIdDate!).toString())) {
        await getEmpReportBloc.getOrder(
            docId: DateFormat("ddMMyyyy").format(docIdDate!).toString());
        String encryptedText = getEmpReportBloc.orderData[0]; // The encrypted text
        String keyBase64 = getEmpReportBloc.orderData[1]; // The base64 encoded key
        String decryptedText = decryptionFunction(encryptedText, keyBase64);
        List decryptedList = jsonDecode(decryptedText);
        dataToUploadOnStore = decryptedList;
       hidePl();
      } else {
        hidePl();
       showAppSnackBar(
            title: "Generate Order List",
            message: "No data found for this date",
            context: context);
      }
    });
  }

    List<String> getDatesInRange( DateTimeRange dateRange) {
    List<String> dates = [];
    DateTime currentDate = dateRange.start;

    while (currentDate.isBefore(dateRange.end) ||
        currentDate.isAtSameMomentAs(dateRange.end)) {
      dates.add(DateFormat('dd/MM/yyyy').format(currentDate));
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return dates;
  }




  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: themeColor.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ListTile(
          title: Center(child: text20(
            'Show Employee Report',
              fontSize: width < 600 ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: themeColor.black,
            
          ),),
          trailing: StreamBuilder(stream: getEmpReportBloc.empReportStream, builder: (context, snapshot) {
           if(snapshot.hasData){
             return snapshot.data!.isNotEmpty? iconButton(icon: Icons.download, onPressed: (){
            showPl(context);
            generatePDF(allData: getEmpReportBloc.allData,empId: widget.employeeData['empId'].toString());
      hidePl();
          }, color: themeColor.mint,):null;
           }else {

             return SizedBox();
           }
          },),
          
        ),
        backgroundColor: themeColor.mint,
      ),
       body: Padding(
                 padding: EdgeInsets.all(width < 600 ? 8 : 16),
      
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        SizedBox(height:       13,),
          text20(
            '${widget.employeeData['userName']}',
           
              fontWeight: FontWeight.w900,
              color: themeColor.black,
            
          ),
        SizedBox(height:       8,),
          text16(
            'EMP ID : ${widget.employeeData['empId']}',
           
              fontWeight: FontWeight.w500,
              color: themeColor.black,
            
          ),
        SizedBox(height:       5,),
          text16(
            'DEPARTMENT : ${widget.employeeData['department']}',
           
              fontWeight: FontWeight.w500,
              color: themeColor.black,
            
          ),

             
                SizedBox(height: width < 600 ? 8 : 10),
              DateRangePickerField(onDateSelected: (selectedDate) {
                showPl(context);
                    selectedReportDate = selectedDate;
                     dates = getDatesInRange(selectedDate);
                       getEmpReportBloc.fetchDataForSingleEmoyeeDocumentIds( documentIds: dates,
                                              employeeId: widget.employeeData['empId'].toString(),);
                  setState(() {
                  });
                }),
                SizedBox(height: width < 600 ? 8 : 16),
                Expanded(
                  child: StreamBuilder<List<dynamic>>(
                    stream: getEmpReportBloc.empReportStream,
                    builder: (context,snapshot) {
                      if (snapshot.hasData) {
                        List<dynamic> allData = snapshot.data!;

                        return allData.isEmpty ? Center(
                            child: text16(globleValue.noDataFound,fontWeight: FontWeight.w700,),
                          ) : SingleChildScrollView(child: CommonDataTable(allData: allData));
                        
                      } else if (snapshot.hasError){
                        return Center(
                          child: text16(globleValue.noDataFound,fontWeight: FontWeight.w700,),
                        );
                      }else{
                          getEmpReportBloc.fetchDataForSingleEmoyeeDocumentIds( documentIds: dates,
                                              employeeId: widget.employeeData['empId'].toString(),);
                
                        return Center(
                          child: CircularProgressIndicator(color: themeColor.mint,),
                        );}
                    }
                  )    ),
              
            ],
          ),
        ),
      
    );
  }
}