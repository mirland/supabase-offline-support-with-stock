import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'projects')
class Project extends Equatable {
  @primaryKey
  final int id;
  final String name;
  final String description;
  final String url;
  final String imageUrl;
  final String language;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.language,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        url: json['url'],
        imageUrl: json['image_url'],
        language: json['language'],
      );

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [id, name, description, url, imageUrl, language];
}
