import 'package:cater_admin_web/components/comman_button.dart';
import 'package:cater_admin_web/components/globle_value.dart';
import 'package:cater_admin_web/components/text_comman.dart';
import 'package:cater_admin_web/components/theme_color.dart';
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
