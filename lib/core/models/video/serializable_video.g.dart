// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializable_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SerializableVideo _$SerializableVideoFromJson(Map<String, dynamic> json) =>
    _SerializableVideo(
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
      thumbnailUrl: json['thumbnailUrl'] as String,
      isLive: json['isLive'] as bool,
    );

Map<String, dynamic> _$SerializableVideoToJson(_SerializableVideo instance) =>
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
      'thumbnailUrl': instance.thumbnailUrl,
      'isLive': instance.isLive,
    };
