class MoodEntry {
  final int? id;
  final String userId;
  final String emoji;
  final String label;
  final int color;
  final String? note;
  final DateTime createdAt;

  MoodEntry({
    this.id,
    required this.userId,
    required this.emoji,
    required this.label,
    required this.color,
    this.note,
    required this.createdAt,
  });

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'],
      userId: json['user_id'],
      emoji: json['emoji'],
      label: json['label'],
      color: (json['color'] as int).toUnsigned(32),
      note: json['note'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'emoji': emoji,
      'label': label,
      'color': color,
      if (note != null) 'note': note,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
