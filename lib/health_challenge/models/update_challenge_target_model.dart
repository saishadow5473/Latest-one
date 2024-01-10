import 'package:intl/intl.dart';

class UpdateChallengeTarget {
  UpdateChallengeTarget(
      {this.enrollmentId,
      this.progressStatus,
      this.achieved,
      this.duration,
      this.email,
      this.certificateBase64,
      this.certificatePngBase64,
      this.firstTime,
      this.challengeEndTime});

  final String enrollmentId,
      progressStatus,
      achieved,
      duration,
      email,
      certificateBase64,
      certificatePngBase64;
  bool firstTime = false;
  DateTime challengeEndTime;
  factory UpdateChallengeTarget.fromJson(Map<String, dynamic> json) => UpdateChallengeTarget(
      enrollmentId: json["enrollment_id"],
      progressStatus: json["progress_status"],
      achieved: json["achieved"],
      duration: json["duration"],
      email: json["email"],
      certificateBase64: json["certificate_base64"],
      certificatePngBase64: json["certificate_png_base64"]);

  Map<String, dynamic> toJson() => firstTime
      ? {
          "enrollment_id": enrollmentId,
          "progress_status": "progressing",
          "achieved": "0",
          "duration": "0",
          "user_start_time": DateFormat('MM/dd/yyyy HH:mm:ss').format(DateTime.now()),
          "challenge_type":
              "Step Challenge" //TODO dynamic challenge need challenge type now hard coded the challenge type
        }
      : progressStatus == 'progressing'
          ? {
              "enrollment_id": enrollmentId,
              "progress_status": "progressing",
              "achieved": achieved,
              "duration": duration,
              "challenge_type":
                  "Step Challenge" //TODO dynamic challenge need challenge type now hard coded the challenge type
            }
          : {
              "enrollment_id": enrollmentId,
              "progress_status": "completed",
              "achieved": achieved,
              "duration": duration,
              "email": email,
              "certificate_base64": certificateBase64,
              "certificate_png_base64": certificatePngBase64,
              "user_end_time": DateFormat('MM/dd/yyyy HH:mm:ss').format(DateTime.now()),
              "challenge_type":
                  "Step Challenge" //TODO dynamic challenge need challenge type now hard coded the challenge type
            };
}
