import 'dart:async';

import 'package:cater_admin_web/components/firebase_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MenuBloc {

  StreamController<Map<String, dynamic>> menuStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get menuStream =>
      menuStreamController.stream;

  Map<String, dynamic> dataTableListData = {};
  

    final CollectionReference menuCollection =
      FirebaseFirestore.instance.collection(FirebaseString.menuCollection);


    Map<String, dynamic> menuData = {};
  Future getMenu({required String docId}) async {
    try {
      DocumentSnapshot doc = await menuCollection.doc(docId).get();
      menuData = (doc.data() as Map<String, dynamic>?)!;
      print("menuData   $menuData");
      // log("menuData   jsonEncode -- ${jsonEncode(menuData)}");
    
      return true;
    } catch (e) {
      print("Error in saving employee data : $e");
      return false;
    }
  }

    List<DataRow> rows = [];
  List<DataColumn> columns = [];



  showDataTable() {
    final List<dynamic> menuList = menuData['menu'];
    rows.clear();
    columns.clear();

    // Extract unique routines
    final Set<String> routines =
        menuList.map<String>((item) => item['routine']).toSet();

    // Create a map of routine to menu items
    final Map<String, List<String>> routineMenuMap = {};
    for (var item in menuList) {
      final routine = item['routine'];
      final menu = List<String>.from(item['menu']);
      routineMenuMap[routine] = menu;
    }

    // Prepare columns
    columns =
        routines.map((routine) => DataColumn(label: Text(routine))).toList();

    // Prepare rows
    final int maxItems = routineMenuMap.values
        .map((items) => items.length)
        .reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < maxItems; i++) {
      final List<DataCell> cells = [];
      for (var routine in routines) {
        final menuItems = routineMenuMap[routine] ?? [];
        final menuItem = i < menuItems.length ? menuItems[i] : '-';
        cells.add(DataCell(Text(menuItem)));
      }
      rows.add(DataRow(cells: cells));
    }

    dataTableListData = {
      'columns': columns,
      'rows': rows,
    };
  }

}


MenuBloc menuBloc = MenuBloc();