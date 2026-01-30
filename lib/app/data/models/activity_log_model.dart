class ActivityLog {
  final int? id;
  final String userId;
  final String activityType;
  final int durationMinutes;
  final DateTime createdAt;

  ActivityLog({
    this.id,
    required this.userId,
    required this.activityType,
    required this.durationMinutes,
    required this.createdAt,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    // Supabase returns timestamps in UTC, parse explicitly as UTC
    final rawTimestamp = json['created_at'] as String;
    final utcTime = DateTime.parse(rawTimestamp).toUtc();

    return ActivityLog(
      id: json['id'],
      userId: json['user_id'],
      activityType: json['activity_type'],
      durationMinutes: json['duration_minutes'],
      createdAt: utcTime.toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'activity_type': activityType,
      'duration_minutes': durationMinutes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
