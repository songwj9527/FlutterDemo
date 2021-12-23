class BaseResponse<T> {
  num? Code;
  String? Message;
  T? Result;

  BaseResponse({this.Code, this.Message, this.Result});

  @override
  String toString() {
    StringBuffer sb = StringBuffer('{');
    sb.write(",\"Code\":$Code");
    sb.write(",\"Message\":\"$Message\"");
    if (Result is String) {
      sb.write(",\"Result\":\"$Result\"");
    } else {
      sb.write(",\"Result\":$Result");
    }
    sb.write('}');
    return sb.toString();
  }
}