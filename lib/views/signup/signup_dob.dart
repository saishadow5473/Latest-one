import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import '../../utils/ScUtil.dart';
import '../../utils/SpUtil.dart';
import '../../utils/sizeConfig.dart';
import '../../constants/routes.dart';
import '../../constants/app_text.dart';
import '../../widgets/offline_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignupDob extends StatefulWidget {
  const SignupDob({Key key}) : super(key: key);

  @override
  _SignupDobState createState() => _SignupDobState();
}

class _SignupDobState extends State<SignupDob> {
  String _date = "Not set";
  bool notValidUser = false;
  bool _dateNotset = false;
  DateFormat newFormat = DateFormat("MM/dd/yyyy");

  void _initAsync() async {
    await SpUtil.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  @override
  Widget build(BuildContext context) {
    ScUtil.init(context, width: 360, height: 640, allowFontScaling: true);
    Widget _customButton() {
      return SizedBox(
        height: 60,
        child: GestureDetector(
          onTap: () {
            if (_date != "Not set") {
              if (isAdult(_date) == true) {
                if (mounted) {
                  setState(() {
                    notValidUser = false;
                  });
                }
                SpUtil.putString('dob', _date);
                Navigator.of(context).pushNamed(Routes.Sgender);
              } else {
                if (mounted) {
                  setState(() {
                    notValidUser = true;
                    _dateNotset = false;
                  });
                }
              }
            } else {
              if (mounted) {
                setState(() {
                  _dateNotset = true;
                });
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF19a9e5),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    AppTexts.continuee,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Poppins',
                        fontSize: ScUtil().setSp(16),
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return SafeArea(
      top: true,
      child: ConnectivityWidgetWrapper(
        disableInteraction: true,
        offlineWidget: OfflineWidget(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            // title: Padding(
            //   padding: const EdgeInsets.only(left: 20),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(10),
            //     child: Container(
            //       height: 5,
            //       child: LinearProgressIndicator(
            //         value: 0.625, // percent filled
            //         backgroundColor: Color(0xffDBEEFC),
            //       ),
            //     ),
            //   ),
            // ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pushNamed(Routes.Smob),
              color: Colors.black,
            ),
            actions: <Widget>[
              Visibility(
                visible: false,
                replacement: SizedBox(
                  width: 10.w,
                ),
                child: TextButton(
                  onPressed: () {
                    if (_date != "Not set") {
                      if (isAdult(_date) == true) {
                        if (mounted) {
                          setState(() {
                            notValidUser = false;
                          });
                        }
                        SpUtil.putString('dob', _date);
                        Navigator.of(context).pushNamed(Routes.Sgender);
                      } else {
                        if (mounted) {
                          setState(() {
                            notValidUser = true;
                            _dateNotset = false;
                          });
                        }
                      }
                    } else {
                      if (mounted) {
                        setState(() {
                          _dateNotset = true;
                        });
                      }
                    }
                    // if (_date != "Not set") {
                    //   SpUtil.putString('dob', _date);
                    //   Navigator.of(context).pushNamed(Routes.Sgender);
                    // } else {
                    //   if (this.mounted) {
                    //     setState(() {
                    //       _dateNotset = true;
                    //     });
                    //   }
                    // }
                  },
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      color: Color(0xFF19a9e5),
                    ),
                    shape: const CircleBorder(side: BorderSide(color: Colors.transparent)),
                  ),
                  child: Text(AppTexts.next,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: ScUtil().setSp(16),
                      )),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xffF4F6FA),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 5.0,
                ),
                // Text(
                //   AppTexts.step5,
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //       color: Color(0xFF19a9e5),
                //       fontFamily: 'Poppins',
                //       fontSize: ScUtil().setSp(12),
                //       letterSpacing: 1.5,
                //       fontWeight: FontWeight.bold,
                //       height: 1.16),
                // ),
                SizedBox(
                  height: 6 * SizeConfig.heightMultiplier,
                ),
                Text(
                  AppTexts.dob,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: const Color.fromRGBO(109, 110, 113, 1),
                      fontFamily: 'Poppins',
                      fontSize: ScUtil().setSp(26),
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                      height: 1.33),
                ),
                SizedBox(
                  height: 3 * SizeConfig.heightMultiplier,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                  child: Text(
                    AppTexts.sub5,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: const Color.fromRGBO(109, 110, 113, 1),
                        fontFamily: 'Poppins',
                        fontSize: ScUtil().setSp(15),
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                ),
                SizedBox(
                  height: 6 * SizeConfig.heightMultiplier,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      elevation: 0.0,
                    ),
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          theme: const DatePickerTheme(
                            itemStyle: TextStyle(
                              color: Colors.black,
                            ),
                            cancelStyle: TextStyle(),
                            doneStyle: TextStyle(),
                            containerHeight: 210,
                          ),
                          showTitleActions: true,
                          minTime: DateTime(1900, 1, 1),
                          maxTime: DateTime.now(), onConfirm: (DateTime date) {
                        String updatedDt = newFormat.format(date);
                        _date = updatedDt; //"${date.toLocal()}".split(' ')[0];
                        if (mounted) {
                          setState(() {});
                        }
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 70.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.date_range,
                                      size: 18.0,
                                      color: Color(0xFF19a9e5),
                                    ),
                                    Text(
                                      " $_date",
                                      style: TextStyle(
                                          color: const Color(0xFF19a9e5),
                                          fontWeight: FontWeight.bold,
                                          fontSize: ScUtil().setSp(18)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Text(
                            "  Change",
                            style: TextStyle(
                                color: const Color(0xFF19a9e5),
                                fontWeight: FontWeight.bold,
                                fontSize: ScUtil().setSp(18)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _dateNotset == true
                    ? SizedBox(
                        height: 3 * SizeConfig.heightMultiplier,
                        child: const Text(
                          'Please enter your Date of Birth',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : notValidUser == true
                        ? SizedBox(
                            height: 3 * SizeConfig.heightMultiplier,
                            child: const Text(
                              'Attention! You need to be 13 years or older to register with hCare.',
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        : SizedBox(
                            height: 2 * SizeConfig.heightMultiplier,
                          ),
                SizedBox(
                  height: 4 * SizeConfig.heightMultiplier,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                  child: Center(
                    child: _customButton(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool isAdult(String birthDateString) {
  String datePattern = "MM/dd/yyyy";

  // Current time - at this moment
  DateTime today = DateTime.now();

  // Parsed date to check
  DateTime birthDate = DateFormat(datePattern).parse(birthDateString);

  // Date to check but moved 13 years + 3 leap days ahead
  DateTime adultDate = DateTime(
    birthDate.year + 13,
    birthDate.month,
    birthDate.day + 3,
  );

  return adultDate.isBefore(today);
}
