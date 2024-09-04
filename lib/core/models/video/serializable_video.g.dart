// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializable_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SerializableVideoImpl _$$SerializableVideoImplFromJson(
        Map<String, dynamic> json) =>
    _$SerializableVideoImpl(
      id: VideoId.fromJson(json['id'] as Map<String, dynamic>),
      title: json['title'] as String,
      author: json['author'] as String,
      channelId: json['channelId'] as String,
      uploadDate: json['uploadDate'] == null
          ? null
          : DateTime.parse(json['uploadDate'] as String),
      uploadDateRaw: json['uploadDateRaw'] as String?,
      publishDate: json['publishDate'] == null
          ? null
          : DateTime.parse(json['publishDate'] as String),
      description: json['description'] as String,
      duration: json['duration'] == null
          ? null
          : Duration(microseconds: (json['duration'] as num).toInt()),
      isLive: json['isLive'] as bool,
    );

Map<String, dynamic> _$$SerializableVideoImplToJson(
        _$SerializableVideoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'channelId': instance.channelId,
      'uploadDate': instance.uploadDate?.toIso8601String(),
      'uploadDateRaw': instance.uploadDateRaw,
      'publishDate': instance.publishDate?.toIso8601String(),
      'description': instance.description,
      'duration': instance.duration?.inMicroseconds,
      'isLive': instance.isLive,
    };
