import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:tractor/DatabaseHelper.dart';
import 'DatabaseHelper.dart';

class ViewDetails extends StatefulWidget {
  const ViewDetails({Key? key}) : super(key: key);

  @override
  _ViewDetailsState createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List<Map<dynamic, dynamic>>? dataList;
  List<Map<dynamic, dynamic>>? unPaidDataList;
  List<Map<dynamic, dynamic>>? selectedNameDataList;
  List<Map<dynamic, dynamic>>? selectedContactDataList;

  List<int> selectedTransactions = [];

  int selectedIndex = 0;
  String name = "";
  String contact = "";

  List<PopupMenuItem<String>> pops = [
    PopupMenuItem(
      child: Text("Unpaid Transcations"),
      value: "0",
    ),
    PopupMenuItem(
      child: Text("Select by Name"),
      value: "1",
    ),
    PopupMenuItem(
      child: Text("Select by Contact"),
      value: "2",
    ),
    PopupMenuItem(
      child: Text("All Transcations"),
      value: "3",
    ),
  ];

  fetchAllData() async {
    dataList = await databaseHelper.showAll();
  }

  fetchSelectedName(String name) async {
    selectedNameDataList = await databaseHelper.showSelectedName(name);
  }

  fetchSelectedContact(String contact) async {
    selectedContactDataList = await databaseHelper.showSelectedContact(contact);
  }

  fetchUnpaid() async {
    unPaidDataList = await databaseHelper.showUnPaid();
  }

  @override
  Widget build(BuildContext context) {
    List methods = [
      showTable(),
      showUnpaidTable(),
      showSelectedNameTable(name),
      showSelectedContactTable(contact)
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("View Transcations"),
        backgroundColor: Colors.red,
        actions: [
          PopupMenuButton(
              onSelected: (value) {
                if (value == "0") {
                  setState(() {
                    selectedIndex = 1;
                  });
                } else if (value == "1") {
                  showCustomerChooseAlert();
                } else if (value == "2") {
                  showContactChooseAlert();
                } else if (value == "3") {
                  setState(() {
                    selectedIndex = 0;
                  });
                }
              },
              itemBuilder: (context) => pops)
        ],
      ),
      body: methods[selectedIndex],
    );
  }

  showTable() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
              future: fetchAllData(),
              builder: (context, snapshot) {
                if (dataList == null) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Text(
                            "Loading....",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ]);
                } else {
                  return DataTable(
                    columns: getDataColumn(),
                    rows: dataList!
                        .map((data) => getDataRow(data, dataList!))
                        .toList(),
                  );
                }
              }),
        ));
  }

  showSelectedNameTable(String name) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
              future: fetchSelectedName(name),
              builder: (context, snapshot) {
                if (selectedNameDataList == null) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Text(
                            "Loading....",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ]);
                } else {
                  return DataTable(
                    columns: getDataColumn(),
                    rows: selectedNameDataList!
                        .map((data) => getDataRow(data, selectedNameDataList!))
                        .toList(),
                  );
                }
              }),
        ));
  }

  showSelectedContactTable(String contact) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
              future: fetchSelectedContact(contact),
              builder: (context, snapshot) {
                if (selectedContactDataList == null) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Text(
                            "Loading....",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ]);
                } else {
                  return DataTable(
                    columns: getDataColumn(),
                    rows: selectedContactDataList!
                        .map((data) =>
                            getDataRow(data, selectedContactDataList!))
                        .toList(),
                  );
                }
              }),
        ));
  }

  showUnpaidTable() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
              future: fetchUnpaid(),
              builder: (context, snapshot) {
                if (unPaidDataList == null) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Text(
                            "Loading....",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ]);
                } else {
                  return DataTable(
                    columns: getDataColumn(),
                    rows: unPaidDataList!
                        .map((data) => getDataRow(data, unPaidDataList!))
                        .toList(),
                  );
                }
              }),
        ));
  }

  showCustomerChooseAlert() {
    TextEditingController nameController = new TextEditingController();
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            content: TextField(
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.5,
                )),
              ),
              controller: nameController,
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      name = nameController.text.trim();
                      selectedIndex = 2;
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Done"))
            ],
          );
        });
  }

  showContactChooseAlert() {
    TextEditingController contactController = new TextEditingController();
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            content: TextField(
              decoration: InputDecoration(
                labelText: "Contact",
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.5,
                )),
              ),
              controller: contactController,
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      contact = contactController.text.trim();
                      selectedIndex = 3;
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Done"))
            ],
          );
        });
  }

  List<DataColumn> getDataColumn() {
    List<DataColumn> dataColumn = [
      DataColumn(
        label: Text("Date"),
      ),
      DataColumn(
        label: Text("Full Name"),
      ),
      DataColumn(
        label: Text("Contact"),
      ),
      DataColumn(
        label: Text("Start Time"),
      ),
      DataColumn(
        label: Text("End Time"),
      ),
      DataColumn(
        label: Text("Duration"),
      ),
      DataColumn(
        label: Text("Total Cost"),
      ),
      DataColumn(
        label: Text("Paid Amount"),
      ),
      DataColumn(
        label: Text("Due Amount"),
      ),
      DataColumn(
        label: Text("Actions"),
      ),
    ];
    return dataColumn;
  }

  DataRow getDataRow(
      Map<dynamic, dynamic> data, List<Map<dynamic, dynamic>> list) {
    return DataRow(
        selected: this.selectedTransactions.contains(data["id"]),
        onSelectChanged: (isSelected) {
          bool isAdding = isSelected != null && isSelected;

          setState(() {
            isAdding
                ? selectedTransactions.add(data["id"])
                : selectedTransactions.remove(data["id"]);
          });
        },
        cells: [
          DataCell(Text(data["date"])),
          DataCell(Text(data["name"]), showEditIcon: true, onTap: () {
            updateAlert(data, "name");
          }),
          DataCell(
            Text(data["contact"]),
            showEditIcon: true,
            onTap: () {
              updateAlert(data, "contact");
            },
          ),
          DataCell(Text(data["start_time"])),
          DataCell(Text(data["end_time"])),
          DataCell(Text(data["duration"].toString() + " min")),
          DataCell(Text(data["total_cost"].toString())),
          DataCell(Text(data["paid"].toString()), showEditIcon: true,
              onTap: () {
            updateAlert(data, "paid");
          }),
          DataCell(Text(data["due"].toString())),
          DataCell(
            IconButton(
                onPressed: () async {
                  await databaseHelper.delete(data["id"]);
                  setState(() {
                    list.remove(data);
                  });
                },
                icon: Icon(Icons.delete)),
          ),
        ]);
  }

  updateAlert(Map data, String key) {
    TextEditingController updateController = new TextEditingController();
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            content: TextField(
              controller: updateController,
              keyboardType:
                  key != "name" ? TextInputType.number : TextInputType.text,
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    String newValue = updateController.text.trim();
                    Map<String, Object?> mapData = Map.from(data);
                    if (key == "paid") {
                      double totalAmount =
                          double.parse(data["total_cost"].toString());
                      double enteredPaidAmount = double.parse(newValue);
                      double newDueAmount = totalAmount - enteredPaidAmount;
                      mapData.update(key, (value) => enteredPaidAmount);
                      mapData.update("due", (value) => newDueAmount);
                    } else {
                      mapData.update(key, (value) => newValue);
                    }

                    setState(() {
                      databaseHelper.updateDatabase(mapData);
                    });

                    Navigator.pop(context);
                  },
                  child: Text("Done"))
            ],
          );
        });
  }
}
