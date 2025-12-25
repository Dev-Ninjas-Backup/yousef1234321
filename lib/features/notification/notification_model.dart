class AppNotification {
  final String? id;
  final String? type;
  final String? title;
  final String? message;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final NotificationMeta? meta;

  AppNotification({
    this.id,
    this.type,
    this.title,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.meta,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      message: json['message'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      meta: json['meta'] != null
          ? NotificationMeta.fromJson(json['meta'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'message': message,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'meta': meta?.toJson(),
    };
  }
}
class NotificationMeta {
  final String? id;
  final DateTime? date;
  final String? message;
  final String? subject;
  final String? senderName;
  final String? senderEmail;

  NotificationMeta({
    this.id,
    this.date,
    this.message,
    this.subject,
    this.senderName,
    this.senderEmail,
  });

  factory NotificationMeta.fromJson(Map<String, dynamic> json) {
    return NotificationMeta(
      id: json['id'] as String?,
      date: json['date'] != null
          ? DateTime.tryParse(json['date'])
          : null,
      message: json['message'] as String?,
      subject: json['subject'] as String?,
      senderName: json['senderName'] as String?,
      senderEmail: json['senderEmail'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'message': message,
      'subject': subject,
      'senderName': senderName,
      'senderEmail': senderEmail,
    };
  }
}
