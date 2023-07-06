// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

// Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());
List<Customer> customerFromJson(String str) =>
    List<Customer>.from(json.decode(str).map((x) => Customer.fromJson(x)));

class Customer {
  Customer({
    this.id,
    this.group1Id,
    this.group2Id,
    this.saleEmid,
    this.vatNumber,
    this.paymentTermsId,
    this.gpSink,
    this.creditLimit,
    this.glAccId,
    this.saleEmpName,
    this.group1Name,
    this.paymentCode,
    this.instaillmentId,
    this.group2Name,
    this.code,
    this.name,
    this.name2,
    this.cumulativePoint,
    this.cardMemberId,
    this.balance,
    this.redeemedPoint,
    this.outstandPoint,
    this.birthDate,
    this.type,
    this.contactPerson,
    this.daysInstail,
    this.instiallment,
    this.tel,
    this.glCode,
    this.instaillId,
    this.glName,
    this.actId,
    this.priName,
    this.priceListId,
    this.phone,
    this.months,
    this.days,
    this.email,
    this.address,
    this.delete,
    this.autoMobile,
    this.groupId,
    this.activities,
    this.point,
    this.priceList,
    this.contactPeople,
    this.bpBranches,
  });

  final int id;
  final int group1Id;
  final int group2Id;
  final int saleEmid;
  final String vatNumber;
  final int paymentTermsId;
  final dynamic gpSink;
  final double creditLimit;
  final int glAccId;
  final dynamic saleEmpName;
  final dynamic group1Name;
  final dynamic paymentCode;
  final int instaillmentId;
  final dynamic group2Name;
  final String code;
  final String name;
  final String name2;
  final double cumulativePoint;
  final int cardMemberId;
  final double balance;
  final double redeemedPoint;
  final double outstandPoint;
  final DateTime birthDate;
  final String type;
  final dynamic contactPerson;
  final dynamic daysInstail;
  final dynamic instiallment;
  final int tel;
  final dynamic glCode;
  final int instaillId;
  final dynamic glName;
  final int actId;
  final dynamic priName;
  final int priceListId;
  final dynamic phone;
  final int months;
  final int days;
  final dynamic email;
  final dynamic address;
  final bool delete;
  final dynamic autoMobile;
  final int groupId;
  final int activities;
  final bool point;
  final dynamic priceList;
  final dynamic contactPeople;
  final dynamic bpBranches;

