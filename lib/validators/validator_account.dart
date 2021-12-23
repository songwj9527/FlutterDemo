import 'dart:async';

class AccountValidator {
  final StreamTransformer<String,String> validateAccount = StreamTransformer<String,String>.fromHandlers(handleData: (account, sink){
    if (account == null || account.length == 0) {
      sink.addError("");
    } else {
      sink.add(account);
    }
  });
  final StreamTransformer<String, bool> validateAccountCheck = StreamTransformer<String, bool>.fromHandlers(handleData: (account, sink){
    sink.add(!(account == null || account.length == 0));
  });
}
