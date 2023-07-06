class MemberCard {
  int iD;
  int cardTypeID;
  String refNo;
  String name;
  bool delete;
  String approve;
  String description;
  String dateCreate;
  String expireDate;
  String dateApprove;
  CardType cardType;

  MemberCard(
      {this.iD,
      this.cardTypeID,
      this.refNo,
      this.name,
      this.delete,
      this.approve,
      this.description,
      this.dateCreate,
      this.expireDate,
      this.dateApprove,
      this.cardType});

  MemberCard.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    cardTypeID = json['CardTypeID'];
    refNo = json['Ref_No'];
    name = json['Name'];
    delete = json['Delete'];
    approve = json['Approve'];
    description = json['Description'];
    dateCreate = json['DateCreate'];
    expireDate = json['ExpireDate'];
    dateApprove = json['DateApprove'];
    cardType = json['CardType'] != null
        ? new CardType.fromJson(json['CardType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['CardTypeID'] = this.cardTypeID;
    data['Ref_No'] = this.refNo;
    data['Name'] = this.name;
    data['Delete'] = this.delete;
    data['Approve'] = this.approve;
    data['Description'] = this.description;
    data['DateCreate'] = this.dateCreate;
    data['ExpireDate'] = this.expireDate;
    data['DateApprove'] = this.dateApprove;
    if (this.cardType != null) {
      data['CardType'] = this.cardType.toJson();
    }
    return data;
  }
}

class CardType {
  int iD;
  String name;
  double discount;
  String typeDis;
  bool delete;

  CardType({this.iD, this.name, this.discount, this.typeDis, this.delete});

  CardType.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    discount = json['Discount'];
    typeDis = json['TypeDis'];
    delete = json['Delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Discount'] = this.discount;
    data['TypeDis'] = this.typeDis;
    data['Delete'] = this.delete;
    return data;
  }
}
