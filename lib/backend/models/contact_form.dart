class ContactForm {
  final String name;
  final String email;
  final String? phone;
  final String? company;
  final String subject;
  final String question;
  final DateTime timestamp;

  ContactForm({
    required this.name,
    required this.email,
    this.phone,
    this.company,
    required this.subject,
    required this.question,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'Name': name.trim(),
      'Email': email.trim().toLowerCase(),
      'Phone': phone?.trim() ?? '',
      'Company': company?.trim() ?? '',
      'Subject': subject.trim(),
      'Question': question.trim(),
      'Timestamp': timestamp.toIso8601String(),
      'Date': '${timestamp.day}/${timestamp.month}/${timestamp.year}',
      'Time':
          '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}',
    };
  }

  List<String> toRowData() {
    return [
      name.trim(),
      email.trim().toLowerCase(),
      phone?.trim() ?? '',
      company?.trim() ?? '',
      subject.trim(),
      question.trim(),
      '${timestamp.day}/${timestamp.month}/${timestamp.year}',
      '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}',
      timestamp.toIso8601String(),
    ];
  }

  static List<String> getHeaders() {
    return [
      'Name',
      'Email',
      'Phone',
      'Company',
      'Subject',
      'Question',
      'Date',
      'Time',
      'Timestamp',
    ];
  }
}
