import "package:app/models/chapter.json.dart" as mapper;
import "package:app/models/novel.dart";
import "package:meta/meta.dart";

String slugify({@required Uri uri}) {
  // Strip any subdomains from the host
  final host = uri.host.replaceAllMapped(
    RegExp(r".*?([a-z]+\.[a-z]{2,})$"),
    (match) => match[1],
  );
  final path = uri.path.replaceAllMapped(
    RegExp(r"\d{1,19}"),
    (match) => "0" * (20 - match.end + match.start) + match[0],
  );
  return host.toLowerCase() + path.toLowerCase();
}

@immutable
class Chapter {
  const Chapter({
    this.slug,
    this.url,
    this.previousUrl,
    this.nextUrl,
    this.title,
    this.content,
    this.createdAt,
    this.readAt,
    this.novelSlug,
    this.novelSource,
    this.novel,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) => mapper.fromJson(json);

  static const type = "chapter";
  static const columns = mapper.columns;

  final String slug;
  final Uri url;
  final Uri previousUrl;
  final Uri nextUrl;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime readAt;

  final String novelSlug;
  final String novelSource;
  final Novel novel;

  Chapter copyWith({
    String slug,
    Uri url,
    Uri previousUrl,
    Uri nextUrl,
    String title,
    String content,
    DateTime createdAt,
    DateTime readAt,
    String novelSlug,
    String novelSource,
    Novel novel,
  }) {
    return Chapter(
      slug: slug ?? this.slug,
      url: url ?? this.url,
      previousUrl: previousUrl ?? this.previousUrl,
      nextUrl: nextUrl ?? this.nextUrl,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      novelSlug: novelSlug ?? this.novelSlug,
      novelSource: novelSource ?? this.novelSource,
      novel: novel ?? this.novel,
    );
  }

  Map<String, dynamic> toJson() => mapper.toJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Chapter &&
          runtimeType == other.runtimeType &&
          slug == other.slug &&
          url == other.url &&
          previousUrl == other.previousUrl &&
          nextUrl == other.nextUrl &&
          title == other.title &&
          content == other.content &&
          createdAt == other.createdAt &&
          readAt == other.readAt &&
          novelSlug == other.novelSlug &&
          novelSource == other.novelSource &&
          novel == other.novel;

  @override
  int get hashCode =>
      slug.hashCode ^
      url.hashCode ^
      previousUrl.hashCode ^
      nextUrl.hashCode ^
      title.hashCode ^
      content.hashCode ^
      createdAt.hashCode ^
      readAt.hashCode ^
      novelSlug.hashCode ^
      novelSource.hashCode ^
      novel.hashCode;

  @override
  String toString() {
    return "Chapter{"
        "slug: $slug,"
        "url: $url,"
        "previousUrl: $previousUrl,"
        "nextUrl: $nextUrl,"
        "title: $title,"
        "content: $content,"
        "createdAt: $createdAt,"
        "readAt: $readAt,"
        "novelSlug: $novelSlug,"
        "novelSource: $novelSource,"
        "novel: $novel"
        "}";
  }
}
