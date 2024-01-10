import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:get/get.dart';
import '../../../../health_challenge/models/challenge_detail.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../app/utils/appText.dart';
import '../dashboard/common_screen_for_navigation.dart';


class SetRemainderScreen extends StatelessWidget {
  ChallengeDetail challengeDetail;
  final List<String> sessionList;
  SetRemainderScreen({Key key, this.sessionList, this.challengeDetail}) : super(key: key);
  // final ClockController _calController = Get.put(ClendarController());
  @override
  Widget build(BuildContext context) {
    TimeOfDay _selectedTime = TimeOfDay.now();

    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Colors.blue, // Customize primary color
              accentColor: Colors.blue, // Customize accent color
              backgroundColor: Colors.white, // Customize background color
              textTheme: const TextTheme(
                bodyText1: TextStyle(color: Colors.blue), // Customize text color
                subtitle1: TextStyle(color: Colors.blue), // Customize text color
              ),
            ),
            child: child,
          );
        },
      );

      if (picked != null && picked != _selectedTime) {
        // setState(() {
        //   _selectedTime = picked;
        // });
      }
    }

    return CommonScreenForNavigation(
        resizeToAvoidBottomInset: true,
        contentColor: "true",
        appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () async {
                Get.back();
              }, //replaces the screen to Main dashboard
              color: Colors.white,
            ),
            title: Text(
              AppTexts.setAlarmText,
              style: AppTextStyles.appBarText,
            ),
            backgroundColor: AppColors.primaryColor),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 100.w,
            height: 100.h,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Day 5"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Visibility(
                    visible: sessionList.isNotEmpty,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                      child: SizedBox(
                        height: 6.h,
                        // width: 90.w,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: sessionList.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              return GestureDetector(
                                onTap: () {
                                  _selectTime(context);
                                },
                                child: Card(
                                  elevation: 3,
                                  margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.5.w),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 6.w),
                                    child: Text(sessionList[index],
                                        style: AppTextStyles.fontSize14b4RegularStyle),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: TimePickerDialog(
                    confirmText: "",
                    cancelText: "",
                    initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                  ),
                  // child: ClockCustomizer((ClockModel model) => AnalogClock(model)),
                ),
                Row(
                  children: [
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.0),
                      child: TextButton(child: Text("Cancel"), onPressed: null),
                    ),
                    TextButton(
                      child: Text("Set Alarm"),
                      onPressed: () {
                        FlutterAlarmClock.createAlarm(1, 15, title: "");
                      },
                    ),
                    SizedBox(width: 8.w)
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
