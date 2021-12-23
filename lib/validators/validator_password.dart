import 'dart:async';

const String _kMin8CharsOneLetterOneNumber = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$";
const String _kMin8CharsOneLetterOneNumberOnSpecialCharacter = r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$";
const String _kMin8CharsOneUpperLetterOneLowerLetterOnNumber = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$";
const String _kMin8CharsOneUpperOneLowerOneNumberOneSpecial = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$";
const String _kMin8Max10OneUpperOneLowerOneNumberOneSpecial = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,10}$";
const String _kOneUpperOneLowerOneNumberOneSpecial = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]";

class PasswordValidator {
  final StreamTransformer<String,String> validatePassword = StreamTransformer<String,String>.fromHandlers(handleData: (password, sink){
    if (password == null || password.length == 0) {
      sink.addError("");
    } else {
      sink.add(password);
    }
  });
  final StreamTransformer<String, bool> validatePasswordCheck = StreamTransformer<String, bool>.fromHandlers(handleData: (password, sink){
//    final RegExp passwordExp = RegExp(_kMin8CharsOneUpperOneLowerOneNumberOneSpecial);
//
//    if (!passwordExp.hasMatch(password)){
//      sink.addError('Enter a valid password');
//    } else {
//      sink.add(password);
//    }
    sink.add(!(password == null || password.length == 0));
  });
}
