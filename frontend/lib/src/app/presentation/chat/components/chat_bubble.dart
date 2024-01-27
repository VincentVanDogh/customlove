import 'package:flutter/cupertino.dart';
import 'package:frontend/src/app/presentation/chat/components/chat_image.dart';
import 'package:frontend/src/app/service/image_service.dart';
import 'package:frontend/src/config/api_config.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final CustomLoveTheme _theme = const CustomLoveTheme();
  final bool isSender;
  final bool isImage;

  const ChatBubble(this.message, this.isSender, this.isImage, {super.key});

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry? padding = EdgeInsets.symmetric(vertical: _theme.universalPadding, horizontal: _theme.universalPadding);
    if (isImage) {
      padding = null;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_theme.universalPadding),
        color: isSender ? _theme.primaryColor : _theme.grayscale1,
      ),
      child: isImage ?
      ChatImage(imageId: message)
          :
      Text(
        message,
        style: TextStyle(
            fontSize: 16,
            color: isSender ? _theme.whiteColor : _theme.textColor,
        ),
      ),
    );
  }

}