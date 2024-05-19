bool isEmailValid(String email) {
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

bool isPasswordValid(String password) {
  final RegExp passwordRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
  return passwordRegex.hasMatch(password);
}

bool isPhoneNumberValid(String phoneNumber) {
  final regex = RegExp(r'^(?:\+84|0)(?:3|5|7|8|9)(?:\d{8})$');
  return regex.hasMatch(phoneNumber);
}