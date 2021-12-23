import 'package:event_bus/event_bus.dart';

class EventBusHelper {
  static final EventBusHelper _singleton = EventBusHelper._init();
  static EventBus? _eventBus;

  static EventBusHelper get instance =>  _singleton;

  factory EventBusHelper() {
    return _singleton;
  }

  EventBusHelper._init() {
    _eventBus = EventBus();
  }

  Stream<T> on<T>() {
    return _eventBus!.on<T>();
  }

  void fire<T>(T event) {
    _eventBus!.fire(event);
  }
}