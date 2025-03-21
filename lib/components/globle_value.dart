class GlobleValue {
  List<String> columnNames = [
    'Employee Name',
    'Employee ID',
    "Department",
    "Edit",
    "Active",
  ];

  List<Map<String, dynamic>> employeesList = List.generate(46, (index) {
    int employeeId = 1100006 + index * 2;
    return {
      "name": employeeId.toString(),
      "employee_id": employeeId.toString(),
      "department": "The First",
      "isChecked": index % 2 == 0,
    };
  });
}

GlobleValue globleValue = GlobleValue();
