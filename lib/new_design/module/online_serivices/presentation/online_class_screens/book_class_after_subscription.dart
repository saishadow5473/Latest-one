import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../Modules/online_class/about_class.dart';
import '../../../../../Modules/online_class/bloc/trainer_status/bloc/trainer_bloc.dart';
import '../../../../../Modules/online_class/presentation/pages/reviews_and_ratings.dart';
import '../../../../../Modules/online_class/presentation/widgets/join_call_widget.dart';
import '../../../../app/utils/appColors.dart';
import '../../../../app/utils/textStyle.dart';
import '../../../../data/providers/network/apis/classImageApi/classImageApi.dart';
import '../../../../presentation/clippath/subscriptionTagClipPath.dart';
import '../../../../presentation/pages/dashboard/common_screen_for_navigation.dart';
import '../../bloc/search_animation_bloc/courseDetailBloc/courseDetailBloc.dart';
import '../../data/model/get_subscribtion_list.dart';
import '../../functionalities/online_services_dashboard_functionalities.dart';

class BookClassAfterSubscription extends StatelessWidget {
  Subscription classDetail;
  BookClassAfterSubscription({Key key, @required this.classDetail}) : super(key: key);
  final OnlineServicesFunctions _onlineServicesFunction = OnlineServicesFunctions();
  @override
  Widget build(BuildContext context) {
    // Assuming _onlineServicesFunction is an instance of the class containing the parseCourseDurationYYMMDD method.
    // classDetail is an instance of the class containing the courseDuration property.
    // Parse start and end dates
    final DateTime parseStartDate =
        _onlineServicesFunction.parseCourseDurationYYMMDD(classDetail.courseDuration)[0];
    final DateTime parseEndDate =
        _onlineServicesFunction.parseCourseDurationYYMMDD(classDetail.courseDuration)[1];

    // Create formatted date strings
    final String startDateString =
        "${parseStartDate.day}-${parseStartDate.month}-${parseStartDate.year}";
    final String endDateString = "${parseEndDate.day}-${parseEndDate.month}-${parseEndDate.year}";
    return BlocBuilder<CourseDetailBloc, CourseDetailState>(
        builder: (BuildContext context, CourseDetailState courseDetailState) {
      return CommonScreenForNavigation(
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            centerTitle: true,
            title: const Text("Class Detail", style: TextStyle(color: Colors.white)),
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Widget for Class Detail with join button
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:14.0,horizontal: 10.0),
                      child: Container(
                        height: 55.h,
                        width: 96.w,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                              child: Text(
                                classDetail.title.capitalizeFirst,
                                style: AppTextStyles.primaryColorText,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 82.w,
                                child: Column(children: [
                                  Row(
                                    children: [
                                      const Text("Trainer"),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Text(classDetail.consultantName)
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    children: [
                                      const Text("Duration"),
                                      SizedBox(
                                        width: 17.5.w,
                                      ),
                                      Text("$startDateString to $endDateString")
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  // Row(
                                  //   children: [
                                  //     const Text("Status"),
                                  //     SizedBox(
                                  //       width: 20.w,
                                  //     ),
                                  //     Text(classDetail.consultantName)
                                  //   ],
                                  // ),
                                  // const Divider(
                                  //   color: Colors.black,
                                  // ),
                                  Row(
                                    children: [
                                      const Text("Timings"),
                                      SizedBox(
                                        width: 18.w,
                                      ),
                                      Text(classDetail.courseTime)
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                ]),
                              ),
                            ),
                            BlocProvider(
                              create: (BuildContext context) =>
                                  TrainerBloc()..add(ListenTrainerStatusEvent(false)),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: joinCallwidget(
                                  subcriptionList: classDetail,
                                  ui: const Text('data'),
                                  noTime: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: ClassImage().getCourseImageURL([classDetail.courseId]),
                      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          List<String> image = snapshot.data[0]['base_64'].split(',');
                          Uint8List bytes1;
                          bytes1 = const Base64Decoder().convert(image[1].toString());
                          return bytes1 == null
                              ? const Placeholder()
                              : Padding(
                            padding: const EdgeInsets.only(top: 15, left: 12, right: 12),
                            child: Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 25.h,
                                      width: 94.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(1, 1),
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              color: Colors.grey.shade300)
                                        ],
                                        border: Border.all(
                                            width: 0.7.w,
                                            color: AppColors.primaryColor.withOpacity(0.2)),
                                        borderRadius:
                                        const BorderRadius.all(Radius.circular(8.0)),
                                        image: DecorationImage(
                                            image: Image.memory(
                                              base64Decode(image[1].toString()),
                                            ).image,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0, top: 6.0),
                                      child: SizedBox(
                                        child: ClipPath(
                                          clipper: SubscriptionClipPath(),
                                          child: Container(
                                            color: AppColors.primaryAccentColor,
                                            child: FittedBox(
                                              fit: BoxFit.fill,
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(10, 2, 8, 2),
                                                child: Text(
                                                  classDetail.feesFor,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Poppins',
                                                      fontSize: 13.sp),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 15, left: 12, right: 12),
                            child: Shimmer.fromColors(
                              direction: ShimmerDirection.ltr,
                              enabled: true,
                              baseColor: Colors.white,
                              highlightColor: Colors.grey.shade300,
                              child: Container(
                                height: 25.h,
                                width: 96.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 15, left: 12, right: 12),
                            child: Shimmer.fromColors(
                              direction: ShimmerDirection.ltr,
                              enabled: true,
                              baseColor: Colors.white,
                              highlightColor: Colors.grey.shade400,
                              child: Container(
                                height: 25.h,
                                width: 96.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 0.7.w,
                                      color: AppColors.primaryColor.withOpacity(0.2)),
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                                ),
                              ),
                            ),
                          );
                          // return Container(
                          //   child: Center(
                          //     child: CircularProgressIndicator(),
                          //   ),
                          // );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 15,left: 12, right: 12),
                          child: Shimmer.fromColors(
                            baseColor: Colors.white,
                            direction: ShimmerDirection.ltr,
                            highlightColor: Colors.grey.withOpacity(0.2),
                            child: Container(
                              height: 25.h,
                              width: 95.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.7.w,
                                    color: AppColors.primaryColor.withOpacity(0.2)),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                courseDetailState is CourseDetailLoadedState
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(AboutClass(
                              courseId: courseDetailState.courseDetail.courseId,
                              desc: courseDetailState.courseDetail.courseDescription,
                              title: courseDetailState.courseDetail.title,
                            ));
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            height: 10.h,
                            width: 96.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(20.w)),
                                    height: 12.w,
                                    width: 12.w,
                                    padding: const EdgeInsets.all(8),
                                    child: Image.asset(
                                      'newAssets/Icons/about class.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("About"),
                                      SizedBox(
                                          width: 55.w,
                                          child: Text(
                                              courseDetailState
                                                  .courseDetail.courseDescription.capitalizeFirst,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              maxLines: 1))
                                    ],
                                  ),
                                ),
                                const Spacer()
                              ],
                            ),
                          ),
                        ),
                      )
                    : courseDetailState is CourseDetailInitialState
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey.withOpacity(0.04),
                            highlightColor: AppColors.primaryColor.withOpacity(0.4),
                            child: Container(
                              height: 10.h,
                              width: 96.w,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(50),
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8)),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 4,
                                      offset: const Offset(1, 1),
                                      color: Colors.grey.shade400)
                                ],
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              height: 10.h,
                              width: 96.w,
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 2.w),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(20.w)),
                                    height: 12.w,
                                    width: 12.w,
                                    padding: const EdgeInsets.all(8),
                                    child: Image.asset(
                                      'newAssets/Icons/about class.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  courseDetailState is CourseDetailErrorState
                                      ? const Text("Server Error")
                                      : Container()
                                ],
                              ),
                            ),
                        ),
                SizedBox(
                  height: 1.h,
                ),
                courseDetailState is CourseDetailLoadedState
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                          onTap: () {
                            Get.to(ReviewsAndRatings(
                              ratings: courseDetailState.courseDetail.ratings.toString(),
                              ratingsList: courseDetailState.courseDetail.textReviewsData,
                            ));
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            height: 10.h,
                            width: 96.w,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(20.w)),
                                    height: 12.w,
                                    width: 12.w,
                                    padding: const EdgeInsets.all(8),
                                    child: Image.asset(
                                      'newAssets/Icons/class rating.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Reviews & Ratings"),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      SizedBox(
                                        width: 55.w,
                                        child: RatingBar.builder(
                                          ignoreGestures: true,
                                          initialRating:
                                              courseDetailState.courseDetail.ratings.toDouble(),
                                          minRating: 0,
                                          itemSize: 2.5.h,
                                          direction: Axis.horizontal,
                                          allowHalfRating: false,
                                          itemCount: 5,
                                          itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                          itemBuilder: (BuildContext context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.amberAccent,
                                          ),
                                          onRatingUpdate: (double value) {},
                                        ),
                                        // child: Text(courseDetailState.courseDetail.courseDescription,
                                        //     softWrap: false,maxLines:1)
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer()
                              ],
                            ),
                          ),
                        ),
                    )
                    : courseDetailState is CourseDetailInitialState
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey.withOpacity(0.04),
                            highlightColor: AppColors.primaryColor.withOpacity(0.4),
                            child: Container(
                              height: 10.h,
                              width: 96.w,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(50),
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8)),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 4,
                                      offset: const Offset(1, 1),
                                      color: Colors.grey.shade400)
                                ],
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            height: 10.h,
                            width: 96.w,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(width: 2.w),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(20.w)),
                                  height: 12.w,
                                  width: 12.w,
                                  padding: const EdgeInsets.all(8),
                                  child: Image.asset(
                                    'newAssets/Icons/class rating.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                courseDetailState is CourseDetailErrorState
                                    ? const Text("Server Error")
                                    : Container()
                              ],
                            ),
                          ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ));
    });
  }
}
