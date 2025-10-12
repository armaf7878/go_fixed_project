// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceDto _$ServiceDtoFromJson(Map<String, dynamic> json) => ServiceDto(
  id: json['id'] as String,
  name: json['name'] as String,
  iconUrl: json['icon_url'] as String?,
  price: (json['price'] as num?)?.toInt(),
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$ServiceDtoToJson(ServiceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon_url': instance.iconUrl,
      'price': instance.price,
      'isActive': instance.isActive,
    };
