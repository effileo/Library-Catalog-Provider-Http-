class Book {
  final String id;
  final String title;
  final String author;
  final int? publishYear;
  final String? coverUrl;
  final String? subject;
  final String personalNote;
  final bool isFavorite;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.publishYear,
    this.coverUrl,
    this.subject,
    this.personalNote = '',
    this.isFavorite = false,
  });

  factory Book.fromApi(Map<String, dynamic> json) {
    String author = 'Unknown Author';
    if (json['author_name'] is List && (json['author_name'] as List).isNotEmpty) {
      author = (json['author_name'] as List).first.toString();
    }

    String? coverUrl;
    if (json['cover_i'] != null) {
      coverUrl = 'https://covers.openlibrary.org/b/id/${json['cover_i']}-M.jpg';
    }

    String? subject;
    if (json['subject'] is List && (json['subject'] as List).isNotEmpty) {
      subject = (json['subject'] as List).first.toString();
    }

    return Book(
      id: json['key']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Unknown Title',
      author: author,
      publishYear: json['first_publish_year'] as int?,
      coverUrl: coverUrl,
      subject: subject,
    );
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      author: json['author']?.toString() ?? '',
      publishYear: json['publishYear'] as int?,
      coverUrl: json['coverUrl']?.toString(),
      subject: json['subject']?.toString(),
      personalNote: json['personalNote']?.toString() ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'publishYear': publishYear,
      'coverUrl': coverUrl,
      'subject': subject,
      'personalNote': personalNote,
      'isFavorite': isFavorite,
    };
  }

  Book copyWith({
    String? id,
    String? title,
    String? author,
    int? publishYear,
    String? coverUrl,
    String? subject,
    String? personalNote,
    bool? isFavorite,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      publishYear: publishYear ?? this.publishYear,
      coverUrl: coverUrl ?? this.coverUrl,
      subject: subject ?? this.subject,
      personalNote: personalNote ?? this.personalNote,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
