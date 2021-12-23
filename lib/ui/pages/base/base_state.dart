import 'package:flutter/material.dart';
import 'package:flutter_demo_app/ui/widgets/dialog_loading.dart';
import 'package:flutter_demo_app/utils/dialog_util.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {

  LoadingDialog? loadingDialog;

  @override
  void dispose() {
    loadingDialog = null;
    super.dispose();
  }

  void showLoadingDialog({message: "", outsideDismiss: true}) {
    if (loadingDialog == null) {
      if (mounted) {
        loadingDialog = LoadingDialog(
          loadingText: message,
          outsideDismiss: outsideDismiss,
        );
      }
    }
    if (loadingDialog != null) {
      if (mounted) {
        DialogUtil.showCustomerDialog(context,
            loadingDialog!,
            outsideDismiss: outsideDismiss,
            backPressEnable: outsideDismiss
        );
      }
    }
  }

  void hideLoadingDialog() {
    if (loadingDialog != null) {
      if (mounted) {
        loadingDialog?.dismiss();
      }
    }
  }

  void dismissLoadingDialog() {
    if (loadingDialog != null) {
      if (mounted) {
        loadingDialog?.dismiss();
      }
      loadingDialog = null;
    }
  }

  bool isLoadingDialogShown() {
    return loadingDialog != null && loadingDialog!.isShown;
  }

  // 隐藏键盘
  void hideInputWindow(BuildContext context) {
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus &&
        currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}