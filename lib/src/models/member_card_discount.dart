import 'dart:convert';

import 'package:point_of_sale/src/models/customer_model.dart';

MemberCardDiscount memberCardDiscountFromJson(String str) =>
    MemberCardDiscount.fromJson(json.decode(str));

String memberCardDiscountToJson(MemberCardDiscount data) =>
    json.encode(data.toJson());

class MemberCardDiscount {
  MemberCardDiscount({
    this.data,
    this.items,
    this.action,
    this.isRejected,
    this.isAlerted,
    this.isApproved,
    this.count,
    this.redirect,
  });

  final Data data;
  final Items items;
  final int action;
  final bool isRejected;
  final bool isAlerted;
  final bool isApproved;
  final int count;
  final dynamic redirect;

  factory MemberCardDiscount.fromJson(Map<String, dynamic> json) =>
      MemberCardDiscount(
        data: Data.fromJson(json["Data"]),
        items: Items.fromJson(json["Items"]) ?? "",
        action: json["Action"],
        isRejected: json["IsRejected"],
        isAlerted: json["IsAlerted"],
        isApproved: json["IsApproved"],
        count: json["Count"],
        redirect: json["Redirect"],
      );

  Map<String, dynamic> toJson() => {
        "Data": data.toJson(),
        "Items": items.toJson(),
        "Action": action,
        "IsRejected": isRejected,
        "IsAlerted": isAlerted,
        "IsApproved": isApproved,
        "Count": count,
        "Redirect": redirect,
      };
}

class Data {
  Data({
    this.message,
  });

  final String message;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        message: json["Message"],
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
      };
}

class Items {
  Items({
    this.data,
  });

  final DataClass data;

