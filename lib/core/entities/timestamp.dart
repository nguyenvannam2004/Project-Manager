class TimeStamp
{
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? startDate;
  final DateTime? endDate;

  TimeStamp(this.createdAt, this.updatedAt, this.startDate, this.endDate);
  
  factory TimeStamp.fromJson(Map<String, dynamic> json) {
    return TimeStamp(
      DateTime.parse(json['createdAt'] as String),
      json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      json['startDate'] != null ? DateTime.parse(json['startDate'] as String) : null,
      json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
    );
  }

   TimeStamp copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return TimeStamp(
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
      startDate ?? this.startDate,
      endDate ?? this.endDate,
    );
  }
  
  Map<String, dynamic> toJson() => {
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
      };
}