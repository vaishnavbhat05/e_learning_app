class Profile {
  final int id;
  final String email;
  final double completerChapterInPercentage;
  final double averageScore;
  final double highestScore;
  final bool notificationEnabled;
  final String? profileImageUrl;
  final String userName;

  Profile({
    required this.id,
    required this.email,
    required this.completerChapterInPercentage,
    required this.averageScore,
    required this.highestScore,
    required this.notificationEnabled,
    this.profileImageUrl,
    required this.userName,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      email: json['email'],
      completerChapterInPercentage:
      _parseDouble(json['completerChapterInPercentage']),
      averageScore: json['testResult']?['averageScore']?? 0,
      highestScore: json['testResult']?['highestScore']?? 0,
      notificationEnabled: json['notificationEnabled'] ?? false,
      profileImageUrl: json['profileImageUrl'],
      userName: json['userName'] ?? "Unknown",
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0.0; // Return 0.0 if parsing fails
    }
    return 0.0; // Default value if the value is null or not parsable
  }
}
