import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tractor/DatabaseHelper.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String startTime = "";
  String endTime = "";
  String timeDifference = "";
  String costToPay = "0";
  var format = DateFormat('hh:mm:ss');
  String minutes = "0";
  double? costRate;

  bool isStartDisable = false;
  bool isEndDisable = true;
  bool isSaveDisable = true;

  TextEditingController _fullNameController = new TextEditingController();
  TextEditingController _contactController = new TextEditingController();
  TextEditingController _paidAmountController = new TextEditingController();

  Color disableBorderColor = new Color(0xFFff9999);

  DatabaseHelper databaseHelper = new DatabaseHelper();

  setCostRate() async {
    var prefs = await SharedPreferences.getInstance();
    double cost = prefs.getDouble("cost")!;
    setState(() {
      this.costRate = cost;
    });
  }

  void showStartTime() {
    setState(() {
      startTime = DateFormat('hh:mm:ss').format(DateTime.now()).toString();
      endTime = "";
      timeDifference = "";
      costToPay = "0";
      minutes = "0";

      isStartDisable = true;
      isEndDisable = false;
      isSaveDisable = true;
    });
  }

  void showEndTime() {
    setState(() {
      endTime = DateFormat('hh:mm:ss').format(DateTime.now()).toString();
    });
    calculateTimeDifference();
  }

  void calculateTimeDifference() {
    setState(() {
      var startTime = format.parse(this.startTime);
      var endTime = format.parse(this.endTime);

      var d = endTime.difference(startTime);

      timeDifference = d.toString();

      int minutes = d.inMinutes;

      this.minutes = minutes.toString();

      this.minutes = minutes.toString();
      calculateCost(minutes);
    });
  }

  void calculateCost(int minutes) async {
    setState(() {
      this.costToPay = (minutes * costRate!).toString();
      isSaveDisable = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Calculation"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: 250,
            // color: Colors.red,
            child: ListView(
              children: [
                Text(
                  "Start Time: " + startTime.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "End Time: " + endTime.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "Total Time: " + timeDifference.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "Cost Rate: " + costRate.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  minutes + " minutes",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                SizedBox(height: 40),
                Text(
                  "Rs. " + costToPay,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        
                        textColor: isStartDisable ? Colors.grey : Colors.red,
                        shape: OutlineInputBorder(
                          borderSide: BorderSide(color: isStartDisable? disableBorderColor : Colors.red, width: 2),
                        ),
                        
                        height: 60,
                        minWidth: 110,
                        onPressed: isStartDisable ? null : showStartTime,
                        child: Text(
                          "Start Time",
                        ),
                      ),
                      MaterialButton(
                        textColor: isEndDisable ? Colors.grey : Colors.red,
                          shape: OutlineInputBorder(
                            borderSide: BorderSide(color: isEndDisable? disableBorderColor : Colors.red, width: 2),
                          ),
                         
                          height: 60,
                          minWidth: 110,
                          onPressed: isEndDisable ? null : showEndTime,
                          child: Text(
                            "End Time",
                            
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                MaterialButton(
                    shape: OutlineInputBorder(
                      borderSide: BorderSide(color: isSaveDisable? disableBorderColor : Colors.red, width: 2),
                    ),
                    textColor: Colors.red,
                    disabledTextColor: Colors.grey,
                    height: 60,
                    minWidth: 150,
                    onPressed: isSaveDisable ? null : createDialog,
                    child: Text(
                      "Save",
                      
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void insertRecord(fullName, contact, startTime, endTime, duration, totalCost,
      paidAmount, dueAmount) async {
    String date = NepaliDateFormat.yMd().format(NepaliDateTime.now()).toString();
    await databaseHelper.insert(date, fullName, contact, startTime, endTime,
        duration, totalCost, paidAmount, dueAmount);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCostRate();
  }

  createDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            content: Column(
              children: [
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Full name",
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: _contactController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Contact",
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: _paidAmountController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Paid Amount",
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              MaterialButton(
                  height: 40,
                  minWidth: 60,
                  color: Colors.red,
                  onPressed: () {
                    String fullName = _fullNameController.text;
                    String contact = _contactController.text;

                    int duration = int.parse(minutes);
                    double totalCost = double.parse(costToPay);
                    double paidAmount;
                    if (_paidAmountController.text.isEmpty) {
                      paidAmount = 0;
                    } else {
                      paidAmount = double.parse(_paidAmountController.text);
                    }

                    double dueAmount = totalCost - paidAmount;

                    insertRecord(fullName, contact, startTime, endTime,
                        duration, totalCost, paidAmount, dueAmount);

                    setState(() {
                      isStartDisable = false;
                      isEndDisable = true;
                      isSaveDisable = true;
                    });

                    Navigator.pop(context);
                  },
                  child: Text(
                    "Done",
                    style: TextStyle(color: Colors.white),
                  )),
              MaterialButton(
                  height: 40,
                  minWidth: 50,
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }
}
