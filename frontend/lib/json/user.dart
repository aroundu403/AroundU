/// This is a Dart class the models detialed user information
/// This will be a 1-1 mapping to the JSON data from backend API
/// Named UseInfo here because UserInfo has been defined in Firebase
class UseInfo {
  final int userId;
  final String userName;
  final String email;

  const UseInfo(
      {required this.userId, required this.userName, required this.email});

  factory UseInfo.fromJson(Map<String, dynamic> json) {
    return UseInfo(
        userId: json['user_id'],
        userName: json['user_name'],
        email: json['email']);
  }
}
