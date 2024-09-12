class PasswordModel {
  int? id;
  final String site;
  final String username;
  final String password;
  final String note;
  final String dateTime;

  PasswordModel({
    this.id,
    required this.site,
    required this.username,
    required this.password,
    required this.note,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'site': site,
      'username': username,
      'password': password,
      'note': note,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return <String, dynamic>{
      'site': site,
      'username': username,
      'password': password,
      'note': note,
    };
  }

  factory PasswordModel.fromJson(Map<String, dynamic> map) {
    return PasswordModel(
      id: map['id'] as int,
      site: map['site'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      note: map['note'] ?? '',
      dateTime: map['dateTime'] ?? DateTime.now().toString(),
    );
  }
}
