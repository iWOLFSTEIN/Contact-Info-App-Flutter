import 'package:alert/alert.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
// import 'package:flutter_dropdown_alert/alert_controller.dart';
// import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:info_app/UserModel.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class InfoScreen extends StatefulWidget {
  InfoScreen({Key? key}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  //BackendServices backendServices = BackendServices();
  TextEditingController textEditingController = TextEditingController();
  //TextEditingController textEditingController1 = TextEditingController();
  // String? selectedGender = 'Boy';
  bool uploading = false;
  // Record1? _record1;
  // var userModel;

  List<Widget>? userModelList = [];

  getUserData({var mobileNumber}) async {
    var apiUrl = Uri.parse("http://esimdata.ga/api/?data=$mobileNumber");
    var response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(response.statusCode);
      return data;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = (height + width) / 4;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: uploading,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height / 2.2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 2 / 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Get Number Info',
                        style: TextStyle(
                            fontSize: size * 9 / 100,
                            fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                            hintText: '3xxxxxxxxx',
                            prefixIcon: Icon(Icons.smartphone)),
                      ),
                      Container(
                        width: width,
                        height: height * 6 / 100,
                        child: ElevatedButton(
                            onPressed: () async {
                              try {
                                if (!(textEditingController.text == '')) {
                                  setState(() {
                                    uploading = true;
                                    userModelList = [];
                                  });
                                  var data = await getUserData(
                                      mobileNumber: textEditingController.text);

                                  try {
                                    data['Record 1'].forEach((key, value) {
                                      var widget = dataItem(
                                          '${key[0].toUpperCase()}${key.substring(1)}:',
                                          size,
                                          width,
                                          (value == null || value == "")
                                              ? "N/A"
                                              : value);
                                      userModelList!.add(widget);
                                    });
                                  } catch (e) {}

                                  print(userModelList);
                                  setState(() {
                                    uploading = false;
                                  });
                                } else {
                                  Alert(
                                    message: "Enter a valid number!",
                                  ).show();
                                }
                              } catch (e) {
                                setState(() {
                                  uploading = false;
                                });

                                Alert(message: e.toString()
                                        // "An error occurred!"
                                        )
                                    .show();
                                print(e.toString());
                              }
                            },
                            child: Text(
                              'Get',
                              style: TextStyle(
                                  fontSize: size * 6 / 100,
                                  color: Colors.white),
                            )),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 2 / 100),
                child: (userModelList == null || listEquals(userModelList, []))
                    ? (uploading)
                        ? Container()
                        : Center(
                            child: Text('No Data is Available!'),
                          )
                    : Column(
                        children: userModelList!,
                      ),
              )
            ],
          ),
        )),
      ),
    );
  }

  dataItem(String key, double size, double width, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
            maxLines: 2,
            style: TextStyle(
                fontSize: size * 6.5 / 100, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: width * 2 / 100,
          ),
          Expanded(
            child: Container(
              child: Text(
                value,
                maxLines: 2,
                style: TextStyle(
                  fontSize: size * 6.5 / 100,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
