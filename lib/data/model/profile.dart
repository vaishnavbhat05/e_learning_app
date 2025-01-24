class Profile {
  final int id;
  final String email;
  final int completerChapterInPercentage;
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
          _parseInt(json['completerChapterInPercentage']),
      averageScore: json['testResult']?['averageScore']?? 0,
      highestScore: json['testResult']?['highestScore']?? 0,
      notificationEnabled: json['notificationEnabled'] ?? false,
      profileImageUrl: json['profileImageUrl'],
      userName: json['userName'] ?? "Unknown",
    );
  }

  // Helper function to safely parse an integer
  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value) ?? 0; // Return 0 if parsing fails
    }
    return 0; // Default value if the value is null or not parsable
  }
}
