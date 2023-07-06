class ExchangRate {
  List<ShiftForms> shiftForms;
  String systemCurrency;

  ExchangRate({this.shiftForms, this.systemCurrency});

  ExchangRate.fromJson(Map<String, dynamic> json) {
    if (json['ShiftForms'] != null) {
      shiftForms = [];
      json['ShiftForms'].forEach((v) {
        shiftForms.add(new ShiftForms.fromJson(v));
      });
    }
    systemCurrency = json['SystemCurrency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shiftForms != null) {
      data['ShiftForms'] = this.shiftForms.map((v) => v.toJson()).toList();
    }
    data['SystemCurrency'] = this.systemCurrency;
    return data;
  }
}

class ShiftForms {
  int id;
  String decription;
  double inputCash;
  String currency;
  double rateIn;
  double amount;

  ShiftForms({
    this.id,
    this.decription,
    this.inputCash,
    this.currency,
    this.rateIn,
    this.amount,
  });

  ShiftForms.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    decription = json['Decription'];
    inputCash = json['InputCash'];
    currency = json['Currency'];
    rateIn = json['RateIn'];
    amount = json['Amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['Decription'] = this.decription;
    data['InputCash'] = this.inputCash;
    data['Currency'] = this.currency;
    data['RateIn'] = this.rateIn;
    data['Amount'] = this.amount;
    return data;
  }
}
