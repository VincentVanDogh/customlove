import 'package:flutter/material.dart';
import 'package:frontend/src/app/service/image_service.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'menu_item.dart';

class PopupMenu extends StatelessWidget {
  final CustomLoveTheme _theme = const CustomLoveTheme();
  final int receiverId;

  const PopupMenu(this.receiverId, {super.key});

  Future<void> getImage(BuildContext context, ImageSource media, ImagePicker picker) async {
    if (!context.mounted) {
      return;
    }

    var img = await picker.pickImage(source: media);
    if (img == null) {
      // TODO
    }

    // ignore: use_build_context_synchronously
    Provider.of<ImageService>(context, listen: false).postImage(img!, "images?receiver_id=$receiverId");
  }

  void myAlert(BuildContext context, ImagePicker picker) {
    List<Widget> buttons = [
      MenuItem(
        label: "From Gallery",
        icon: Icons.image,
        onTap: () {
          Navigator.pop(context);
          getImage(context, ImageSource.gallery, picker);
        },
      ),
      MenuItem(
        label: "From Camera",
        icon: Icons.camera,
        onTap: () {
          Navigator.pop(context);
          getImage(context, ImageSource.camera, picker);
        },
      ),
    ];

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Upload image'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Choose the upload source"),
                ],
              ),
            ),
            actions: buttons,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ImagePicker picker = ImagePicker();

    return Material(
      child: PopupMenuButton(
        icon: const Icon(
          Icons.add_circle,
          size: 40,
        ),
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem<int>(
              value: 0,
              child: MenuItem(label: "Send pictures", icon: Icons.photo),
            )
          ];
        },
        onSelected: (int value) {
          if (value == 0) {
            myAlert(context, picker);
          }
        },
      ),
    );
  }
}
