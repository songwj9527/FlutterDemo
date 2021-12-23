import 'package:flutter/material.dart';

import 'double_click_exit_state.dart';
import 'task_controller.dart';

abstract class TaskAndExitState<T extends StatefulWidget> extends DoubleClickExitState<T> with TaskController {

  @override
  void dispose() {
    clear();
    super.dispose();
  }
}