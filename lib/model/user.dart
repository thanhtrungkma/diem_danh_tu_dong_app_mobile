class User {
  int? id;
  String? username;
  var password;
  String? role;
  String? question;
  String? answer;
  int? teacherId;

  User({
    this.id,
    this.username,
    this.password,
    this.role,
    this.question,
    this.answer,
    this.teacherId,
  });

  Map<String, String> toJson() =>
      {'username': username.toString(), 'password': password.toString(), 'answer': answer.toString(), 'question': question.toString()};
}