  Customer copyWith({
    int id,
    int group1Id,
    int group2Id,
    int saleEmid,
    String vatNumber,
    int paymentTermsId,
    dynamic gpSink,
    int creditLimit,
    int glAccId,
    dynamic saleEmpName,
    dynamic group1Name,
    dynamic paymentCode,
    int instaillmentId,
    dynamic group2Name,
    String code,
    String name,
    String name2,
    double cumulativePoint,
    int cardMemberId,
    int balance,
    int redeemedPoint,
    double outstandPoint,
    DateTime birthDate,
    String type,
    dynamic contactPerson,
    dynamic daysInstail,
    dynamic instiallment,
    int tel,
    dynamic glCode,
    int instaillId,
    dynamic glName,
    int actId,
    dynamic priName,
    int priceListId,
    dynamic phone,
    int months,
    int days,
    dynamic email,
    dynamic address,
    bool delete,
    dynamic autoMobile,
    int groupId,
    int activities,
    bool point,
    dynamic priceList,
    dynamic contactPeople,
    dynamic bpBranches,
  }) =>
      Customer(
        id: id ?? this.id,
        group1Id: group1Id ?? this.group1Id,
        group2Id: group2Id ?? this.group2Id,
        saleEmid: saleEmid ?? this.saleEmid,
        vatNumber: vatNumber ?? this.vatNumber,
        paymentTermsId: paymentTermsId ?? this.paymentTermsId,
        gpSink: gpSink ?? this.gpSink,
        creditLimit: creditLimit ?? this.creditLimit,
        glAccId: glAccId ?? this.glAccId,
        saleEmpName: saleEmpName ?? this.saleEmpName,
        group1Name: group1Name ?? this.group1Name,
        paymentCode: paymentCode ?? this.paymentCode,
        instaillmentId: instaillmentId ?? this.instaillmentId,
        group2Name: group2Name ?? this.group2Name,
        code: code ?? this.code,
        name: name ?? this.name,
        name2: name2 ?? this.name2,
        cumulativePoint: cumulativePoint ?? this.cumulativePoint,
        cardMemberId: cardMemberId ?? this.cardMemberId,
        balance: balance ?? this.balance,
        redeemedPoint: redeemedPoint ?? this.redeemedPoint,
        outstandPoint: outstandPoint ?? this.outstandPoint,
        birthDate: birthDate ?? this.birthDate,
        type: type ?? this.type,
        contactPerson: contactPerson ?? this.contactPerson,
        daysInstail: daysInstail ?? this.daysInstail,
        instiallment: instiallment ?? this.instiallment,
        tel: tel ?? this.tel,
        glCode: glCode ?? this.glCode,
        instaillId: instaillId ?? this.instaillId,
        glName: glName ?? this.glName,
        actId: actId ?? this.actId,
        priName: priName ?? this.priName,
        priceListId: priceListId ?? this.priceListId,
        phone: phone ?? this.phone,
        months: months ?? this.months,
        days: days ?? this.days,
        email: email ?? this.email,
        address: address ?? this.address,
        delete: delete ?? this.delete,
        autoMobile: autoMobile ?? this.autoMobile,
        groupId: groupId ?? this.groupId,
        activities: activities ?? this.activities,
        point: point ?? this.point,
        priceList: priceList ?? this.priceList,
        contactPeople: contactPeople ?? this.contactPeople,
        bpBranches: bpBranches ?? this.bpBranches,
      );

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["ID"],
        group1Id: json["Group1ID"],
        group2Id: json["Group2ID"],
        saleEmid: json["SaleEMID"],
        vatNumber: json["VatNumber"],
        paymentTermsId: json["PaymentTermsID"],
        gpSink: json["GPSink"],
        creditLimit: json["CreditLimit"],
        glAccId: json["GLAccID"],
        saleEmpName: json["SaleEmpName"],
        group1Name: json["Group1Name"],
        paymentCode: json["PaymentCode"],
        instaillmentId: json["InstaillmentID"],
        group2Name: json["Group2Name"],
        code: json["Code"],
        name: json["Name"],
        name2: json["Name2"],
        cumulativePoint: json["CumulativePoint"].toDouble(),
        cardMemberId: json["CardMemberID"],
        balance: json["Balance"],
        redeemedPoint: json["RedeemedPoint"],
        outstandPoint: json["OutstandPoint"].toDouble(),
        birthDate: DateTime.parse(json["BirthDate"]),
        type: json["Type"],
        contactPerson: json["ContactPerson"],
        daysInstail: json["DaysInstail"],
        instiallment: json["Instiallment"],
        tel: json["Tel"],
        glCode: json["GLCode"],
        instaillId: json["InstaillID"],
        glName: json["GLName"],
        actId: json["ActID"],
        priName: json["PriName"],
        priceListId: json["PriceListID"],
        phone: json["Phone"],
        months: json["Months"],
        days: json["Days"],
        email: json["Email"],
        address: json["Address"],
        delete: json["Delete"],
        autoMobile: json["AutoMobile"],
        groupId: json["GroupID"],
        activities: json["Activities"],
        point: json["Point"],
        priceList: json["PriceList"],
        contactPeople: json["ContactPeople"],
        bpBranches: json["BPBranches"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Group1ID": group1Id,
        "Group2ID": group2Id,
        "SaleEMID": saleEmid,
        "VatNumber": vatNumber,
        "PaymentTermsID": paymentTermsId,
        "GPSink": gpSink,
        "CreditLimit": creditLimit,
        "GLAccID": glAccId,
        "SaleEmpName": saleEmpName,
        "Group1Name": group1Name,
        "PaymentCode": paymentCode,
        "InstaillmentID": instaillmentId,
        "Group2Name": group2Name,
        "Code": code,
        "Name": name,
        "Name2": name2,
        "CumulativePoint": cumulativePoint,
        "CardMemberID": cardMemberId,
        "Balance": balance,
        "RedeemedPoint": redeemedPoint,
        "OutstandPoint": outstandPoint,
        "BirthDate": birthDate.toIso8601String(),
        "Type": type,
        "ContactPerson": contactPerson,
        "DaysInstail": daysInstail,
        "Instiallment": instiallment,
        "Tel": tel,
        "GLCode": glCode,
        "InstaillID": instaillId,
        "GLName": glName,
        "ActID": actId,
        "PriName": priName,
        "PriceListID": priceListId,
        "Phone": phone,
        "Months": months,
        "Days": days,
        "Email": email,
        "Address": address,
        "Delete": delete,
        "AutoMobile": autoMobile,
        "GroupID": groupId,
        "Activities": activities,
        "Point": point,
        "PriceList": priceList,
        "ContactPeople": contactPeople,
        "BPBranches": bpBranches,
      };
}
