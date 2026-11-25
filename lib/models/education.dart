import 'package:json_annotation/json_annotation.dart';

part 'education.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Education {
  const Education({
    this.id,
    required this.institution,
    required this.major,
    required this.startedAt,
  });

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;
  final String institution;
  final String major;
  final String startedAt;

  Map<String, dynamic> toJson() => _$EducationToJson(this);
}
