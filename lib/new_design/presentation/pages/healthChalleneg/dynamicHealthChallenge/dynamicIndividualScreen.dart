import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../health_challenge/controllers/challenge_api.dart';
import '../../../../../health_challenge/models/challenge_detail.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../health_challenge/models/sendInviteUserForChallengeModel.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../app/utils/appText.dart';
import '../../../../data/functions/healthChallengeFunctions.dart';
import '../../../clippath/subscriptionTagClipPath.dart';
import '../../dashboard/common_screen_for_navigation.dart';
import '../blocWidget/challengeBloc.dart';
import '../blocWidget/challengeEvents.dart';
import '../blocWidget/challengeState.dart';
import '../widgets/on_going_challenge_widgets.dart';

class DynamicIndividualScreen extends StatelessWidget {
  final ChallengeDetail challengeDetail;
  DynamicIndividualScreen({Key key, this.challengeDetail}) : super(key: key);
  int invitedEmailCount = 5;
  PageController scrollController = PageController();

  TextEditingController _sendInviteEmailController = TextEditingController();
  String userName;
  RegExp emailRegExp =
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  emailValueCheck() {
    if (_sendInviteEmailController.value.text.isEmpty) {
      return null;
    } else if (!emailRegExp.hasMatch(_sendInviteEmailController.value.text)) {
      return "Invalid Email";
    } else
      return null;
  }

  calculateCompletedDate() {
    DateTime startDate = challengeDetail.challengeStartTime;
    DateTime endDate =
        startDate.add(Duration(days: int.parse(challengeDetail.challengeDurationDays)));
    print(DateFormat('dd MMM yyyy').format(endDate));
    return DateFormat('dd MMM yyyy').format(endDate);
  }

  checkReferInviteCount(String challengeID) async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    String refer_by_email = prefs1.getString("email");
    var response = await ChallengeApi()
        .challengeReferInviteCount(challangeId: challengeID, refer_by_email: refer_by_email);
    if (response != null) {
      try {
        invitedEmailCount = 5 - int.parse(response);
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    calculateCompletedDate();
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
              challengeDetail.challengeName,
              style: AppTextStyles.appBarText,
            ),
            backgroundColor: AppColors.primaryColor),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 100.w,
            // height: 100.h,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 27.h,
                        width: 95.w,
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 6)
                            ],
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(challengeDetail.challengeImgUrl))),
                      ),
                      Positioned(
                        top: .5.h,
                        child: SizedBox(
                          child: ClipPath(
                            clipper: SubscriptionClipPath(),
                            child: Container(
                              height: 2.7.h,
                              width: 20.w,
                              color: AppColors.primaryAccentColor,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text(
                                    "Day 1",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontSize: 10.sp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    width: 90.w,
                    child: Text(challengeDetail.challengeDescription.capitalizeFirst,
                        style: AppTextStyles.fontSize14b4RegularStyle)),

                onGoingchallengeLogDetails(
                    context, challengeDetail, null), //TODO need to pass enrollChallengeDetail
                Padding(
                  padding: EdgeInsets.only(top: 3.h, left: 5.w),
                  child: Row(
                    children: <Widget>[
                      Text(AppTexts.yourInsightTex, style: AppTextStyles.fontSize14V4RegularStyle),
                      const Spacer()
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () => scrollController.previousPage(
                            duration: const Duration(
                              milliseconds: 1500,
                            ),
                            curve: Curves.easeInOut),
                        child: const Icon(Icons.arrow_left_outlined)),
                    SizedBox(
                      height: 15.h,
                      width: 85.w,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: scrollController,
                          itemCount: int.parse(challengeDetail.challengeDurationDays ?? "0"),
                          itemBuilder: (BuildContext ctx, int index) {
                            return Column(
                              children: [
                                Text("Day ${index + 1}",
                                    style: AppTextStyles.fontSize14b4RegularStyle),
                                Container(
                                  height: 9.h,
                                  width: 15.w,
                                  decoration: BoxDecoration(
                                      color: AppColors.greenColor.withOpacity(0.75),
                                      borderRadius: BorderRadius.circular(1)),
                                  margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.5.w),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                                    child: Text("20\n${challengeDetail.challengeUnit}",
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.contentSmallText),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                    GestureDetector(
                        onTap: () {
                          scrollController.nextPage(
                              duration: const Duration(milliseconds: 1500),
                              curve: Curves.easeInOut);
                        },
                        child: const Icon(Icons.arrow_right_outlined)),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
                    children: [
                      Container(
                        height: 7.h,
                        width: 95.w,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          boxShadow: [
                            BoxShadow(color: Colors.grey, offset: Offset(3, 3), blurRadius: 6)
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 1,
                            ),
                            Text(
                                challengeDetail.challengeMode == "individual"
                                    ? "Send invite"
                                    : "Send invite",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                            // Expanded(
                            //   flex: 1,
                            //   child: Icon(
                            //     Icons.play_arrow,
                            //     color: Colors.white,
                            //   ),
                            // )
                            const SizedBox(
                              width: 1,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // height: 15.h,
                        width: 95.w,
                        decoration: const BoxDecoration(
                          color: AppColors.appBackgroundColor,
                          boxShadow: [
                            BoxShadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 6)
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Invite up-to 5 family members\n ($invitedEmailCount/5 invite left)",
                              style: TextStyle(
                                  fontSize: height > 568 ? 14.sp : 16.sp,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  color: Colors.blueGrey),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              // padding:  EdgeInsets.only(left: 3.w,right: 3.w),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),

                              child: Material(
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                elevation: 2,
                                child: TextField(
                                  controller: _sendInviteEmailController,
                                  //keyboardType: TextInputType.emailAddress,
                                  // inputFormatters: [
                                  //   FilteringTextInputFormatter.allow(
                                  //       RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                                  // ],
                                  decoration: InputDecoration(
                                    // suffixIcon: Icon(
                                    //   Icons.edit,
                                    //   color: Colors.black45,
                                    // ),
                                    errorText: emailValueCheck(),

                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                                    hintText: "Email of friends/family member",
                                    hintStyle: TextStyle(color: Colors.black26, fontSize: 16.sp),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 0.5.h,
                            ),
                            SizedBox(
                              height: 5.h,
                              width: 30.w,
                              child: ElevatedButton(
                                child: Text('Invite',
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        fontFamily: 'Popins',
                                        color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  primary: invitedEmailCount == 5
                                      ? AppColors.primaryAccentColor
                                      : (!_sendInviteEmailController.value.text.isEmpty &&
                                              !_sendInviteEmailController.value.text.isEmpty &&
                                              emailRegExp
                                                  .hasMatch(_sendInviteEmailController.value.text))
                                          ? AppColors.primaryAccentColor
                                          : Colors.grey,
                                ),
                                onPressed: () {
                                  if (!_sendInviteEmailController.value.text.isEmpty &&
                                      emailRegExp.hasMatch(_sendInviteEmailController.value.text)) {
                                    HealthChallengeFunctions.inviteThroughEmailApiCall(
                                        challengeDetail.challengeId,
                                        '',
                                        _sendInviteEmailController.value.text,
                                        invitedEmailCount,
                                        _sendInviteEmailController);
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                " By inviting your friends / family members will receive an welcome Email to download hCare APP subsequently, when they register with same Email Id they get access to this challenge.",
                                style: TextStyle(
                                    fontSize: 12.5.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                    color: Colors.blueGrey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                )
              ],
            ),
          ),
        ));
  }
}
