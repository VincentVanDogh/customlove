import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/src/app/service/image_service.dart';
import 'package:frontend/src/config/api_config.dart';
import 'package:frontend/src/config/app_state.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:provider/provider.dart';

class ChatImage extends StatefulWidget {
  final String imageId;

  const ChatImage({required this.imageId, super.key});

  @override
  State<ChatImage> createState() => _ChatImageState();
}

class _ChatImageState extends State<ChatImage> {
  final CustomLoveTheme _theme = const CustomLoveTheme();

  ImageService? _service;
  ImageStorage? _storage;

  Future<void> getImage() async {
    if (_service == null || _storage == null || _storage!.loaded(int.parse(widget.imageId))) {
      return;
    }

    var tmp = await _service!.getImage("images/${widget.imageId}");
    _storage!.load(int.parse(widget.imageId), tmp);
  }

  @override
  Widget build(BuildContext context) {
    _service = Provider.of<ImageService>(context);
    _storage = Provider.of<ImageStorage>(context);
    getImage();

    var img = Consumer<ImageStorage>(
      builder: (BuildContext context, ImageStorage storage, Widget? child) {
        int id = int.parse(widget.imageId);

        if (!storage.loaded(id)) {
          return const Icon(Icons.downloading);
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(_theme.universalPadding),
          child: Image.memory(storage.getBytes(id)!)
        );
      },
    );

    return GestureDetector(
      onTap: () => showDialog(
          builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.transparent,
                content: Expanded(child: FittedBox(fit: BoxFit.scaleDown, child: img))
              ),
          context: context),
      child: img,
    );
  }
}
