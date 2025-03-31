import 'package:cater_admin_web/components/comman_date_picker.dart';
import 'package:cater_admin_web/components/comman_dialog.dart';
import 'package:cater_admin_web/components/comman_textfield.dart';
import 'package:cater_admin_web/components/comman_ui.dart';
import 'package:cater_admin_web/components/loader.dart';
import 'package:cater_admin_web/components/text_comman.dart';
import 'package:cater_admin_web/components/theme_color.dart';
import 'package:cater_admin_web/controllers/view_counter_bloc.dart';
import 'package:flutter/material.dart';

class ViewCounterScreen extends StatefulWidget {
  const ViewCounterScreen({super.key});

  @override
  State<ViewCounterScreen> createState() => _ViewCounterScreenState();
}

class _ViewCounterScreenState extends State<ViewCounterScreen> {
  DateTime viewCountSelectedDate = DateTime.now();
  TextEditingController searchController = TextEditingController();
  String searchValue = "";
  DateTimeRange selectedDateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  List<Map<String, dynamic>> viewCountList = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print("width:----------> $width");
    return Scaffold(
      backgroundColor: themeColor.white,
      body: Padding(
        padding: EdgeInsets.all(width < 600 ? 8.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'View Counter',
              style: TextStyle(
                fontSize: width < 600 ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: themeColor.rubyGreen,
              ),
            ),
            SizedBox(height: width < 600 ? 8 : 16),
            buildCommonTextField(
              label: "Search Employee",
              hint: "Search Employee",
              hintText: "Search Employee",
              labelStyle: TextStyle(color: themeColor.rubyGreen),
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchValue = value;
                });
              },
              fillColor: Colors.white,
              filled: true,
              icon: Icons.search,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: themeColor.rubyGreen),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: themeColor.rubyGreen),
              ),
            ),
            SizedBox(height: width < 600 ? 8 : 16),
              Row(
                children: [
                  Expanded(child: text16("Show food order report:",fontWeight: FontWeight.w700,),),

                  Expanded(
                    flex: 3,
                    child: DateRangePickerField(onDateSelected: (range) async {
                    
                      showPl(context);
                    
                      selectedDateRange = range;
                            
                    
                               viewCounterOnlyBloc.fetchFoodOrderReportInRange(startDate: selectedDateRange.start, endDate: selectedDateRange.end,context: context).then((value) {
                                hidePl();
                               });
                    
                    
                      
                    }),
                  ),
                ],
              ),
              
            SizedBox(height: width < 600 ? 8 : 16),
            DatePickerField(
              onDateSelected: (date) async {
                showPl(context);
            

                await viewCounterBloc.getInitialDataTemp(context, docIdDate: date);
              },
            ),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: viewCounterBloc.viewCounterStream, // Use the broadcast stream
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    viewCountList = snapshot.data?.where((element) {
                      final userInfo = element['userInfo'] ?? {};
                      final userName = userInfo['userName']?.toString() ?? '';
                      final searchQuery = searchValue.toString();
                      return userName.contains(searchQuery);
                    }).toList() ?? [];
                    print("viewCountList:------------>${viewCountList}");
                    return viewCountList.isEmpty
                        ? Center(child: text14("No data found."))
                        : SingleChildScrollView(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: GridView.builder(
                                padding: const EdgeInsets.all(8),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  mainAxisExtent: 230,
                                  crossAxisCount: width < 800
                                      ? 1
                                      : width > 1155
                                          ? 3
                                          : 2,
                                ),
                                itemCount: viewCountList.length,
                                itemBuilder: (context, index) {
                                  if (index < viewCountList.length) {
                                    Map<String, dynamic> userData = viewCountList[index];
                                    return UserInfoCard(userData: userData);
                                  } else {
                                    return const SizedBox(); // Return an empty widget if the index is out of range
                                  }
                                },
                              ),
                            ),
                          );
                  } else if (snapshot.hasError) {
                    return text12(snapshot.error.toString());
                  } else {
                    viewCounterBloc.getInitialDataTemp(context, docIdDate: viewCountSelectedDate);

                    return Center(
                      child: CircularProgressIndicator(
                        color: themeColor.mint,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
