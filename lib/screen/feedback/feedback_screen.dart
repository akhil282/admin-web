import 'package:cater_admin_web/components/comman_fuction.dart';
import 'package:cater_admin_web/components/comman_ui.dart';
import 'package:cater_admin_web/components/text_comman.dart';
import 'package:cater_admin_web/controllers/feedback_bloc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../components/responsive_builder.dart';
import '../../components/theme_color.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  DateTime selectedMonth = DateTime.now();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Start with current month
    feedbackBloc.getFeedbackByMonth(DateTime.now());
  }

  Future<void> initializeFeedback() async {
    setState(() => isLoading = true);
    await feedbackBloc.getFeedbackByMonth(
      DateTime.now(),
    ); // Fetch all data once
    setState(() => isLoading = false);
  }

  Widget _buildMonthPicker() {
    return GestureDetector(
      onTap: () {
        showMonthPicker(
          context: context,

          initialDate: DateTime.now(),
          firstDate: DateTime(2022),
          lastDate: DateTime(2030),
          monthPickerDialogSettings: MonthPickerDialogSettings(
            dialogSettings: PickerDialogSettings(
              dialogBackgroundColor: themeColor.white,
            ),
          ),
        ).then((date) {
          if (date != null) {
            setState(() {
              selectedMonth = date;
            });
          }
        });
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: themeColor.rubyGreen),
        ),
        child: Row(
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: themeColor.rubyGreen),
                SizedBox(width: 12),
                Text(
                  DateFormat('MMMM yyyy').format(selectedMonth),
                  style: TextStyle(
                    fontSize: 16,
                    color: themeColor.rubyGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: themeColor.rubyGreen,
                    size: 17,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedMonth = DateTime(
                        selectedMonth.year,
                        selectedMonth.month - 1,
                      );
                    });
                    feedbackBloc.getFeedbackByMonth(selectedMonth);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 17,
                    color: themeColor.rubyGreen,
                  ),
                  onPressed: () {
                    final now = DateTime.now();
                    final nextMonth = DateTime(
                      selectedMonth.year,
                      selectedMonth.month + 1,
                    );
                    if (nextMonth.isBefore(now) ||
                        (nextMonth.year == now.year &&
                            nextMonth.month == now.month)) {
                      setState(() => selectedMonth = nextMonth);
                      feedbackBloc.getFeedbackByMonth(nextMonth);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: themeColor.rubyGreen),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeColor.rubyGreen,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.feedback_outlined,
                size: 64,
                color: themeColor.rubyGreen.withOpacity(0.5),
              ),
              SizedBox(height: 16),
              Text(
                'No feedback available',
                style: TextStyle(
                  fontSize: 18,
                  color: themeColor.rubyGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Try selecting a different date',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileView(List<Map<String, dynamic>> feedbackList) {
    return Column(
      children: [
        Expanded(
          child:
              feedbackList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: feedbackList.length,
                    itemBuilder: (context, index) {
                      final feedback = feedbackList[index];
                      return Card(
                        color: themeColor.white,
                        margin: EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    color: themeColor.rubyGreen,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'ID: ${feedback['empId'] ?? 'N/A'}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: themeColor.rubyGreen.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Colors.amber,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '${feedback['rating'] ?? 0}',
                                          style: TextStyle(
                                            color: themeColor.rubyGreen,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),

                              text16(
                                "${feedback['feedback'] ?? 'No feedback provided'}",
                                color: themeColor.black,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 7,

                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(height: 8),
                              Text(
                                getFormattedDate(feedback['time']) ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildFeedbackCard(Map<String, dynamic> feedback) {
    return Card(
      elevation: 2,
      color: themeColor.white,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 20,
                  color: themeColor.rubyGreen,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ID: ${feedback['empId'] ?? ''}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: themeColor.rubyGreen,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: themeColor.rubyGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        '${feedback['rating'] ?? 0}',
                        style: TextStyle(
                          color: themeColor.rubyGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: text16(
                  "${feedback['feedback'] ?? 'No feedback provided'}",
                  color: themeColor.black,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 7,

                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              getFormattedDate(feedback['time']) ?? '',

              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletDesktopView(List<Map<String, dynamic>> feedbackList) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 1200;

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 3 : 2,
                    childAspectRatio: isDesktop ? 1.5 : 1.3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: feedbackList.length,
                  itemBuilder: (context, index) {
                    return _buildFeedbackCard(feedbackList[index]);
                  },
                ),
              ),
              if (width > 900)
                SingleChildScrollView(
                  child: SizedBox(
                    width: 400,
                    child: Card(
                      color: themeColor.white,
                      margin: EdgeInsets.all(16),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           text20('Statistics', color: themeColor.rubyGreen, fontWeight: FontWeight.bold,),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(
                                  Icons.message_outlined,
                                  color: themeColor.rubyGreen,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  feedbackList.length.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: themeColor.rubyGreen,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star_outline,
                                  color: themeColor.rubyGreen,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  _calculateAverageRating(feedbackList),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: themeColor.rubyGreen,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Average',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            StatisticsChart(totalReviews:  feedbackList.length, averageRating:   double.parse(_calculateAverageRating(feedbackList))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _calculateAverageRating(List<Map<String, dynamic>> feedbackList) {
    if (feedbackList.isEmpty) return '0.0';
    double total = feedbackList.fold(0.0, (sum, feedback) {
      return sum + (feedback['rating'] ?? 0);
    });
    return (total / feedbackList.length).toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor.white,
      appBar: AppBar(
        title: Text('Monthly Feedback'),
        backgroundColor: themeColor.rubyGreen,
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() => selectedMonth = DateTime.now());
              feedbackBloc.getFeedbackByMonth(selectedMonth);
            },
            icon: Icon(Icons.today, color: Colors.white),
            label: Text('Current Month', style: TextStyle(color: Colors.white)),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: feedbackBloc.feedbackStream,
        builder: (context, snapshot) {
          // Add debug prints
          print("StreamBuilder state: ${snapshot.connectionState}");
          print("Has data: ${snapshot.hasData}");
          print("Has error: ${snapshot.hasError}");
          if (snapshot.hasError) print("Error: ${snapshot.error}");
          if (snapshot.hasData) print("Data length: ${snapshot.data!.length}");

          if (isLoading) {
            return Center(child: CircularProgressIndicator( color: themeColor.mint,));
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          }

          final feedbackList =
              (snapshot.data ?? []).where((feedback) {
                DateTime feedbackTime = DateTime.fromMillisecondsSinceEpoch(
                  feedback['time'].seconds * 1000,
                ); // Convert timestamp to DateTime

                return feedbackTime.year == selectedMonth.year &&
                    feedbackTime.month == selectedMonth.month;
              }).toList();
          print("feedbackList:-------->${feedbackList}");

          return Column(
            children: [
              _buildMonthPicker(),
              SizedBox(height: 16),

              Expanded(
                child:
                    feedbackList.isEmpty
                        ? _buildEmptyState()
                        : Responsive(
                          mobile: _buildMobileView(feedbackList),
                          tablet: _buildTabletDesktopView(feedbackList),
                          desktop: _buildTabletDesktopView(feedbackList),
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
