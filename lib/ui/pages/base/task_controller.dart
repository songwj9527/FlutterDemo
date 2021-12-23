import 'dart:async';
import 'dart:collection';

import 'package:dio/dio.dart';

abstract class TaskController {
  HashMap<String, StreamSubscription> _subscriptionMap = HashMap<String, StreamSubscription>();
  HashMap<String, CancelToken> _cancelTokenMap = HashMap<String, CancelToken>();

  void addToken(String? key, CancelToken cancelToken) {
    if (key == null) {
      key = "";
    }
    if (_cancelTokenMap.containsKey(key)) {
      CancelToken? old = _cancelTokenMap[key];
      _cancelTokenMap.remove(key);
      if (old != null && !old.isCancelled) {
        old.cancel();
      }
    }
    _cancelTokenMap[key] = cancelToken;
  }

  void removeToken(String? key) {
    if (key == null) {
      key = "";
    }
    if (_cancelTokenMap.containsKey(key)) {
      CancelToken? old = _cancelTokenMap[key];
      _cancelTokenMap.remove(key);
      if (old != null && !old.isCancelled) {
        old.cancel();
      }
    }
  }

  void addTask(String? key, StreamSubscription subscription) {
    if (key == null) {
      key = "";
    }
    if (_subscriptionMap.containsKey(key)) {
      StreamSubscription? old = _subscriptionMap[key];
      _subscriptionMap.remove(key);
      old?.cancel();
    }
    _subscriptionMap[key] = subscription;
  }

  void removeTask(String? key) {
    if (key == null) {
      key = "";
    }
    if (_subscriptionMap.containsKey(key)) {
      StreamSubscription? old = _subscriptionMap[key];
      _subscriptionMap.remove(key);
      old?.cancel();
    }
  }

  void addTaskAndToken(String? key, StreamSubscription subscription, CancelToken cancelToken) {
    if (key == null) {
      key = "";
    }
    if (_subscriptionMap.containsKey(key)) {
      StreamSubscription? old = _subscriptionMap[key];
      _subscriptionMap.remove(key);
      old?.cancel();
    }
    if (_cancelTokenMap.containsKey(key)) {
      CancelToken? old = _cancelTokenMap[key];
      _cancelTokenMap.remove(key);
      if (old != null && !old.isCancelled) {
        old.cancel();
      }
    }
    _subscriptionMap[key] = subscription;
    _cancelTokenMap[key] = cancelToken;
  }

  void removeTaskAndToken(String? key) {
    if (key == null) {
      key = "";
    }
    if (_subscriptionMap.containsKey(key)) {
      StreamSubscription? old = _subscriptionMap[key];
      _subscriptionMap.remove(key);
      old?.cancel();
    }
    if (_cancelTokenMap.containsKey(key)) {
      CancelToken? old = _cancelTokenMap[key];
      _cancelTokenMap.remove(key);
      if (old != null && !old.isCancelled) {
        old.cancel();
      }
    }
  }

  void clear() {
    _subscriptionMap.forEach((key, value) {
      value.cancel();
    });
    _subscriptionMap.clear();

    _cancelTokenMap.forEach((key, value) {
      if (!value.isCancelled) {
        value.cancel();
      }
    });
    _cancelTokenMap.clear();
  }
}