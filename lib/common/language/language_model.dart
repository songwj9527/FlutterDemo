import 'local_model.dart';

class LanguageModel {
  String title;
  LocalModel local;

  LanguageModel(this.title, this.local);

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"title\":\"$title\"");
    sb.write(",\"local\":\"$local\"");
    sb.write('}');
    return sb.toString();
  }
}