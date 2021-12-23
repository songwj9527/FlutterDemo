import 'package:flutter_demo_app/blocs/base/bloc_event_state.dart';

import 'app_update_event.dart';
import 'app_update_state.dart';

class AppUpdateBloc extends BlocEventStateBase<AppUpdateEvent, AppUpdateState> {

  AppUpdateBloc() : super(initialState: AppUpdateState.prepare());

  @override
  Stream<AppUpdateState> eventHandler(AppUpdateEvent event, AppUpdateState currentState) async* {

    if (event.type == AppUpdateEventType.prepare && currentState.status != AppUpdateEventType.prepare) {
      yield AppUpdateState.prepare();
    }

    if (event.type == AppUpdateEventType.download_start && currentState.status != AppUpdateEventType.download_start) {
      yield AppUpdateState.downloadStart();
    }

    if (event.type == AppUpdateEventType.download_running) {
      if (event.progress == 0) {
        yield AppUpdateState.downloadRunning();
      }
      yield AppUpdateState.progress(event.progress);
    }

    if (event.type == AppUpdateEventType.download_complete) {
      yield AppUpdateState.downloadComplete();
    }

    if (event.type == AppUpdateEventType.download_paused) {
      yield AppUpdateState.downloadPaused(event.progress);
    }

    if (event.type == AppUpdateEventType.download_failed) {
      yield AppUpdateState.downloadFailed(currentState.progress);
    }

    if (event.type == AppUpdateEventType.install_start) {
      yield AppUpdateState.installStart(currentState.progress);
    }

    if (event.type == AppUpdateEventType.install_failed) {
      yield AppUpdateState.installFailed(currentState.progress);
    }
  }
}