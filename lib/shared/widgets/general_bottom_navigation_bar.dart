import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:projectsandtasks/core/constants/image_consts.dart';
import 'package:projectsandtasks/core/constants/string_consts.dart';
import 'package:projectsandtasks/core/styles/Colors.dart';
import 'package:projectsandtasks/core/utils/change_index_controller.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';

class GeneralBottomNavigationBar extends StatelessWidget {
  const GeneralBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeIndexController>(
      builder: (context, changeIndexController, child) {
        return Container(
          margin: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: 20.h,
          ),
          padding: EdgeInsets.only(top: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              // Outer glow
              BoxShadow(
                color: ColorConsts.gunmetalBlue.withOpacity(0.15),
                blurRadius: 30,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
              // Inner shadow for depth
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: -5,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: _buildNavBar(context, changeIndexController),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavBar(BuildContext context, ChangeIndexController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context: context,
            index: 0,
            currentIndex: controller.index,
            isSvg: true,
            svgPath: ImageConsts.homeIcon,
            label: AppLocalizations.of(context)!.trans(StringConsts.home) ?? 'Home',
            onTap: () => controller.changeIndexFunction(0),
          ),
          _buildNavItem(
            context: context,
            index: 1,
            currentIndex: controller.index,
            isSvg: true,
            svgPath: ImageConsts.tasks,
            label: AppLocalizations.of(context)!.trans(StringConsts.tasks) ?? 'Tasks',
            onTap: () => controller.changeIndexFunction(1),
          ),
          _buildNavItem(
            context: context,
            index: 2,
            currentIndex: controller.index,
            isSvg: false,
            icon: Icons.assignment_turned_in_outlined,
            label: AppLocalizations.of(context)!.trans(StringConsts.actions) ?? 'Actions',
            onTap: () => controller.changeIndexFunction(2),
          ),
          _buildNavItem(
            context: context,
            index: 3,
            currentIndex: controller.index,
            isSvg: true,
            svgPath: ImageConsts.inspection,
            label: AppLocalizations.of(context)!.trans(StringConsts.inspections) ?? 'Inspections',
            onTap: () => controller.changeIndexFunction(3),
          ),
          _buildNavItem(
            context: context,
            index: 4,
            currentIndex: controller.index,
            isSvg: true,
            svgPath: ImageConsts.settingIcon,
            label: AppLocalizations.of(context)!.trans(StringConsts.settings) ?? 'Settings',
            onTap: () => controller.changeIndexFunction(4),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required int currentIndex,
    required String label,
    required VoidCallback onTap,
    bool isSvg = true,
    String? svgPath,
    IconData? icon,
  }) {
    final isSelected = index == currentIndex;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with animated background
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                tween: Tween<double>(
                  begin: 0.0,
                  end: isSelected ? 1.0 : 0.0,
                ),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 1.0 + (value * 0.15),
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isSelected
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  ColorConsts.gunmetalBlue.withOpacity(0.15 + (value * 0.05)),
                                  ColorConsts.gunmetalBlue.withOpacity(0.1 + (value * 0.05)),
                                ],
                              )
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: ColorConsts.gunmetalBlue.withOpacity(0.2 * value),
                                  blurRadius: 10 * value,
                                  spreadRadius: 2 * value,
                                ),
                              ]
                            : null,
                      ),
                      child: isSvg
                          ? SvgPicture.asset(
                              svgPath!,
                              color: isSelected
                                  ? ColorConsts.gunmetalBlue
                                  : ColorConsts.gunmetalBlue,
                              width: 24.w,
                              height: 24.h,
                            )
                          : Icon(
                              icon!,
                              color: isSelected
                                  ? ColorConsts.gunmetalBlue
                                  : ColorConsts.gunmetalBlue,
                              size: 24.sp,
                            ),
                    ),
                  );
                },
              ),
              SizedBox(height: 4.h),
              // Animated label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                style: TextStyle(
                  fontFamily: 'Almarai-Bold',
                  color: isSelected
                      ? ColorConsts.gunmetalBlue
                      : ColorConsts.gunmetalBlue,
                  fontSize: isSelected ? 11.sp : 10.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