  factory Items.fromJson(Map<String, dynamic> json) => Items(
        data: DataClass.fromJson(json["data"]) ?? "",
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class DataClass {
  DataClass({
    this.id,
    this.typeCardId,
    this.name,
    this.code,
    this.description,
    this.expireDateFrom,
    this.expireDateTo,
    this.lengthExpireCard,
    this.active,
    this.customer,
    this.discount,
    this.typeDiscount,
  });

  final int id;
  final int typeCardId;
  final String name;
  final String code;
  final dynamic description;
  final DateTime expireDateFrom;
  final DateTime expireDateTo;
  final int lengthExpireCard;
  final bool active;
  final Customer customer;
  final double discount;
  final int typeDiscount;

  factory DataClass.fromJson(Map<String, dynamic> json) => DataClass(
        id: json["ID"] ?? "",
        typeCardId: json["TypeCardID"] ?? "",
        name: json["Name"] ?? "",
        code: json["Code"] ?? "",
        description: json["Description"] ?? "",
        expireDateFrom: DateTime.parse(json["ExpireDateFrom"]) ?? "",
        expireDateTo: DateTime.parse(json["ExpireDateTo"]) ?? "",
        lengthExpireCard: json["LengthExpireCard"] ?? "",
        active: json["Active"] ?? "",
        customer: Customer.fromJson(json["Customer"]) ?? "",
        discount: json["Discount"] ?? "",
        typeDiscount: json["TypeDiscount"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "TypeCardID": typeCardId,
        "Name": name,
        "Code": code,
        "Description": description,
        "ExpireDateFrom": expireDateFrom.toIso8601String(),
        "ExpireDateTo": expireDateTo.toIso8601String(),
        "LengthExpireCard": lengthExpireCard,
        "Active": active,
        "Customer": customer.toJson(),
        "Discount": discount,
        "TypeDiscount": typeDiscount,
      };
}

// class Customer {
//   Customer({
//     this.id,
//     this.group1Id,
//     this.group2Id,
//     this.saleEmid,
//     this.vatNumber,
//     this.paymentTermsId,
//     this.gpSink,
//     this.creditLimit,
//     this.glAccId,
//     this.saleEmpName,
//     this.group1Name,
//     this.paymentCode,
//     this.instaillmentId,
//     this.group2Name,
//     this.code,
//     this.name,
//     this.name2,
//     this.cumulativePoint,
//     this.cardMemberId,
//     this.balance,
//     this.redeemedPoint,
//     this.outstandPoint,
//     this.birthDate,
//     this.type,
//     this.contactPerson,
//     this.daysInstail,
//     this.instiallment,
//     this.tel,
//     this.glCode,
//     this.instaillId,
//     this.glName,
//     this.actId,
//     this.priName,
//     this.priceListId,
//     this.phone,
//     this.months,
//     this.days,
//     this.email,
//     this.address,
//     this.delete,
//     this.autoMobile,
//     this.groupId,
//     this.activities,
//     this.point,
//     this.priceList,
//     this.contactPeople,
//     this.bpBranches,
//   });

//   final int id;
//   final int group1Id;
//   final int group2Id;
//   final int saleEmid;
//   final double vatNumber;
//   final int paymentTermsId;
//   final dynamic gpSink;
//   final double creditLimit;
//   final int glAccId;
//   final dynamic saleEmpName;
//   final dynamic group1Name;
//   final dynamic paymentCode;
//   final int instaillmentId;
//   final dynamic group2Name;
//   final String code;
//   final String name;
//   final String name2;
//   final double cumulativePoint;
//   final int cardMemberId;
//   final double balance;
//   final double redeemedPoint;
//   final double outstandPoint;
//   final DateTime birthDate;
//   final String type;
//   final dynamic contactPerson;
//   final dynamic daysInstail;
//   final dynamic instiallment;
//   final int tel;
//   final dynamic glCode;
//   final int instaillId;
//   final dynamic glName;
//   final int actId;
//   final dynamic priName;
//   final int priceListId;
//   final dynamic phone;
//   final int months;
//   final int days;
//   final dynamic email;
//   final dynamic address;
//   final bool delete;
//   final dynamic autoMobile;
//   final int groupId;
//   final int activities;
//   final bool point;
//   final dynamic priceList;
//   final dynamic contactPeople;
//   final dynamic bpBranches;

//   factory Customer.fromJson(Map<String, dynamic> json) => Customer(
//         id: json["ID"],
//         group1Id: json["Group1ID"],
//         group2Id: json["Group2ID"],
//         saleEmid: json["SaleEMID"],
//         vatNumber: json["VatNumber"],
//         paymentTermsId: json["PaymentTermsID"],
//         gpSink: json["GPSink"],
//         creditLimit: json["CreditLimit"],
//         glAccId: json["GLAccID"],
//         saleEmpName: json["SaleEmpName"],
//         group1Name: json["Group1Name"],
//         paymentCode: json["PaymentCode"],
//         instaillmentId: json["InstaillmentID"],
//         group2Name: json["Group2Name"],
//         code: json["Code"],
//         name: json["Name"],
//         name2: json["Name2"],
//         cumulativePoint: json["CumulativePoint"].toDouble(),
//         cardMemberId: json["CardMemberID"],
//         balance: json["Balance"],
//         redeemedPoint: json["RedeemedPoint"],
//         outstandPoint: json["OutstandPoint"].toDouble(),
//         birthDate: DateTime.parse(json["BirthDate"]),
//         type: json["Type"],
//         contactPerson: json["ContactPerson"],
//         daysInstail: json["DaysInstail"],
//         instiallment: json["Instiallment"],
//         tel: json["Tel"],
//         glCode: json["GLCode"],
//         instaillId: json["InstaillID"],
//         glName: json["GLName"],
//         actId: json["ActID"],
//         priName: json["PriName"],
//         priceListId: json["PriceListID"],
//         phone: json["Phone"],
//         months: json["Months"],
//         days: json["Days"],
//         email: json["Email"],
//         address: json["Address"],
//         delete: json["Delete"],
//         autoMobile: json["AutoMobile"],
//         groupId: json["GroupID"],
//         activities: json["Activities"],
//         point: json["Point"],
//         priceList: json["PriceList"],
//         contactPeople: json["ContactPeople"],
//         bpBranches: json["BPBranches"],
//       );

//   Map<String, dynamic> toJson() => {
//         "ID": id,
//         "Group1ID": group1Id,
//         "Group2ID": group2Id,
//         "SaleEMID": saleEmid,
//         "VatNumber": vatNumber,
//         "PaymentTermsID": paymentTermsId,
//         "GPSink": gpSink,
//         "CreditLimit": creditLimit,
//         "GLAccID": glAccId,
//         "SaleEmpName": saleEmpName,
//         "Group1Name": group1Name,
//         "PaymentCode": paymentCode,
//         "InstaillmentID": instaillmentId,
//         "Group2Name": group2Name,
//         "Code": code,
//         "Name": name,
//         "Name2": name2,
//         "CumulativePoint": cumulativePoint,
//         "CardMemberID": cardMemberId,
//         "Balance": balance,
//         "RedeemedPoint": redeemedPoint,
//         "OutstandPoint": outstandPoint,
//         "BirthDate": birthDate.toIso8601String(),
//         "Type": type,
//         "ContactPerson": contactPerson,
//         "DaysInstail": daysInstail,
//         "Instiallment": instiallment,
//         "Tel": tel,
//         "GLCode": glCode,
//         "InstaillID": instaillId,
//         "GLName": glName,
//         "ActID": actId,
//         "PriName": priName,
//         "PriceListID": priceListId,
//         "Phone": phone,
//         "Months": months,
//         "Days": days,
//         "Email": email,
//         "Address": address,
//         "Delete": delete,
//         "AutoMobile": autoMobile,
//         "GroupID": groupId,
//         "Activities": activities,
//         "Point": point,
//         "PriceList": priceList,
//         "ContactPeople": contactPeople,
//         "BPBranches": bpBranches,
//       };
// }
