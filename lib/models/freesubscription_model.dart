// To parse this JSON data, do
//
//     final freeSubscription = freeSubscriptionFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

FreeSubscription freeSubscriptionFromJson(String str) =>
    FreeSubscription.fromJson(json.decode(str));

String freeSubscriptionToJson(FreeSubscription data) => json.encode(data.toJson());

class FreeSubscription {
  FreeSubscription({
    @required this.userIhlId,
    @required this.consultationId,
    @required this.courseImgUrl,
    @required this.title,
    @required this.courseId,
    @required this.courseType,
    @required this.provider,
    @required this.feesFor,
    @required this.availableSlotCount,
    @required this.subscriberCount,
    @required this.courseDuration,
    @required this.availableSlot,
    @required this.courseTime,
    @required this.courseOn,
    @required this.reasonForVisit,
    @required this.name,
    @required this.email,
    @required this.mobileNumber,
    @required this.approvalStatus,
    @required this.className,
    @required this.purposeDetails,
    @required this.affiliationUniqueName,
    @required this.userMobileNumber,
    @required this.userEmail,
    @required this.date,
    @required this.time,
    @required this.transactionMode,
    @required this.serviceProvidedDate,
    @required this.consultantName,
  });

  final String userIhlId,
      appointmentDateTime = '',
      consultationId,
      courseImgUrl,
      title,
      courseId,
      courseType,
      provider,
      feesFor,
      availableSlotCount,
      subscriberCount,
      courseDuration,
      courseStatus = '',
      reasonForVisit,
      name,
      email,
      mobileNumber,
      approvalStatus,
      category = '',
      mrpCost = '',
      totalAmount = '0',
      discounts = '',
      className,
      purposeDetails,
      kioskPurposeDetails = '',
      affiliationUniqueName,
      organizationUniqueName = '',
      organizationCode = '',
      discountType = '',
      couponNumber = '',
      userMobileNumber,
      userEmail,
      sourceDevice = 'mobile_app',
      serviceProvided = 'false',
      prescriptionPrint = '',
      status = '',
      approvalCode = '',
      applicationId = '',
      batchNumber = '',
      billNumber = '',
      cardNumber = '',
      cardType = '',
      cid = '',
      currency = '',
      date,
      invoiceNumber = '',
      merchantId = '',
      retrievalReferenceNumber = '',
      stan = '',
      statusCode = '',
      terminalId = '',
      time,
      transactionId = '',
      transactionMode,
      tsi = '',
      tvr = '',
      usageType = 'Free',
      mosambeeTransactionId = '',
      razorpayQrCodeId = '',
      razorpayQrPaymentIds = '',
      razorpayQrPaymentStatus = '',
      purpose = 'online_class',
      razorpayOrderId = '',
      razorpayPaymentId = '',
      razorpaySignature = '',
      paymentStatus = 'completed',
      refundInitiated = '',
      accountName = '',
      serviceProvidedDate,
      isNotIhlBillable = '',
      courseTime;
  int courseFees = 0;
  String consultantName;
  var availableSlot, courseOn;
  Map lastCheckinServices = {};

  factory FreeSubscription.fromJson(Map<String, dynamic> json) => FreeSubscription(
      userIhlId: json["user_ihl_id"],
      consultationId: json["consultation_id"],
      courseImgUrl: json["course_img_url"],
      title: json["title"],
      courseId: json["course_id"],
      courseType: json["course_type"],
      provider: json["provider"],
      feesFor: json["fees_for"],
      availableSlotCount: json["available_slot_count"],
      subscriberCount: json["subscriber_count"],
      courseDuration: json["course_duration"],
      availableSlot: List<dynamic>.from(json["available_slot"].map((x) => x)),
      courseTime: json["course_time"],
      courseOn: json["course_on"],
      reasonForVisit: json["reason_for_visit"],
      name: json["name"],
      email: json["email"],
      mobileNumber: json["mobile_number"],
      approvalStatus: json["approval_status"],
      className: json["ClassName"],
      purposeDetails: json["PurposeDetails"],
      affiliationUniqueName: json["affiliation_unique_name"],
      userMobileNumber: json["user_mobile_number"],
      userEmail: json["user_email"],
      date: json["date"],
      time: json["time"],
      transactionMode: json["transactionMode"],
      serviceProvidedDate: json["service_provided_date"],
      consultantName: json["consultant_name"]);

  Map<String, dynamic> toJson() => {
        "user_ihl_id": userIhlId,
        "appointment_date_time": appointmentDateTime,
        "consultation_id": consultationId,
        "course_img_url": courseImgUrl,
        "title": title,
        "course_id": courseId,
        "course_type": courseType,
        "provider": provider,
        "fees_for": feesFor,
        "course_fees": courseFees,
        "available_slot_count": availableSlotCount,
        "subscriber_count": subscriberCount,
        "course_duration": courseDuration,
        "available_slot": availableSlot,
        "course_status": courseStatus,
        "course_time": courseTime,
        "course_on": courseOn,
        "reason_for_visit": reasonForVisit,
        "name": name,
        "email": email,
        "mobile_number": mobileNumber,
        "approval_status": approvalStatus,
        "category": category,
        "MRPCost": mrpCost,
        "TotalAmount": totalAmount,
        "Discounts": discounts,
        "ClassName": className,
        "PurposeDetails": purposeDetails,
        "Kiosk_purpose_details": kioskPurposeDetails,
        "AffilationUniqueName": affiliationUniqueName,
        "OrganizationUniqueName": organizationUniqueName,
        "OrganizationCode": organizationCode,
        "last_checkin_services": lastCheckinServices,
        "DiscountType": discountType,
        "CouponNumber": couponNumber,
        "user_mobile_number": userMobileNumber,
        "user_email": userEmail,
        "SourceDevice": sourceDevice,
        "Service_Provided": serviceProvided,
        "prescription_print": prescriptionPrint,
        "Status": status,
        "approvalCode": approvalCode,
        "applicationId": applicationId,
        "batchNumber": batchNumber,
        "billNumber": billNumber,
        "cardNumber": cardNumber,
        "cardType": cardType,
        "cid": cid,
        "currency": currency,
        "date": date,
        "invoiceNumber": invoiceNumber,
        "merchantId": merchantId,
        "retrievalReferenceNumber": retrievalReferenceNumber,
        "Stan": stan,
        "statusCode": statusCode,
        "terminalId": terminalId,
        "time": time,
        "transactionId": transactionId,
        "transactionMode": transactionMode,
        "tsi": tsi,
        "tvr": tvr,
        "UsageType": usageType,
        "mosambee_transaction_id": mosambeeTransactionId,
        "razorpay_qr_code_id": razorpayQrCodeId,
        "razorpay_qr_payment_ids": razorpayQrPaymentIds,
        "razorpay_qr_payment_status": razorpayQrPaymentStatus,
        "purpose": purpose,
        "razorpay_order_id": razorpayOrderId,
        "razorpay_payment_id": razorpayPaymentId,
        "razorpay_signature": razorpaySignature,
        "payment_status": paymentStatus,
        "refund_initiated": refundInitiated,
        "account_name": accountName,
        "service_provided_date": serviceProvidedDate,
        "isNotIhlBillable": isNotIhlBillable,
        "consultantName ": consultantName
      };
}