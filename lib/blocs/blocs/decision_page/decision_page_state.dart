

import 'package:flutter_demo_app/blocs/base/bloc_event_state.dart';

import 'decision_page_event.dart';

class DecisionPageState extends BlocState {
  final DecisionPageEventType event;

  DecisionPageState({
    required this.event
  });

  factory DecisionPageState.event(DecisionPageEventType event){
    return DecisionPageState(event: event);
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DecisionPageState &&
          event == other.event;
}

enum DecisionPageStateType {
  nothing,
  routeToPage,
}
