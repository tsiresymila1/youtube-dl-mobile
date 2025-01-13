import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:youtube_dl/core/permission.dart';
import 'package:youtube_dl/presentation/bloc/download/download_bloc.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

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
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(context),
            const Gap(16.0),
            _buildDropdownMenu(),
            const Gap(24.0),
            _buildMp3Switch(),
            const Gap(24.0),
            _buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Select Video Quality',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        IconButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          icon: const Icon(Icons.close),
        )
      ],
    );
  }

  Widget _buildDropdownMenu() {
    return DropdownButton<StreamInfo>(
      value: info,
      items: widget.manifest.video.map((quality) {
        return DropdownMenuItem<StreamInfo>(
          value: quality,
          child: Text(
            "${quality.tag} - ${quality.qualityLabel} - ${quality.videoResolution} - ${quality.size.totalMegaBytes.toStringAsFixed(1)} MB",
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
      onChanged: !mp3
          ? (StreamInfo? newValue) => setState(() => info = newValue ?? info)
          : null,
    );
  }

  Widget _buildMp3Switch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Switch(
          value: mp3,
          activeColor: Colors.red,
          onChanged: (bool value) => setState(() => mp3 = value),
        ),
        const Gap(12),
        const Text("Only mp3")
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('Confirm'),
      onPressed: () => _handleDownload(context),
    );
  }

  Future<void> _handleDownload(BuildContext context) async {
    final filename = widget.video.title
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(' ', '_');
    Fluttertoast.showToast(
      msg: "Starting download ...",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    final audioOnly = widget.manifest.audio
        .firstWhere((q) => q.container.name.toLowerCase() == "mp4");
    List<Map<String, dynamic>> futures = [
      {
        "url": audioOnly.url.toString(),
        "name": "Audio_$filename.${audioOnly.container.name}",
        "notificationType": mp3 ? 'ALL' : null
      }
    ];
    if (!mp3) {
      futures.add({
        "url": info.url.toString(),
        "name": "$filename.${info.container.name}",
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
        name: info.container.name,
        mp3: mp3)
    );
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _showPermissionError(BuildContext context) {
    AwesomeDialog(
      context: context,
      animType: AnimType.bottomSlide,
      dialogType: DialogType.noHeader,
      title: "Error",
      desc: "Check permission to write",
      btnCancelOnPress: () {},
    ).show();
  }
}
