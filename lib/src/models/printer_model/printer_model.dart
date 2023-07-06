class PrinterInfor {
  final String printerId;
  final String printerName;
  final String interface;
  final String printerMode;
  final int paperWidth;
  final String printReceiptStatus;
  final String autoPrintReceiptStatus;

  PrinterInfor({
    this.printerId,
    this.printerName,
    this.interface,
    this.printerMode,
    this.paperWidth,
    this.printReceiptStatus,
    this.autoPrintReceiptStatus,
  });
  factory PrinterInfor.fromJson(Map<String, dynamic> json) => PrinterInfor(
        printerId: json['printerId'] as String,
        printerName: json['printerName'] as String,
        interface: json['interface'] as String,
        printerMode: json['printerMode'] as String,
        paperWidth: json['paperWidth'] as int,
        printReceiptStatus: json['printReceiptStatus'] as String,
        autoPrintReceiptStatus: json['autoPrintReceiptStatus'] as String,
      );
  Map<String, dynamic> toMap() {
    return {
      'printerId': printerId,
      'printerName': printerName,
      'interface': interface,
      'printerMode': printerMode,
      'paperWidth': paperWidth,
      'printReceiptStatus': printReceiptStatus,
      'autoPrintReceiptStatus': autoPrintReceiptStatus,
    };
  }

  @override
  String toString() {
    return 'Id:$printerId, Name:$printerName, Interface:$interface Mode:$printerMode, Paper:$paperWidth, PrintReceipt:$printReceiptStatus, AutoPrintReceipt:$autoPrintReceiptStatus';
  }
}
