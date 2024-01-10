import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../constants/spKeys.dart';
import '../../../../../health_challenge/controllers/challenge_api.dart';
import '../../../../../health_challenge/models/challenge_detail.dart';
import '../../../../../health_challenge/models/enrolled_challenge.dart';
import '../../../../../health_challenge/models/join_individual.dart';
import '../../../../../views/gamification/dateutils.dart';
import '../../../../../views/splash_screen.dart';
import '../../../../data/functions/healthChallengeFunctions.dart';

class SessionSelectionController extends GetxController {
  RxInt isDaySelected = 0.obs;
  RxInt isSessionSelected = 0.obs;
  RxBool isRemainderActive = false.obs;
  String dateUpdateId = 'DateUpdate', dayTextUpdate = 'DayTextUpdate';
  String selectedDate, selectedTime = '00:00:00', selectedDay = 'Day 1';
  bool challengeEnrolled = false;
  var dateList = [];
  EnrolledChallenge challengeEnrollDetail;
  var userLogData = [];
  UserDetails userDetails;
  updateDayTextValue(String v) {
    selectedDay = v;
    update([dayTextUpdate]);
  }

  @override
  void onInit() {
    super.onInit();
    userDetails = UserDetails(
        userId: '',
        name: '',
        city: '',
        gender: '',
        department: '',
        designation: '',
        isGloble: null,
        email: '',
        userStartLocation: '',
        selected_fitness_app: '');
    print(userDetails);
  }

  Future<void> firstDateGetter(
      EnrolledChallenge enrollChallenge, ChallengeDetail challengeDetail) async {
    DateTime _startDate;
    if (challengeDetail.challengeStartTime.isSameDate(DateTime(2000, 01, 01))) {
      _startDate = convertTimestampToDateTime(int.tryParse(challengeDetail.challengeCreatedTime));
    } else {
      _startDate = challengeDetail.challengeStartTime;
    }
    enrollChallenge != null
        ? userLogData = await ChallengeApi().getLogUserDetails(
            enrolId: enrollChallenge.enrollmentId,
            startDate: _startDate,
          )
        : null;
    generateDateandStore(challengeDetail: challengeDetail);
  }

  DateTime convertTimestampToDateTime(int timestamp) {
    // Create a DateTime object from the timestamp
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return dateTime;
  }

  void generateDateandStore({ChallengeDetail challengeDetail}) {
    if (challengeDetail.challengeStartTime.isSameDate(DateTime(2000, 01, 01)) &&
        userLogData.isEmpty) {
      challengeDetail.challengeStartTime = DateTime.now();
    } else if (challengeDetail.challengeStartTime.isSameDate(DateTime(2000, 01, 01)) &&
        userLogData.isNotEmpty) {
      userLogData.sort((a, b) {
        DateTime timeA = DateFormat('MM/dd/yyyy').parse(a["log_time"]);
        DateTime timeB = DateFormat('MM/dd/yyyy').parse(b["log_time"]);
        return timeA.compareTo(timeB);
      });
      challengeDetail.challengeStartTime =
          DateFormat('MM/dd/yyyy').parse(userLogData[0]["log_time"]);
    }
    dateList = HealthChallengeFunctions.generateDateList(
        challengeDetail.challengeStartTime, int.tryParse(challengeDetail.challengeDurationDays));
    update([dateUpdateId]);
  }

  updateDaySelection(int index) {
    isDaySelected.value = index;
    update(["Day Card"]);
  }

  updateRemainder(bool remainderValue) {
    isRemainderActive.value = remainderValue;
    update(["Remainder"]);
  }

  updateSessionSelection(int index) {
    isSessionSelected.value = index;
    update(["Session Card"]);
  }

  checkChallengeIsEnrolled(String challengeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("ihlUserId");

    List<EnrolledChallenge> enList =
        await ChallengeApi().listofUserEnrolledChallenges(userId: userId);
    if (enList.isNotEmpty) {
      for (EnrolledChallenge i in enList) {
        if (i.challengeId == challengeId) {
          challengeEnrolled = true;
          challengeEnrollDetail = i;
        }
      }
    }
    update(["Enroll detail"]);
  }
}
