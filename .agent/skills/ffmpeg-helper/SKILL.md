---
name: FFmpeg Helper
description: Guidelines for generating valid FFmpeg commands for the mobile FFmpeg Kit.
---

# FFmpeg Helper

Use this skill when working with `ffmpeg_kit_flutter_new`.

## 1. Syntax Handling
- **Space Escaping**: Paths with spaces must be escaped.
  - Incorrect: `-i /storage/emulated/0/My Folder/video.mp4`
  - Correct: `-i "/storage/emulated/0/My Folder/video.mp4"`
- **Codecs**: Mobile devices often prefer `aac` for audio and `libx264` (software) or `h264_mediacodec` (hardware) for video.

## 2. Common Recipes

### Merge Audio and Video
```dart
final command = '-i "$videoPath" -i "$audioPath" -c:v copy -c:a aac "$outputPath"';
```

### Convert to MP3
```dart
final command = '-i "$inputPath" -vn -acodec libmp3lame -q:a 2 "$outputPath"';
```
- `-vn`: Disable video recording.
- `-acodec libmp3lame`: Use MP3 codec.
- `-q:a 2`: Variable bit rate (high quality).

### Trim Video
```dart
final command = '-ss 00:00:10 -i "$inputPath" -t 00:00:30 -c copy "$outputPath"';
```
- `-ss`: Start time.
- `-t`: Duration.

## 3. Session Handling
Always check the return code:
```dart
FFmpegKit.execute(command).then((session) async {
  final returnCode = await session.getReturnCode();
  if (ReturnCode.isSuccess(returnCode)) {
    // Success
  } else {
    // Failure
    final failStackTrace = await session.getFailStackTrace();
    print("FFmpeg failed: $failStackTrace");
  }
});
```

## 4. Permissions
- Ensure `Permission.manageExternalStorage` (Android 11+) or `Permission.storage` is granted before running commands involving external files.
