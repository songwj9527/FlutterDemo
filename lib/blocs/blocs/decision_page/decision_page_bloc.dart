

import 'package:flutter_demo_app/blocs/base/bloc_event_state.dart';

import 'decision_page_event.dart';
import 'decision_page_state.dart';

/**
 * 页面切换路由bloc
 */
class DecisionPageBloc extends BlocEventStateBase<DecisionPageEvent, DecisionPageState> {

  static DecisionPageBloc? _instance;

  static DecisionPageBloc? get instance => _instance;

  DecisionPageBloc() : super(initialState: DecisionPageState.event(DecisionPageEventType.Nothing)) {
    _instance = this;
  }

  @override
  Stream<DecisionPageState> eventHandler(DecisionPageEvent event, DecisionPageState currentState) async* {
    yield DecisionPageState.event(event.type);
  }

}