// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:u_auditor/core/styles/Sizes.dart';
// import 'package:u_auditor/shared/services/localizationServices/app_localizations.dart';
// import 'package:u_auditor/shared/widgets/GeneralComponents.dart';

// class SelectImageTypeBottomSheet extends StatelessWidget {
//   final bool visibility;
//   final String name;

//   const SelectImageTypeBottomSheet({
//     super.key,
//     required this.visibility,
//     required this.name,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         decoration: const BoxDecoration(
//             borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(PaddingConsts.p20),
//                 topLeft: Radius.circular(PaddingConsts.p20))),
//         child: Wrap(
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(PaddingConsts.p20),
//                   child: Text("${AppLocalizations.of(context)!.trans(name)}"),
//                 ),
//                 Visibility(
//                   visible: visibility,
//                   child: IconButton(
//                       onPressed: () {
//                         showAlertDialogContinue(context,
//                             content:
//                             '${AppLocalizations.of(context)!.trans(StringConsts.removeProfilePhoto)}',
//                             continuePressed: () {
//                               BlocProvider.of<ImagesCubit>(context).clearImage();
//                               context.pop();
//                               context.pop();
//                             });
//                       },
//                       icon: const Icon(
//                         Icons.delete,
//                         color: ColorConsts.warmGrey,
//                       )),
//                 ),
//               ],
//             ),
//             ListTile(
//                 leading: Icon(Icons.photo_library,
//                     color: Theme.of(context).primaryColor),
//                 title: Text(
//                   '${AppLocalizations.of(context)!.trans(StringConsts.photoLibrary)}',
//                   style: const TextStyle(
//                       color: ColorConsts.warmGrey2,
//                       fontSize: FontSizeConsts.s16),
//                 ),
//                 onTap: () async {
//                   await BlocProvider.of<ImagesCubit>(context)
//                       .getImageFromGallery();
//                   BlocProvider.of<ImagesCubit>(context).cameraFile = null;
//                   Navigator.pop(context);
//                 }),
//             ListTile(
//               leading: Icon(
//                 Icons.photo_camera,
//                 color: Theme.of(context).primaryColor,
//               ),
//               title: Text(
//                   '${AppLocalizations.of(context)!.trans(StringConsts.camera)}',
//                   style: const TextStyle(
//                       color: ColorConsts.warmGrey2,
//                       fontSize: FontSizeConsts.s16)),
//               onTap: () async {
//                 await BlocProvider.of<ImagesCubit>(context).getImageFromCamera();
//                 BlocProvider.of<ImagesCubit>(context).galleryFile = null;
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   static void showBottomSheetToSelectTheTypeToImage(
//       {required BuildContext context,
//         required bool visibility,
//         required String name}) async {
//     final status = await Permission.storage.request();
//     if (status.isGranted) {
//       showModalBottomSheet(
//           context: context,
//           builder: (BuildContext bc) {
//             return BlocProvider<ImagesCubit>(
//               create: (context) => ImagesCubit(),
//               child: SelectImageTypeBottomSheet(
//                 visibility: visibility,
//                 name: name,
//               ),
//             );
//           });
//     }
//   }
// }
