import 'package:flutter/material.dart';

import 'base_state.dart';
import 'task_controller.dart';

abstract class TaskControllerState<T extends StatefulWidget> extends BaseState<T> with TaskController {

  @override
  void dispose() {
    clear();
    super.dispose();
  }
}