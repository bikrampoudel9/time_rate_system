import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  var costController = TextEditingController();
  Future _onPressed() async {
    String cpm = costController.text;
    if(cpm.isEmpty)
    {
      Fluttertoast.showToast(
        msg: "Empty Field!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 15,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM
      );
      return;
    }
    try{
        var prefs = await SharedPreferences.getInstance();
        await prefs.setDouble("cost", double.parse(cpm));
        
        Fluttertoast.showToast(
        msg: "Saved",
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 15,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM
      );

      costController.clear();
        
    }
    catch(Exception)
    {
      Fluttertoast.showToast(
        msg: "Invalid Number",
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 15,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM
      );
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Calculation"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Enter Cost Per Minute"),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 150,
                height: 30,
                child: TextField(
                  textAlign: TextAlign.start,
                  controller: costController,
                  
                  style: TextStyle(
                    fontSize:15,
                                        
                  ),
                  decoration: InputDecoration(
                      hintText: "enter here",
                      hintStyle: TextStyle(fontSize: 10),
                      
                      enabledBorder: OutlineInputBorder(
                        
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red,)
                      )        
                    ),
                  
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed:_onPressed,
                child: Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
