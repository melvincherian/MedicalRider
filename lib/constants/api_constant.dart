class ApiConstant {
  static const String baseUrl = 'http://31.97.206.144:7021/';
  static const String loginEndpoint = 'api/rider/login';
  static const String dashboardEndpoint = 'api/rider/dashboard';
  static const String neworderapi = 'api/rider/neworders';
  static const String updateOrderapi = 'api/rider/update-status';
  static const String riderWalletapi = 'api/rider/riderwallet';
  static const String addbankDetailsapi = 'api/rider/add-bank';
  static const String getallbankdetailsapi = 'api/rider/bank-details';
  static const String withdrawamountapi = 'api/rider/withdraw';
  static const String previousOrderapi = 'api/rider/previous-orders';
  static const String activeOrderapi = 'api/rider/active-orders';
  static const String getprofileapi = 'api/rider/myprofile';
  static const String updateProfileimageapi = 'api/rider/updateprofileimage';
  static const String acceptedorderApi = 'api/rider/acceptedorders';
  static const String pickedupordersapi = 'api/rider/pickeduporders';
  static const String ordertodeliverapi = 'api/rider/deliver-order';
  static const String signupApi = 'api/rider/signup';
  static const String forgotpasswordApi = 'api/rider/forgot-password';
  static const String notificationApi = 'api/rider/notifications';
  static const String documentApi = 'api/rider/driving-license';
  static const String singlestatusApi =
      'api/rider/orders/:riderId?status=Pending';
  static const String chartapi = 'api/rider/earnings-graph';
  static const String createQuery = 'api/rider/createQuery';

  // static String addUserLocation() => '$baseUrl/users/add-location';

  static const String updatelocationApi = 'api/rider/update-location';

  static String getDashboardUrl(String riderId) {
    return '$baseUrl$dashboardEndpoint/$riderId';
  }

  static String getuserlocation(String riderId) {
    return '$baseUrl$updatelocationApi/$riderId';
  }

  static String getNewOrder(String riderId) {
    return '$baseUrl$neworderapi/$riderId';
  }

  static String updateOrderstatus(String riderId) {
    return '$baseUrl$updateOrderapi/$riderId';
  }

  static String getwallet(String riderId) {
    return '$baseUrl$riderWalletapi/$riderId';
  }

  static String addbankaccount(String riderId) {
    return '$baseUrl$addbankDetailsapi/$riderId';
  }

  static String getbankdetails(String riderId) {
    return '$baseUrl$getallbankdetailsapi/$riderId';
  }

  static String withdrawwallet(String riderId) {
    return '$baseUrl$withdrawamountapi/$riderId';
  }

  static String previousorder(String riderId) {
    return '$baseUrl$previousOrderapi/$riderId';
  }

  static String activeorder(String riderId) {
    return '$baseUrl$activeOrderapi/$riderId';
  }

  static String profileapi(String riderId) {
    return '$baseUrl$getprofileapi/$riderId';
  }

  static String updateprofile(String riderId) {
    return '$baseUrl$updateProfileimageapi/$riderId';
  }

  static String acceptorder(String riderId) {
    return '$baseUrl$acceptedorderApi/$riderId';
  }

  static String pickedorder(String riderId) {
    return '$baseUrl$pickedupordersapi/$riderId';
  }

  static String updatedeliverorder(String riderId, String orderId) {
    return '$baseUrl$ordertodeliverapi/$riderId/$orderId';
  }

  static String notification(String riderId) {
    return '$baseUrl$notificationApi/$riderId';
  }

  static String documents(String riderId) {
    return '$baseUrl$documentApi/$riderId';
  }

  static String getchartapi(String riderId, {String filter = 'thisWeek'}) {
    return '$baseUrl$chartapi/$riderId?filter=$filter';
  }
}
