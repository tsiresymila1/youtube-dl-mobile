import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youtube_dl/core/permission.dart';
import 'package:youtube_dl/presentation/bloc/download/download_bloc.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:easy_localization/easy_localization.dart';

class YtModalSheetQualitySelector extends StatefulWidget {
  final StreamManifest manifest;
  final Video video;

  const YtModalSheetQualitySelector({
    super.key,
    required this.manifest,
    required this.video,
  });

  @override
  State<YtModalSheetQualitySelector> createState() =>
      _YtModalSheetQualitySelectorState();
}

class _YtModalSheetQualitySelectorState
    extends State<YtModalSheetQualitySelector> {
  late StreamInfo info;
  bool mp3 = false;

  @override
  void initState() {
    info = widget.manifest.video.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withAlpha(50),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'quality_selection'.tr(),
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            widget.video.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          _buildModeSelector(theme),
          const SizedBox(height: 16),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: mp3 ? [_buildMp3Selection(theme)] : _buildVideoSelections(theme),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + MediaQuery.of(context).padding.bottom),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: () => _handleDownload(context),
                icon: const Icon(Icons.download_rounded),
                label: Text(
                  'start_download'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SegmentedButton<bool>(
        segments: [
          ButtonSegment<bool>(
            value: false,
            label: Text("video_mode".tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
            icon: const Icon(Icons.videocam_rounded),
          ),
          ButtonSegment<bool>(
            value: true,
            label: Text("audio_mode".tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
            icon: const Icon(Icons.music_note_rounded),
          ),
        ],
        selected: {mp3},
        onSelectionChanged: (Set<bool> newSelection) {
          setState(() {
            mp3 = newSelection.first;
          });
        },
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: Colors.redAccent.withAlpha(50),
          selectedForegroundColor: Colors.redAccent,
          side: BorderSide(color: Colors.redAccent.withAlpha(50)),
        ),
      ),
    );
  }

  List<Widget> _buildVideoSelections(ThemeData theme) {
    return widget.manifest.video.map((quality) {
      final isSelected = info == quality;
      final colorScheme = theme.colorScheme;
      
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.redAccent.withAlpha(20) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.redAccent.withAlpha(100) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.redAccent.withAlpha(30) : colorScheme.surfaceContainerHighest.withAlpha(100),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.video_collection_rounded,
              color: isSelected ? Colors.redAccent : colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          title: Text(
            "${quality.qualityLabel} (${quality.videoResolution})",
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.redAccent : colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            "${quality.size.totalMegaBytes.toStringAsFixed(1)} MB • ${quality.container.name.toUpperCase()}",
            style: theme.textTheme.bodySmall,
          ),
          trailing: isSelected
              ? const Icon(Icons.check_circle_rounded, color: Colors.redAccent)
              : null,
          onTap: () => setState(() => info = quality),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    }).toList();
  }

  Widget _buildMp3Selection(ThemeData theme) {
    final audioOnly = widget.manifest.audio.withHighestBitrate();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.redAccent.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.redAccent.withAlpha(100), width: 1.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.redAccent.withAlpha(30),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.headset_rounded, color: Colors.redAccent),
        ),
        title: Text(
          "High Quality MP3",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ), 
        ),
        subtitle: Text(
          "${audioOnly.size.totalMegaBytes.toStringAsFixed(1)} MB • ${(audioOnly.bitrate.bitsPerSecond / 1000).toInt()}kbps",
          style: theme.textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.check_circle_rounded, color: Colors.redAccent),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Future<void> _handleDownload(BuildContext context) async {
    final filename = widget.video.title
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(' ', '_');
    
    // Check for context mount before toast
    if (!context.mounted) return;
    
    Fluttertoast.showToast(
      msg: "downloading".tr(),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );

    final audioOnly = widget.manifest.audio.withHighestBitrate();
    
    List<Map<String, dynamic>> futures = [
      {
        "url": audioOnly.url.toString(),
        "tag": audioOnly.tag,
        "name": "Audio_$filename.${audioOnly.container.name}",
        "type": "audio",
        "notificationType": mp3 ? 'ALL' : null
      }
    ];
    
    if (!mp3) {
      futures.add({
        "url": info.url.toString(),
        "tag": info.tag,
        "name": "$filename.${info.container.name}",
        "type": "video",
        "notificationType": 'ALL'
      });
    }

    await requestPermissions(
      () => _sendDownloadTaskToBackground(context, futures, filename),
      error: () => _showPermissionError(context),
    );
  }

  Future<void> _sendDownloadTaskToBackground(
    BuildContext context,
    List<Map<String, dynamic>> futures,
    String filename,
  ) async {
    context.read<DownloadBloc>().add(DownloadVideoInitEvent(
        video: widget.video,
        futures: futures,
        filename: filename,
        name: mp3 ? "mp3" : info.container.name,
        mp3: mp3)
    );
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _showPermissionError(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      title: "error_occurred".tr(),
      desc: "Permission Denied",
      btnOkOnPress: () {},
      btnOkColor: Colors.redAccent,
    ).show();
  }
}
