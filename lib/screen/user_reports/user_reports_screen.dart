// import 'package:cater_admin_web/components/comman_textfield.dart';
// import 'package:cater_admin_web/components/globle_value.dart';
// import 'package:cater_admin_web/components/responsive_builder.dart';
// import 'package:cater_admin_web/components/text_comman.dart';
// import 'package:cater_admin_web/components/theme_color.dart';
// import 'package:cater_admin_web/controllers/user_report_bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';

// class UserReportsScreen extends StatefulWidget {
//   const UserReportsScreen({super.key});

//   @override
//   State<UserReportsScreen> createState() => _UserReportsScreenState();
// }

// class _UserReportsScreenState extends State<UserReportsScreen> {

//   TextEditingController searchController = TextEditingController();
//   String searchValue = "";
//   final searchFormKey = GlobalKey<FormBuilderState>();

//   @override
//   void initState() {
//     userReportBloc.fetchEmployees();
//     super.initState();
//   }



//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     print("width:----------> $width");
//     return Scaffold(
//         backgroundColor: themeColor.white,
//         body: Padding(
//                  padding: EdgeInsets.all(width < 600 ? 8.0 : 16.0),
      
//           child: Column(
//             children: [
//         SizedBox(height:       getHeight(context, 3.5),),
//                Text(
//                   'User Report',
//                   style: TextStyle(
//                     fontSize: width < 600 ? 20 : 24,
//                     fontWeight: FontWeight.bold,
//                     color: themeColor.rubyGreen,
//                   ),
//                 ),
//                 SizedBox(height: width < 600 ? 8 : 16),
//                 buildCommonTextField(
//                   label: "Search",
//                   hint: "Search Employee",
//                   hintText: "Search Employee",
//                   labelStyle: TextStyle(color: themeColor.rubyGreen),
//                   controller: searchController,
//                   onChanged: (value) {
//                     setState(() {
//                       searchValue = value;
//                     });
          
//                   },
//                   fillColor: Colors.white,
//                   filled: true,
//                   icon: Icons.search,
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: themeColor.rubyGreen),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: themeColor.rubyGreen),
//                   ),
//                 ),
//                 SizedBox(height: width < 600 ? 8 : 16),
//                 Expanded(
//                   child: StreamBuilder<List<QueryDocumentSnapshot>>(stream: userReportBloc.userReportStream, builder: (context, snapshot) {
//                     if(snapshot.hasData){
      
//                       List<QueryDocumentSnapshot> employees = snapshot.data!;
//                       if (employees.isEmpty) {
//                         return Center(
//                           child:text16(globleValue.noDataFound,fontWeight: FontWeight.w700,),
//                         );
//                       }
                      
//                  return  SingleChildScrollView(
//                    child: SizedBox(
//                     height: 600,
//                      child: GridView.builder(
                                
//                                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                       crossAxisCount: MediaQuery.of(context).size.width > 1200
//                                           ? 4 // Desktop
//                                           : MediaQuery.of(context).size.width > 960
//                                               ? 3 // Large Tablet / Small Desktop
//                                               : MediaQuery.of(context).size.width > 600
//                                                   ? 2 // Tablet
//                                                   : 1, // Mobile
//                                       crossAxisSpacing: 10,
//                                       mainAxisSpacing: 10,
//                                       childAspectRatio: 1.2,
//                                       mainAxisExtent: 400,
//                                     ),
//                                     itemCount: employees.length,
//                                     itemBuilder: (context, index) {
//                                       QueryDocumentSnapshot<Object?> employee = employees[index];
//                                       print("employee:-----> ${employee}");
//                                           return Container(
//                                         padding: EdgeInsets.all(12),
//                                         decoration: BoxDecoration(
//                                           color: employee['isActive']
//                                                       ?  themeColor.mint100
//                                                       : themeColor.rubyRed.withOpacity(0.1),
//                                           borderRadius: BorderRadius.circular(12),
//                                         ),
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                          Row(children: [
//                                             Expanded(child:  text16("${employee['userName'] ?? '-'}",color: themeColor.black,fontWeight: FontWeight.w900,),
//                                             ),
//                                              Icon(Icons.remove_red_eye,color: themeColor.gray,),
                                         
//                                          ],),
//                                            Divider(
//                                               color: themeColor.gray,
//                                               thickness: 1,
//                                             ),
//                                             text14("Employee Id: ${employee['empId'] ?? '-'}"),
//                                             SizedBox(height: 6),
//                                             text14("Department: ${employee['department'] ?? '-'}"),
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                   ),
//                    ),
//                  );
  
//                   }else if (snapshot.hasError) {
//                       return Center(
//                         child: text16(
//                           snapshot.error.toString(),
//                           fontWeight: FontWeight.w700,
//                         ),
//                       );
//                     } else {
//                      if(userReportBloc.employees.isEmpty){
//                        userReportBloc.fetchEmployees();
//                      }else{
//                       userReportBloc.userReportController.sink.add(userReportBloc.employees);
//                      }
//                       return Center(
//                         child: CircularProgressIndicator( color: themeColor.mint,),
//                       );
//                     }
//                   },
                  
//                   )
                  
//                    ),
              
//             ],
//           ),
//         ),
//       );
  
//   }
// }