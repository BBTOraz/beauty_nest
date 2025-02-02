
String phoneToEmail(String phone) {
  String normalized = phone.replaceAll('+', '');
  return '$normalized@beauty.com';
}
