import 'package:flutter/material.dart';

class AlertsProvider with ChangeNotifier{
  bool _isAlertsExecute=false;

  bool get isAlertExecuteGet=>_isAlertsExecute;

  void alertExecuting(){
    _isAlertsExecute=true;
    notifyListeners();
  }
  void alertExecuted(){
    _isAlertsExecute=false;
    notifyListeners();
  }
}