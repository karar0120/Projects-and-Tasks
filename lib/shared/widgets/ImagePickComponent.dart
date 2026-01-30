
// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:projectsandtasks/core/constants/image_consts.dart';
import 'package:projectsandtasks/core/constants/string_consts.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';
import '../../Core/styles/Colors.dart';
import 'GeneralComponents.dart';

class ImagePickComponent extends StatelessWidget {
  const ImagePickComponent({
    required this.pickFromCameraFunction,
    required this.pickFromGalleryFunction,
    required Key key,
  }) : super(key: key);

  final Function pickFromCameraFunction;
  final Function pickFromGalleryFunction;

  @override
  Widget build(BuildContext context) {
    //final userDataController = Provider.of<UserDataController>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: Title18sp(text: AppLocalizations.of(context).trans('choose_option'),textColor: backButtonColor,),
        //       content: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           const Divider(
        //             height: 1,
        //           ),
        //           ListTile(
        //             onTap: () async {
        //               try {
        //                 pickFromCameraFunction();
        //                 Navigator.of(context).pop();
        //               } catch (error) {
        //                 Navigator.of(context).pop();
        //               }
        //             },
        //             title: Subtitle14sp(text: AppLocalizations.of(context).trans('camera'),fontWeight: FontWeight.w500,),
        //             leading: const Icon(
        //               Icons.camera,
        //               color: primaryColor,
        //             ),
        //           ),
        //           const Divider(
        //             height: 1,
        //           ),
        //           ListTile(
        //             onTap: () async {
        //               try {
        //                 pickFromGalleryFunction();
        //                 Navigator.of(context).pop();
        //               } catch (error) {
        //                 Navigator.of(context).pop();
        //               }
        //             },
        //             title: Subtitle14sp(text: AppLocalizations.of(context).trans('gallery'),fontWeight: FontWeight.w500,),
        //             leading: const Icon(
        //               Icons.account_box,
        //               color: primaryColor,
        //             ),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // );
      },
      child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorConsts.imageColor2,
              border: Border.all(color: ColorConsts.inActiveTextColor)),
          child: Center(
            child: Image.asset(
              ImageConsts.editIcon,
              height: 15,
              color: ColorConsts.backButtonColor,
              width: 15,
            ),
          )),
    );
  }
}

class ImagePickerController extends ChangeNotifier {
  PickedFile? _image;

  PickedFile? get image => _image;
  bool removeImage = false;
  void showPicker(context,
      {required bool visibility, required String name}) async {
    final status = await Permission.storage.request();
    removeImage = false;
    if (status.isGranted) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: Wrap(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                              "${AppLocalizations.of(context)!.trans(name)}"),
                        ),
                        Visibility(
                          visible: visibility,
                          child: IconButton(
                              onPressed: () {
                                showAlertDialogContinue(context,
                                    content:
                                        '${AppLocalizations.of(context)!.trans(StringConsts.removeProfilePhoto)}',
                                    continuePressed: () {
                                  cameraFile = null;
                                  galleryFile = null;
                                  removeImage = true;
                                  notifyListeners();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });

                                //notifyListeners();
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: ColorConsts.warmGrey,
                              )),
                        ),
                      ],
                    ),
                    ListTile(
                        leading: Icon(Icons.photo_library,
                            color: Theme.of(context).primaryColor),
                        title: Text(
                          '${AppLocalizations.of(context)!.trans(StringConsts.photoLibrary)}',
                          style: const TextStyle(
                              color: ColorConsts.warmGrey2, fontSize: 16),
                        ),
                        onTap: () async {
                          await getImageFromGallery(context);
                          cameraFile = null;
                          // Navigator.pop(context);
                        }),
                    ListTile(
                      leading: Icon(
                        Icons.photo_camera,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                          '${AppLocalizations.of(context)!.trans(StringConsts.camera)}',
                          style: const TextStyle(
                              color: ColorConsts.warmGrey2, fontSize: 16)),
                      onTap: () async {
                        await getImage(context);
                        galleryFile = null;
                        // Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  File? cameraFile;
  Future getImage(context) async {
    final myFile = await ImagePicker().pickImage(source: ImageSource.camera);
    cameraFile = File(myFile!.path);
    if (cameraFile != null) {
      // await SharedApi.getMyCredentials(cameraFile, context);
    }
    notifyListeners();
  }

  File? galleryFile;

  Future getImageFromGallery(context) async {
    final myFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    galleryFile = File(myFile!.path);
    if (galleryFile != null) {
      // await SharedApi.getMyCredentials(galleryFile, context);
    }
    notifyListeners();
  }

  double sizeGalleryFile() {
    if (galleryFile != null) {
      final bytes = galleryFile!.readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      final mb = kb / 1024;
      return mb;
    }
    return 0;
  }

  double sizeCameraFile() {
    if (cameraFile != null) {
      final bytes = cameraFile!.readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      final mb = kb / 1024;
      return mb;
    }
    return 0;
  }
}

class ImagePickerControllerCategories extends ChangeNotifier {
  PickedFile? _image;

  PickedFile? get image => _image;
  bool removeImage = false;
  void showPicker(context) async {
    final status = await Permission.storage.request();
    removeImage = false;
    if (status.isGranted) {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: Wrap(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                              "${AppLocalizations.of(context)!.trans(StringConsts.profilePhoto)}"),
                        ),
                        IconButton(
                            onPressed: () {
                              showAlertDialogContinue(context,
                                  content:
                                      '${AppLocalizations.of(context)!.trans(StringConsts.removeProfilePhoto)}',
                                  continuePressed: () {
                                // staffController.deleteStaff(context,
                                //     id: staffController.TrueStaffItem[widget.index].id!);
                                // Timer(const Duration(seconds: 1), () {
                                //   staffController.refresh(context);
                                // });
                                cameraFile = null;
                                galleryFile = null;
                                removeImage = true;
                                notifyListeners();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });

                              //notifyListeners();
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: ColorConsts.warmGrey,
                            )),
                      ],
                    ),
                    ListTile(
                        leading: Icon(Icons.photo_library,
                            color: Theme.of(context).primaryColor),
                        title: Text(
                          '${AppLocalizations.of(context)!.trans(StringConsts.photoLibrary)}',
                          style: const TextStyle(
                              color: ColorConsts.warmGrey2, fontSize: 16),
                        ),
                        onTap: () async {
                          await getImageFromGallery();
                          cameraFile = null;
                          // Navigator.pop(context);
                        }),
                    ListTile(
                      leading: Icon(
                        Icons.photo_camera,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                          '${AppLocalizations.of(context)!.trans(StringConsts.camera)}',
                          style: const TextStyle(
                              color: ColorConsts.warmGrey2, fontSize: 16)),
                      onTap: () async {
                        await getImage();
                        galleryFile = null;
                        // Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  File? cameraFile;
  Future getImage() async {
    final myFile = await ImagePicker().pickImage(source: ImageSource.camera);
    cameraFile = File(myFile!.path);
    notifyListeners();
  }

  File? galleryFile;

  Future getImageFromGallery() async {
    final myFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    galleryFile = File(myFile!.path);
    notifyListeners();
  }

  double sizeGalleryFile() {
    if (galleryFile != null) {
      final bytes = galleryFile!.readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      final mb = kb / 1024;
      return mb;
    }
    return 0;
  }

  double sizeCameraFile() {
    if (cameraFile != null) {
      final bytes = cameraFile!.readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      final mb = kb / 1024;
      return mb;
    }
    return 0;
  }
}