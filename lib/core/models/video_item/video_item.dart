import 'package:freezed_annotation/freezed_annotation.dart';

import '../video/serializable_video.dart';

part 'video_item.freezed.dart';
part 'video_item.g.dart';

@freezed
class VideoItem with _$VideoItem{
  const factory VideoItem({
    required String uuid,
    required String path,
    @Default(false) bool isMp3,
    required SerializableVideo video,
  }) = _VideoItem;

  factory VideoItem.fromJson(Map<String, Object?> json)
  => _$VideoItemFromJson(json);
}