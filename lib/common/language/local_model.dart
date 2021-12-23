class LocalModel {
  String languageCode;
  String countryCode;

  LocalModel(this.languageCode, this.countryCode);

  LocalModel.fromJson(Map<String, dynamic> json) :
        languageCode = json['languageCode'],
        countryCode = json['countryCode'];

  Map<String, dynamic> toJson() => {
    'languageCode': languageCode,
    'countryCode': countryCode,
  };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write(",\"languageCode\":\"$languageCode\"");
    sb.write(",\"countryCode\":\"$countryCode\"");
    sb.write('}');
    return sb.toString();
  }
}