class LocalCurrency {
  int iD;
  int currencyID;
  Currency currency;
  double rate;
  bool delete;
  double rateOut;
  double setRate;

  LocalCurrency({
    this.iD,
    this.currencyID,
    this.currency,
    this.rate,
    this.delete,
    this.rateOut,
    this.setRate,
  });

  LocalCurrency.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    currencyID = json['CurrencyID'];
    currency = json['Currency'] != null
        ? new Currency.fromJson(json['Currency'])
        : null;
    rate = json['Rate'];
    delete = json['Delete'];
    rateOut = json['RateOut'];
    setRate = json['SetRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['CurrencyID'] = this.currencyID;
    if (this.currency != null) {
      data['Currency'] = this.currency.toJson();
    }
    data['Rate'] = this.rate;
    data['Delete'] = this.delete;
    data['RateOut'] = this.rateOut;
    data['SetRate'] = this.setRate;
    return data;
  }
}

class Currency {
  int iD;
  String symbol;
  String description;
  bool delete;

  Currency({this.iD, this.symbol, this.description, this.delete});

  Currency.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    symbol = json['Symbol'];
    description = json['Description'];
    delete = json['Delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Symbol'] = this.symbol;
    data['Description'] = this.description;
    data['Delete'] = this.delete;
    return data;
  }
}
