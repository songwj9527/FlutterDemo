import 'package:flutter_demo_app/blocs/base/bloc_event_state.dart';
import 'package:meta/meta.dart';

import 'app_update_event.dart';

class AppUpdateState extends BlocState {
  AppUpdateState({
    required this.status,
    this.progress: 0,
  });

  final AppUpdateEventType status;
  final int progress;

  factory AppUpdateState.prepare() {
    return AppUpdateState(status: AppUpdateEventType.prepare, progress: 0);
  }

  factory AppUpdateState.downloadStart() {
    return AppUpdateState(status: AppUpdateEventType.download_start, progress: 0);
  }

  factory AppUpdateState.downloadRunning() {
    return AppUpdateState(status: AppUpdateEventType.download_running, progress: 0);
  }

  factory AppUpdateState.progress(int progress) {
    return AppUpdateState(status: AppUpdateEventType.download_running, progress: progress);
  }

  factory AppUpdateState.downloadComplete() {
    return AppUpdateState(status: AppUpdateEventType.download_complete, progress: 100);
  }

  factory AppUpdateState.downloadPaused(int progress) {
    return AppUpdateState(status: AppUpdateEventType.download_paused, progress: progress);
  }

  factory AppUpdateState.downloadFailed(int progress) {
    return AppUpdateState(status: AppUpdateEventType.download_failed, progress: progress);
  }

  factory AppUpdateState.installStart(int progress) {
    return AppUpdateState(status: AppUpdateEventType.install_start, progress: progress);
  }

  factory AppUpdateState.installFailed(int progress) {
    return AppUpdateState(status: AppUpdateEventType.install_failed, progress: progress);
  }
}