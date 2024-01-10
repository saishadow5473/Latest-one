import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../health_challenge/controllers/challenge_api.dart';
import '../../../../../health_challenge/models/challenge_detail.dart';
import '../../../../../health_challenge/models/enrolled_challenge.dart';
import '../../../../../views/gamification/dateutils.dart';
import '../../../../app/utils/appColors.dart';
import '../../../../../utils/app_text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ihl/new_design/data/functions/healthChallengeFunctions.dart';
import '../../../../app/utils/appText.dart';
import '../blocWidget/challengeBloc.dart';
import '../blocWidget/challengeEvents.dart';
import '../blocWidget/challengeState.dart';
import '../getX_widget_responsive/challange_ui_reponse.dart';
import '../remainder_screen.dart';

Widget onGoingchallengeLogDetails(
    BuildContext context, ChallengeDetail challengeDetail, EnrolledChallenge enrolledChallenge) {
  SessionSelectionController sessionSelectionController = Get.put(SessionSelectionController());
  List<String> sessionList = [];
  List<String> result;
  if (challengeDetail.challengeSessionDetail == "" && challengeDetail.challengeHourDetails == '') {
    sessionList = [];
  } else if (challengeDetail.challengeSessionDetail != "") {
    sessionList = challengeDetail.challengeSessionDetail.split(",");
  } else if (challengeDetail.challengeHourDetails != '') {
    result = HealthChallengeFunctions.splitTimeRange(challengeDetail.challengeHourDetails);

    for (var interval in result) {
      sessionList.add(interval);
    }
  } else {
    debugPrint(challengeDetail.challengeHourDetails);
    sessionList = [];
  }

  return Column(
    children: [
      Padding(
        padding: EdgeInsets.only(top: 3.h, left: 5.w),
        child: Row(
          children: <Widget>[
            Text(AppTexts.logActivityText, style: AppTextStyles.fontSize14V4RegularStyle),
            const Spacer()
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
        child: SizedBox(
          height: 6.h,
          // width: 90.w,
          child: GetBuilder<SessionSelectionController>(
              id: sessionSelectionController.dateUpdateId,
              initState: (v) {
                sessionSelectionController.firstDateGetter(enrolledChallenge, challengeDetail);
              },
              builder: (context) {
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: sessionSelectionController.dateList.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return GestureDetector(
                        onTap: () {
                          sessionSelectionController.updateDaySelection(index);
                          sessionSelectionController.selectedDate =
                              sessionSelectionController.dateList[index]['date'];
                          sessionSelectionController.updateDayTextValue(
                              sessionSelectionController.dateList[index]['day']);
                          debugPrint(sessionSelectionController.selectedDate);
                        },
                        child: Obx(() {
                          return Container(
                            decoration: BoxDecoration(
                                color: sessionSelectionController.isDaySelected.value == index
                                    ? AppColors.lightPrimaryColor
                                    : Colors.white,
                                shape: BoxShape.rectangle,
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 3,
                                      offset: const Offset(1, 1))
                                ]),
                            margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.5.w),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 6.w),
                              child: Text("Day ${index + 1}",
                                  style: AppTextStyles.fontSize14b4RegularStyle),
                            ),
                          );
                        }),
                      );
                    });
              }),
        ),
      ),
      sessionTile(
        sessionList,
      ),
      Padding(
        padding: EdgeInsets.only(top: 1.h, left: 5.w, bottom: 2.h),
        child: Row(
          children: <Widget>[
            Text("${AppTexts.enterNoText} ${challengeDetail.challengeUnit} spent:",
                style: AppTextStyles.fontSize14V4RegularStyle),
            const Spacer()
          ],
        ),
      ),
      SizedBox(
        height: 6.h,
        width: 42.w,
        child: TextField(
          textAlign: TextAlign.values[2],
          decoration: InputDecoration(
            hintText: challengeDetail.challengeUnit.capitalizeFirst,
            contentPadding: EdgeInsets.zero,
            hintStyle: AppTextStyles.fontSize14V4RegularStyle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ),

      ///button to submit the text field value
      Padding(
        padding: EdgeInsets.symmetric(vertical: 2.5.h),
        child: GestureDetector(
          onTap: () {
            Get.defaultDialog(
                barrierDismissible: false,
                onWillPop: () => null,
                backgroundColor: Colors.lightBlue.shade50,
                title: 'The challenge will commence once at least 2 participants join.',
                titlePadding: EdgeInsets.only(top: 18.sp, bottom: 0, left: 11.sp, right: 11.sp),
                titleStyle:
                    TextStyle(letterSpacing: 1, color: Colors.blue.shade400, fontSize: 19.sp),
                content: Column(
                  children: [
                    const Divider(
                      thickness: 2,
                    ),
                    Icon(
                      Icons.task_alt,
                      size: 40,
                      color: Colors.blue.shade300,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Get.offAll(HomeScreen(introDone: true),
                        //     transition: Transition.size);
                        Get.back();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 4,
                        decoration: BoxDecoration(
                            color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Ok',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ));
          },
          child: Container(
            height: 4.h,
            width: 25.w,
            decoration: BoxDecoration(
                color: AppColors.primaryAccentColor, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(
                "Submit",
                style: AppTextStyles.boldWhiteText,
              ),
            ),
          ),
        ),
      ),
      Visibility(
        visible: challengeDetail.challengeRemaider,
        child: SizedBox(
          height: 12.h,
          child: Card(
            elevation: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(
                  Icons.alarm,
                  color: AppColors.primaryColor,
                  size: 25.sp,
                ),
                SizedBox(
                    width: 55.w,
                    child: Text(AppTexts.askForRemainder,
                        style: AppTextStyles.fontSize14V5RegularStyle)),
                Obx(() {
                  return Switch(
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                      value: sessionSelectionController.isRemainderActive.value ?? false,
                      onChanged: (bool v) async {
                        sessionSelectionController.updateRemainder(v);
                        if (v) {
                          Get.to(SetRemainderScreen(
                              sessionList: sessionList, challengeDetail: challengeDetail));
                        }
                      });
                })
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget sessionTile(
  List<String> sessionList,
) {
  SessionSelectionController sessionSelectionController = Get.put(SessionSelectionController());
  // } catch (e) {
  //   if(sessionList.isNotEmpty)
  //   sessionSelectionController.selectedTime =
  //       HealthChallengeFunctions.findTimeForSession(sessionList[0]);
  // }
  return Visibility(
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
                  sessionSelectionController.updateSessionSelection(index);
                  try {
                    sessionSelectionController.selectedTime =
                        HealthChallengeFunctions.convertTimeFormat(sessionList[index]);
                  } catch (e) {
                    sessionSelectionController.selectedTime =
                        HealthChallengeFunctions.findTimeForSession(sessionList[index]);
                  }
                },
                child: Obx(() {
                  return Container(
                    // elevation: 3,
                    decoration: BoxDecoration(
                        color: sessionSelectionController.isSessionSelected.value == index
                            ? AppColors.lightPrimaryColor
                            : Colors.white,
                        shape: BoxShape.rectangle,
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 3,
                              offset: const Offset(1, 1))
                        ]),
                    margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.5.w),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 6.w),
                      child:
                          Text(sessionList[index], style: AppTextStyles.fontSize14b4RegularStyle),
                    ),
                  );
                }),
              );
            }),
      ),
    ),
  );
}
