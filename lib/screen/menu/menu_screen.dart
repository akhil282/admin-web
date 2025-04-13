import 'package:cater_admin_web/apis/helper.dart';
import 'package:cater_admin_web/components/comman_button.dart';
import 'package:cater_admin_web/components/comman_date_picker.dart';
import 'package:cater_admin_web/components/loader.dart';
import 'package:cater_admin_web/components/text_comman.dart';
import 'package:cater_admin_web/components/theme_color.dart';
import 'package:cater_admin_web/controllers/menu_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:intl/intl.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  DateRange selectedMenuDate = DateRange(DateTime.now().subtract(Duration(days: 7)), DateTime.now());

  List<String> dates = [];
    List<String> getDatesInRange(DateRange dateRange) {
    List<String> dates = [];
    DateTime currentDate = dateRange.start;

    while (currentDate.isBefore(dateRange.end) ||
        currentDate.isAtSameMomentAs(dateRange.end)) {
      dates.add(DateFormat('dd/MM/yyyy').format(currentDate));
      currentDate = currentDate.add(const Duration(days: 1));
    }

    print("dates:---------> $dates");

    return dates;
  }



  @override
  Widget build(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: themeColor.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: text20(
            'Menu',
              fontSize: width < 600 ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: themeColor.black,
            
          ),),
        backgroundColor: themeColor.mint,
      ),
       body: Padding(
                 padding: EdgeInsets.all(width < 600 ? 8 : 16),
      
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


    
             
                SizedBox(height: width < 600 ? 8 : 10),

                   GestureDetector(
                  onTap: () {
                    print("selectedMenuDate  org 1 --- $selectedMenuDate");
                    showDateRangePickerDialog(
                      context: context,
                      offset:width < 600? Offset(width/2-100,
                         width/4) : Offset(width/2-50,
                         width/4),
                      builder: (context, onDateRangeChanged) =>
                          DateRangePickerWidget(
                        doubleMonth: false,
                        initialDateRange:selectedMenuDate,
                        
                        
                        onDateRangeChanged: (value) {
                        print("0-==-0=-0=- $value");
                          if (value != null) {
                            dates = getDatesInRange(value);
                          print("90-909-09-09-09-09-09-09- $dates");
                            setState(() {
                             selectedMenuDate = value;
                            });
                          }
                        },
                        
                        allowSingleTapDaySelection: true,
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 24, right: 24, top: 16, bottom: 16),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        color:themeColor.mint100,
                        borderRadius: BorderRadius.circular(45),
                        boxShadow: [
                          BoxShadow(
                            color: themeColor.black.withOpacity(0.1),
                            offset: const Offset(0, 5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ]),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                           selectedMenuDate == null
                                ? DateFormat("dd-MMM-y").format(DateTime.now())
                                : DateFormat("dd-MMM-y")
                                    .format(selectedMenuDate!.start),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text("To"),
                        ),
                        Expanded(
                          child: Text(
                           selectedMenuDate == null
                                ? DateFormat("dd-MMM-y").format(DateTime.now())
                                : DateFormat("dd-MMM-y")
                                    .format(selectedMenuDate!.end),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Icon(Icons.calendar_month_outlined),
                      ],
                    ),
                  ),
                ),
        SizedBox(height: width < 600 ? 8 : 16),
     StreamBuilder(stream: menuBloc.menuStream, builder:(context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data!;
              print("data:---------> $data");

           return    data['columns'].isEmpty && data['rows'].isEmpty
                    ? const SizedBox()
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Center(
                          child: Column(
                            children: [
                              DataTable(
                                headingRowColor: WidgetStatePropertyAll(
                                   themeColor.mint100),
                                columns: data['columns'],
                                rows: data['rows'],
                              ),
                            ],
                          ),
                        ));
             
            } else {
              

              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(child: Text("No Data Found")),
                  ],
                ),
              );
            }
           },)       
          ,Spacer()
           ,   if (selectedMenuDate != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32,
                        vertical: 8.0),
                    child: SizedBox(
                      width: width,
                      child: buildCommonColorButton(
                      text: "Get Menu",
                      backgroundColor: themeColor.mint,
                        onPressed: () async {
                          print("selectedMenuDate  org 2 --- $selectedMenuDate");
                          print("selectedMenuDate  ${selectedMenuDate.toString().replaceAll("-", "").replaceAll(" ", "").replaceAll("/", "")}");
                          String docId = selectedMenuDate
                              .toString()
                              .replaceAll("-", "")
                              .replaceAll(" ", "")
                              .replaceAll("/", "");
                      
                       showPl(context);
                          if (await menuBloc.getMenu(docId: docId)) {
                           menuBloc.showDataTable();
                           hidePl();
                          } else {
                           hidePl();
                          }
                        },
                      ),
                    ),
                  ),
        
            ],
          ),
        ),
      
    );
 
  }
}