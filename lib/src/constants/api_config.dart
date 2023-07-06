import 'package:http/http.dart' as http;

class Config {
  //------------ Server Test ------------------------------
  //static String baseUrl = "http://192.168.0.181:4546/";
  //static String baseUrl = "http://192.168.0.194:6059/";
  //------------ Public -------------
  //static String baseUrl = "http://103.9.190.155:4546/";
  //-----------Server Production --------------------------
  //static String baseUrl = "http://103.9.190.155:3041/";
  //static String baseUrl = "http://103.9.190.155:3042/";
  //static String baseUrl = "http://103.9.190.155:3043/";
  //---------------API ------------------------------------
  //

  // Public pos

  // static String searchItemByBarcode = "api/master/searchItemByBarcode";
  // static String getItemByBarcode = "api/master/findItemByBarcode";
  // static String getShiftTemplate = "api/v1/posapi/getshifttemplate";
  // static String getSummarySale = "api/master/getsummarysale";
  // static String getSeries = "api/master/getSeries";
  // static String getTableOrdered = "api/master/getTableOrdered";
  // static String getGroup1 = "api/master/getgroup1";
  // static String getGroup2 = "api/master/getgroup2";
  // static String getG2Local = "api/master/getg2local";
  // static String getGroup3 = "api/master/getgroup3";
  // static String getG3Local = "api/master/getg3Local";
  // static String itemUrl = "api/master/getitem";
  // static String getUserSetting = "api/v1/posapi/getusersettingmodel";
  // static String itemUrlLocal = "api/master/getitemlocal";
  // static String processOpenShift = "api/v1/posapi/processopenshift";
  // static String processCloseShift = "api/v1/posapi/processcloseshift";
  // static String getCloseShift = "api/v1/posapi/getReprintCloseShifts";
  // static String receiptReprintCloseShift =
  //     "api/v1/posapi/reprintreceiptcloseshifts";
  // static String saveItemComment = "api/v1/posapi/saveitemcomment";
  // static String getMemberCardDiscount = "api/v1/posapi/getmembercarddiscount";
  // static String getCardMemberDetail = "api/v1/posapi/getCardMemberDetail";
  // static String getItemComment = "api/v1/posapi/getitemcomments";
  // static String deleteItemComment = "api/v1/posapi/deleteitemcomment";
  // static String getPendingVoidItem = "api/v1/posapi/getPendingVoidItem";
  // static String submitPendingVoidItem = "api/v1/posapi/submitPendingVoidItem";
  // static String deletePendingVoidItem = "api/v1/posapi/deletePendingVoidItem";
  // static String receiptToReprint = "api/v1/posapi/getreceiptstoreprint";
  // static String reprintReceipt = "api/v1/posapi/reprintreceipt";
  // static String paymentMean = "api/master/paymentmean";
  // static String searchItemUrl = "api/master/searchitem";
  // static String companyUrl = "api/master/getcompany";
  // static String warehouseUrl = "api/master/getwarehouse";
  // static String priceListUrl = "api/master/getpricelist";
  // static String branchUrl = "api/master/getbranch";
  // static String customerUrl = "api/v1/posapi/getcustomers";
  // static String displayCurrUrl = "api/master/getdisplaycurrency";
  // static String receiptInfo = "api/master/getreceiptinfo";
  // static String searchItem = "api/v1/posapi/searchsaleitems";
  // static String getReceiptToCancel = "api/v1/posapi/getreceiptstocancel";
  // static String voidItem = "api/v1/posapi/voidItem";
  // static String checkOpenShift = "api/v1/posapi/checkopenshift";
  // static String urlSetting = "api/master/getsetting";
  // static String urlLogin = "api/v1/account/login";
  // static String urlGroupTable = "api/v1/posapi/getServiceTables";
  // static String urlTable = "api/v1/posapi/gettablesbygroup";
  // static String urlSearchTable = "api/v1/posapi/searchTables";
  // static String urlTax = "api/master/gettax";
  // static String urlMember = "api/master/getmembercard";
  // static String urlSystemType = "api/v1/Account/getSystemTypes";
  // static String urlLocalCurrency = "api/master/getlocalcurrency";
  // static String urlSysCurrency = "api/master/getSysCurrency";
  // static String urlGetOrder = "api/master/getorder";
  // static String urlCheckOpenShift = "api/master/checkopenshift";
  // static String urlPostOpenShift = "api/postmaster/postopenshift";
  // static String postCloseShift = "api/postmaster/postcloseshift";
  // static String postOrder = "api/postmaster/postorder";
  // static String urlExchange = "api/master/getexchangerate";
  // static String fetchOrder = "api/v1/posapi/fetchorderinfo";
  // static String groupItem = "api/v1/posapi/getgroupItems";
  // static String getItemByGroup = "api/v1/posapi/getgroupItems";
  // static String getNewLineItem = "api/v1/posapi/newlineitem";
  // static String urlSumitOrder = "api/v1/posapi/submitOrder";
  // static String urlSaveOrder = "api/v1/posapi/saveorder";
  // static String deteleSaveOrder = "api/v1/posapi/deletesavedorder";
  // static String voidOrder = "api/v1/posapi/voidOrder";
  // static String getTableInfo = "api/master/gettableinfo";
  // static String getTableMove = "api/master/gettablemove";
  // static String moveTable = "api/master/movetable";
  // static String cancelReceipt = "api/v1/posapi/cancelreceipt";
  // static String returnReceipt = "api/v1/posapi/getreturnreceipts";
  // static String getReceiptCombine = "api/master/getreceiptcombine";
  // static String postCombineReceipt = "api/postmaster/postcombine";
  // static String searchMember = "api/master/searchmember";
  // static String receipt = "api/master/getreceipt";
  // static String receiptDetail = "api/master/getreceiptdetail";
  // static String getCancelReceipt = "api/master/getcancelreceipt";
  // static String getReturnReceipt = "api/master/getreturnreceipt";
  // static String getReturnItem = "api/v1/posapi/sendreturnitems";
  // static String getSummarySalesReceipt = "api/v1/reportpos/getsummarysales";
  // static String searchByBarcode = "api/v1/posapi/findLineItemByBarcode";
  // static String changeTable = "api/v1/posapi/changetable";
  // static String moveOrder = "api/v1/posapi/moveorder";
  // static String orderTocombine = "api/v1/posapi/getOrderstoCombine";
  // static String combineOrder = "api/v1/posapi/combineOrders";
  // static String pendingVoidItem = "api/v1/posapi/pendingvoidItem";
  // static String splitOrder = "api/v1/posapi/splitOrder";
  // static String getChangeRateTemplate = "api/v1/posapi/getchangerateTemplate";
  // static String saveDisplayCurrencies = "api/v1/posapi/saveDisplayCurrencies";
  // // permission
  // static String urlCheckPrivilege = "api/v1/posapi/checkprivilege";

