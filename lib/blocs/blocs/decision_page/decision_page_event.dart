import 'package:flutter_demo_app/blocs/base/bloc_event_state.dart';

class DecisionPageEvent extends BlocEvent {
  final DecisionPageEventType type;
  DecisionPageEvent({
    this.type: DecisionPageEventType.Nothing,
  }) : assert(type != null);
}

enum DecisionPageEventType {
  Nothing,
  LoginPage,
  HomePage,
}