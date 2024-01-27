import 'package:flutter/material.dart';
import 'package:frontend/src/app/service/image_service.dart';
import 'package:frontend/src/config/app_state.dart';
import '../../../../config/theme.dart';
import '../../../model/user_model.dart';
import 'package:provider/provider.dart';

class Avatar extends StatelessWidget {
  final User _user;
  ImageService? _service;
  ProfileImageStorage? _storage;
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  Avatar.withImage(this._user, {Key? key}) : super(key: key);

  factory Avatar(User? user) {
    return Avatar.withImage(user!);
  }

  Future<void> getProfileImage(User? user) async {
    if (_service == null ||
        _storage == null ||
        user == null ||
        _storage!.loaded(user.id)) {
      return;
    }

    var tmp = await _service!.getImage("profile-picture/${user.id}");
    _storage!.load(user.id, tmp);
  }

  @override
  Widget build(BuildContext context) {
    _service = Provider.of<ImageService>(context);
    _storage = Provider.of<ProfileImageStorage>(context);
    getProfileImage(_user);

    return Consumer<ProfileImageStorage>(
      builder:
          (BuildContext context, ProfileImageStorage storage, Widget? child) {
        int id = _user.id;

        if (!storage.loaded(id)) {
          return const Icon(Icons.downloading);
        } else {
          return FittedBox(
            fit: BoxFit.fill,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                CircleAvatar(
                  backgroundColor: _customLoveTheme.grayscale1,
                  backgroundImage: MemoryImage(_storage!.getBytes(id)!),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