  // static String urlCheckPerOpenShift = "api/permissionapi/checkpermission";
  // static String permisBill = "api/permissionapi/permissionbill";
  // static String permisPay = "api/permissionapi/permissionpay";
  // static String permisVoidOrder = "api/permissionapi/permissionvoidorder";

  // static String permisMoveTable = "api/permissionapi/permissionmovetable";
  // static String permiscombine = "api/permissionapi/permissioncombine";
  // static String permissplit = "api/permissionapi/permissionsplit";

  // static String permisDeleteItem = "api/permissionapi/deleteitem";
  // static String permisMemberCard = "api/permissionapi/membercard";
  // static String permisReturnOrder = "api/permissionapi/returnorder";
  // static String permisCancelOrder = "api/permissionapi/cancelorder";
  // static String permisDiscountItem = "api/permissionapi/discountitem";

// Work pos

  static String searchItemByBarcode = "api/master/searchItemByBarcode";
  static String getItemByBarcode = "api/master/findItemByBarcode";
  static String getShiftTemplate = "api/v1/pos/getshifttemplate";
  static String getSummarySale = "api/master/getsummarysale";
  static String getSeries = "api/master/getSeries";
  static String getTableOrdered = "api/master/getTableOrdered";
  static String getGroup1 = "api/master/getgroup1";
  static String getGroup2 = "api/master/getgroup2";
  static String getG2Local = "api/master/getg2local";
  static String getGroup3 = "api/master/getgroup3";
  static String getG3Local = "api/master/getg3Local";
  static String itemUrl = "api/master/getitem";
  static String getUserSetting = "api/v1/pos/getusersettingmodel";
  static String itemUrlLocal = "api/master/getitemlocal";
  static String processOpenShift = "api/v1/pos/processopenshift";
  static String processCloseShift = "api/v1/pos/processcloseshift";
  static String getCloseShift = "api/v1/pos/getReprintCloseShifts";
  static String receiptReprintCloseShift =
      "api/v1/pos/reprintreceiptcloseshifts";
  static String saveItemComment = "api/v1/pos/saveitemcomment";
  static String getMemberCardDiscount = "api/v1/pos/getmembercarddiscount";
  static String getCardMemberDetail = "api/v1/pos/getCardMemberDetail";
  static String getItemComment = "api/v1/pos/getitemcomments";
  static String deleteItemComment = "api/v1/pos/deleteitemcomment";
  static String getPendingVoidItem = "api/v1/pos/getPendingVoidItem";
  static String submitPendingVoidItem = "api/v1/pos/submitPendingVoidItem";
  static String deletePendingVoidItem = "api/v1/pos/deletePendingVoidItem";
  static String receiptToReprint = "api/v1/pos/getreceiptstoreprint";
  static String reprintReceipt = "api/v1/pos/reprintreceipt";
  static String paymentMean = "api/master/paymentmean";
  static String searchItemUrl = "api/master/searchitem";
  static String companyUrl = "api/master/getcompany";
  static String warehouseUrl = "api/master/getwarehouse";
  static String priceListUrl = "api/master/getpricelist";
  static String branchUrl = "api/master/getbranch";
  static String customerUrl = "api/v1/pos/getcustomers";
  static String displayCurrUrl = "api/master/getdisplaycurrency";
  static String receiptInfo = "api/master/getreceiptinfo";
  static String searchItem = "api/v1/pos/searchsaleitems";
  static String getReceiptToCancel = "api/v1/pos/getreceiptstocancel";
  static String voidItem = "api/v1/pos/voidItem";
  static String checkOpenShift = "api/v1/pos/checkopenshift";
  static String urlSetting = "api/master/getsetting";
  static String urlLogin = "api/v1/account/login";
  static String urlGroupTable = "api/v1/pos/getServiceTables";
  static String urlTable = "api/v1/pos/gettablesbygroup";
  static String urlSearchTable = "api/v1/pos/searchTables";
  static String urlTax = "api/master/gettax";
  static String urlMember = "api/master/getmembercard";
  static String urlSystemType = "api/v1/Account/getSystemTypes";
  static String urlLocalCurrency = "api/master/getlocalcurrency";
  static String urlSysCurrency = "api/master/getSysCurrency";
  static String urlGetOrder = "api/master/getorder";
  static String urlCheckOpenShift = "api/master/checkopenshift";
  static String urlPostOpenShift = "api/postmaster/postopenshift";
  static String postCloseShift = "api/postmaster/postcloseshift";
  static String postOrder = "api/postmaster/postorder";
  static String urlExchange = "api/master/getexchangerate";
  static String fetchOrder = "api/v1/pos/fetchorderinfo";
  static String groupItem = "api/v1/pos/getgroupItems";
  static String getItemByGroup = "api/v1/pos/getgroupItems";
  static String getNewLineItem = "api/v1/pos/newlineitem";
  static String urlSumitOrder = "api/v1/pos/submitOrder";
  static String urlSaveOrder = "api/v1/pos/saveorder";
  static String deteleSaveOrder = "api/v1/pos/deletesavedorder";
  static String voidOrder = "api/v1/pos/voidOrder";
  static String getTableInfo = "api/master/gettableinfo";
  static String getTableMove = "api/master/gettablemove";
  static String moveTable = "api/master/movetable";
  static String cancelReceipt = "api/v1/pos/cancelreceipt";
  static String returnReceipt = "api/v1/pos/getreturnreceipts";
  static String getReceiptCombine = "api/master/getreceiptcombine";
  static String postCombineReceipt = "api/postmaster/postcombine";
  static String searchMember = "api/master/searchmember";
  static String receipt = "api/master/getreceipt";
  static String receiptDetail = "api/master/getreceiptdetail";
  static String getCancelReceipt = "api/master/getcancelreceipt";
  static String getReturnReceipt = "api/master/getreturnreceipt";
  static String getReturnItem = "api/v1/pos/sendreturnitems";
  static String getSummarySalesReceipt = "api/v1/reportpos/getsummarysales";
  static String searchByBarcode = "api/v1/pos/findLineItemByBarcode";
  static String changeTable = "api/v1/pos/changetable";
  static String moveOrder = "api/v1/pos/moveorder";
  static String orderTocombine = "api/v1/pos/getOrderstoCombine";
  static String combineOrder = "api/v1/pos/combineOrders";
  static String pendingVoidItem = "api/v1/pos/pendingvoidItem";
  static String splitOrder = "api/v1/pos/splitOrder";
  static String getChangeRateTemplate = "api/v1/pos/getchangerateTemplate";
  static String saveDisplayCurrencies = "api/v1/pos/saveDisplayCurrencies";
  // permission
  static String urlCheckPrivilege = "api/v1/pos/checkprivilege";

  static String urlCheckPerOpenShift = "api/permissionapi/checkpermission";
  static String permisBill = "api/permissionapi/permissionbill";
  static String permisPay = "api/permissionapi/permissionpay";
  static String permisVoidOrder = "api/permissionapi/permissionvoidorder";

  static String permisMoveTable = "api/permissionapi/permissionmovetable";
  static String permiscombine = "api/permissionapi/permissioncombine";
  static String permissplit = "api/permissionapi/permissionsplit";

  static String permisDeleteItem = "api/permissionapi/deleteitem";
  static String permisMemberCard = "api/permissionapi/membercard";
  static String permisReturnOrder = "api/permissionapi/returnorder";
  static String permisCancelOrder = "api/permissionapi/cancelorder";
  static String permisDiscountItem = "api/permissionapi/discountitem";

  // method
  static void postApi(String url, String token) async {
    await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token
      },
    );
  }

  static void getApi(String url) {
    http.get(Uri.parse(url));
  }
}
