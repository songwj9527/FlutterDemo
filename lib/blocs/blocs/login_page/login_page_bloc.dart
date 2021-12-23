import 'package:flutter_demo_app/blocs/base/bloc_provider.dart';
import 'package:flutter_demo_app/validators/validator_account.dart';
import 'package:flutter_demo_app/validators/validator_password.dart';
import 'package:rxdart/rxdart.dart';

class LoginPageBloc extends Object with AccountValidator, PasswordValidator implements BlocBase {
  // 账号 Subject
  final BehaviorSubject<String> _accountController = BehaviorSubject<String>();
  // 密码 Subject
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();
  // 登录记录按钮 Subject
  final BehaviorSubject<bool> _accountRecordController = BehaviorSubject<bool>();
  // 密码隐藏按钮 Subject
  final BehaviorSubject<bool> _passwordObscureController = BehaviorSubject<bool>();

  // 账号 Inputs
  Function(String) get onAccountChanged => _accountController.sink.add;
  // 密码 Inputs
  Function(String) get onPasswordChanged => _passwordController.sink.add;
  // 登录记录按钮 CheckBox
  Function(bool) get onAccountRecordChanged => _accountRecordController.sink.add;
  // 密码隐藏按钮 CheckBox
  Function(bool) get onPasswordObscureChanged => _passwordObscureController.sink.add;

  // 账号检验 Validators
  Stream<String> get account => _accountController.stream.transform(validateAccount);
  // 密码检验 Validators
  Stream<String> get password => _passwordController.stream.transform(validatePassword);
  // 登录记录按钮 CheckBox
  Stream<bool> get record => _accountRecordController.stream;
  // 密码隐藏按钮 CheckBox
  Stream<bool> get passwordObscure => _passwordObscureController.stream;

  // 账号检验 Validators
  Stream<bool> get accountCheck => _accountController.stream.transform(validateAccountCheck);
  // 密码检验 Validators
  Stream<bool> get passwordCheck => _passwordController.stream.transform(validatePasswordCheck);

  // 登录按钮: 是否可点
  Stream<bool> get loginValid => CombineLatestStream([accountCheck, passwordCheck], (List<bool> streams) {
    if (streams == null || streams.length < 2) {
      return false;
    }
    return streams[0] && streams[1];
  });

  @override
  void dispose() {
    _accountController.close();
    _passwordController.close();
    _accountRecordController.close();
    _passwordObscureController.close();
  }
}