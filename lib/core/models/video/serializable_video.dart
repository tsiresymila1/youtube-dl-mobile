import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

part 'serializable_video.freezed.dart';
part 'serializable_video.g.dart';

@freezed
class SerializableVideo with _$SerializableVideo {
  const factory SerializableVideo({
    required VideoId id,
    required String title,
    required String author,
    required String channelId,
    DateTime? uploadDate,
    String? uploadDateRaw,
    DateTime? publishDate,
    required String description,
    Duration? duration,
    required bool isLive,
  }) = _SerializableVideo;

  factory SerializableVideo.fromJson(Map<String, dynamic> json) => _$SerializableVideoFromJson(json);

  factory SerializableVideo.fromVideo(Video video) {
    return SerializableVideo(
      id: video.id,
      title: video.title,
      author: video.author,
      channelId: video.channelId.value,
      uploadDate: video.uploadDate,
      uploadDateRaw: video.uploadDateRaw,
      publishDate: video.publishDate,
      description: video.description,
      duration: video.duration,
      isLive: video.isLive,
    );
  }
}

extension VideoExtension on Video {
  Map<String, dynamic> toJson() {
    return SerializableVideo.fromVideo(this).toJson();
  }
}