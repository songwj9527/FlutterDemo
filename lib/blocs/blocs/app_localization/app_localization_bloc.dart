import 'package:common_utils/common_utils.dart';
import 'package:flutter_demo_app/blocs/base/bloc_provider.dart';
import 'package:flutter_demo_app/common/language/local_model.dart';
import 'package:rxdart/rxdart.dart';

/**
 * 切换语言时，刷新页面
 */
class AppLocalizationBloc implements BlocBase {

  BehaviorSubject<LocalModel> _appLocalizationSubject = BehaviorSubject<LocalModel>();

  Sink<LocalModel> get appLocalizationSubjectSink => _appLocalizationSubject.sink;

  Stream<LocalModel> get appLocalizationSubjectStream => _appLocalizationSubject.stream;

  LocalModel _local = LocalModel('zh', 'CH');

  LocalModel get local => _local;

  void initLocal(LocalModel local) {
    if (local == null) {
      return;
    }
    LogUtil.e('init launguage $local');
    this._local = local;
  }

  void setLocal(LocalModel local) {
    if (local == null) {
      return;
    }
    LogUtil.e('set launguage $local');
    this._local = local;
    appLocalizationSubjectSink.add(local);
  }

  @override
  void dispose() {
    _appLocalizationSubject.close();
  }
}