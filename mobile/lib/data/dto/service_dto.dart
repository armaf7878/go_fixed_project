import 'package:json_annotation/json_annotation.dart';
part 'service_dto.g.dart';

@JsonSerializable()
class ServiceDto {
  final String id;
  final String name;
  @JsonKey(name: 'icon_url') final String? iconUrl;
  final int? price;
  @JsonKey(defaultValue: true) final bool isActive;

  ServiceDto({
    required this.id,
    required this.name,
    this.iconUrl,
    this.price,
    this.isActive = true,
  });

  factory ServiceDto.fromJson(Map<String, dynamic> json) => _$ServiceDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceDtoToJson(this);
}
