import 'package:cater_admin_web/apis/helper.dart';
import 'package:cater_admin_web/components/comman_button.dart';
import 'package:cater_admin_web/components/globle_value.dart';
import 'package:cater_admin_web/components/text_comman.dart';
import 'package:cater_admin_web/components/theme_color.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UserView extends StatefulWidget {
  final String name;
  final String id;
  final String department;
  bool isSelected;

  UserView({
    Key? key,
    required this.name,
    required this.id,
    required this.department,
    bool? isSelected,
  }) : isSelected = isSelected ?? false,
       super(key: key);

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:
            widget.isSelected
                ? themeColor.rubyGreen.withOpacity(0.5)
                : themeColor.rubyRed.withOpacity(0.5),
      ),
      margin: EdgeInsets.all(7),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: text16(
                    "Employee Name : ",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    color: themeColor.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: text16(
                    widget.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    color: themeColor.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: text16(
                    "Employee ID : ",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    color: themeColor.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: text16(
                    widget.id,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    color: themeColor.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: text16(
                    "Department : ",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    color: themeColor.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: text16(
                    widget.department,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    color: themeColor.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: CheckboxListTile(
                    value: widget.isSelected,
                    activeColor: themeColor.mint,
                    checkColor: themeColor.black,
                    fillColor: MaterialStateProperty.all(themeColor.white),
                    title: Text(widget.isSelected ? "Active" : "Deactive"),
                    contentPadding: EdgeInsets.zero,
                    tileColor:
                        widget.isSelected
                            ? themeColor.rubyGreen
                            : themeColor.rubyRed,
                    enabled: true,
                    isThreeLine: false,
                    visualDensity: VisualDensity(
                      vertical: VisualDensity.minimumDensity,
                      horizontal: VisualDensity.minimumDensity,
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.isSelected = value ?? false;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: iconButton(
                      icon: Icons.delete,
                      onPressed: () {},
                      color: themeColor.rubyRed,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: iconButton(
                      icon: Icons.edit,
                      onPressed: () {},
                      color: themeColor.rubyGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class StatisticsChart extends StatelessWidget {
  final int totalReviews;
  final double averageRating;

  const StatisticsChart({
    Key? key,
    required this.totalReviews,
    required this.averageRating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          maxY: totalReviews > 5 ? totalReviews.toDouble() : 5,
          barGroups: [
            BarChartGroupData(
              x: 0,
              
              barRods: [
                BarChartRodData(toY: totalReviews.toDouble(), color: Colors.blue, width: 30, borderRadius: BorderRadius.circular(4)),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(toY: averageRating, color: Colors.orange, width: 30, borderRadius: BorderRadius.circular(4)),
              ],
            ),
          ],
          titlesData: FlTitlesData(
        
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text("", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600));
                    case 1:
                      return const Text("", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600));
                    default:
                      return const Text("");
                  }
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          gridData: FlGridData(show: true),
        ),
      ),
    );
  }
}



class UserInfoCard extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserInfoCard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final userInfo = userData['userInfo'] ?? {};
    final foodInfo = List<Map<String, dynamic>>.from(userData['foodInfo'] ?? []);
    final lastAction = userData['lastAction'] ?? 'N/A';
    final bool isActive = userInfo['isActive'] == true;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 3,
      color: themeColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(userInfo['userName']?.toString() ?? 'N/A',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Icon(Icons.circle, size: 10, color: isActive ? Colors.green : Colors.red),
              ],
            ),
            const Divider(height: 10, thickness: 0.5),
            _buildInfoRow("Department", userInfo['department'] ?? 'N/A', Icons.business),
            _buildInfoRow("Tea", userInfo['tea'] == true ? "Yes" : "No", Icons.local_cafe),
            _buildInfoRow("Last Action", formatLastAction(lastAction.toString()), Icons.access_time),
            const SizedBox(height: 20),
            if (foodInfo.isNotEmpty) ...[
              Text("Food Info", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: foodInfo.map((food) => _buildFoodChip(food['type'], food['count'].toString())).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: themeColor.mint300),
          const SizedBox(width: 6),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
          Text(value, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }

Widget _buildFoodChip(String type, String count) {
  int countValue = int.tryParse(count) ?? 0; // Convert string count to int

  return Chip(
    label: Text(
      "$type ($count)", 
      style: const TextStyle(fontSize: 12),
    ),
    backgroundColor: countValue > 0 ? themeColor.mint : themeColor.mint100,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  );
}

}





class CommonDataTable extends StatelessWidget {
  final List<dynamic> allData;

  const CommonDataTable({Key? key, required this.allData}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: constraints.maxWidth, // Makes it full width
              child: DataTable(
                columnSpacing: 24,
                headingRowHeight: 40,
                dataRowMaxHeight: 40,
                dataRowMinHeight: 40,
                headingRowColor: WidgetStateProperty.all(themeColor.mint300),
                columns: const [
                  DataColumn(label: Expanded(child: Center(child: Text('Date')))),
                  DataColumn(label: Expanded(child: Center(child: Text('Tea')))),
                  DataColumn(label: Expanded(child: Center(child: Text('Lunch')))),
                  DataColumn(label: Expanded(child: Center(child: Text('Dinner')))),
                ],
                rows: [
                  ...allData.map((e) => DataRow(
                        cells: [
                          DataCell(Center(child: Text("${e['date']}"))),
                          DataCell(Center(child: Text("${e['orderList'][0]['foodInfo'][0]['count']}"))),
                          DataCell(Center(child: Text("${e['orderList'][0]['foodInfo'][1]['count']}"))),
                          DataCell(Center(child: Text("${e['orderList'][0]['foodInfo'][2]['count']}"))),
                        ],
                      )),
                  DataRow(
                    color: WidgetStateProperty.all(themeColor.mint100),
                    cells: [
                      const DataCell(Center(child: Text('Total'))),
                      DataCell(Center(child: Text('${_getTotal("tea")}'))),
                      DataCell(Center(child: Text('${_getTotal("lunch")}'))),
                      DataCell(Center(child: Text('${_getTotal("dinner")}'))),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ],
  );
}

  /// Calculate total count for each column
  int _getTotal(String type) {
    return allData.fold(0, (sum, e) {
      int index = type == "tea" ? 0 : type == "lunch" ? 1 : 2;
      return sum + ((e['orderList'][0]['foodInfo'][index]['count'] ?? 0) as int);
    });
  }

  /// Generate PDF file and download it

  /// Helper method to create PDF table cells
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
}
