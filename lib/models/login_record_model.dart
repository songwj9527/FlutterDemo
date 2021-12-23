class LoginRecordModel {
  String? _userName;
  String? _userAccount;
  String? _userPwd;
  num? _TXID;

  LoginRecordModel(String? userName, String? userAccount, String? userPwd, num? TXID) {
    this._userName = userName;
    this._userAccount = userAccount;
    this._userPwd = userPwd;
    this._TXID = TXID;
  }

  LoginRecordModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    _userName = json['userName'];
    _userAccount = json['userAccount'];
    _userPwd = json['userPwd'];
    _TXID = json['TXID'];
  }

  Map<String, dynamic> toJson() => {
    'userName': _userName,
    'userAccount': _userAccount,
    'userPwd': _userPwd,
    'TXID': _TXID,
  };

  String? getUserName() {
    return _userName;
  }

  set userName(String value) {
    _userName = value;
  }

  String? getUserAccount() {
    return _userAccount;
  }

  set userAccount(String value) {
    _userAccount = value;
  }

  String? getUserPwd() {
    return _userPwd;
  }

  set userPwd(String value) {
    _userPwd = value;
  }

  num? getTXID(){
    return _TXID;
  }

  set TXID(num value) {
    _TXID = value;
  }

  @override
  String toString() {
    return "{\"userName\":$_userName,\"userAccount\":$_userAccount,\"userPwd\":$_userPwd,\"TXID\":$_TXID}";
  }
}