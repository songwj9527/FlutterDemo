import 'package:flutter_demo_app/blocs/base/bloc_event_state.dart';

class AppUpdateEvent extends BlocEvent {
  final AppUpdateEventType type;
  final int progress;

  AppUpdateEvent({
    this.type: AppUpdateEventType.prepare,
    this.progress: 0
  }) : assert(type != null);
}

enum AppUpdateEventType {
  prepare,
  download_start,
  download_running,
  download_complete,
  download_paused,
  download_failed,
  install_start,
  install_failed
}