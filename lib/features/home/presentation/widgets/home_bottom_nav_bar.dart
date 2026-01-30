import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projectsandtasks/core/styles/Colors.dart';
import 'package:projectsandtasks/core/utils/change_index_controller.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';

/// Enhanced bottom navigation bar for the Projects & Tasks app.
/// Uses [ChangeIndexController] and works without ScreenUtilInit.
class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({super.key});

  static List<HomeNavItem> _items(BuildContext context) {
    String tr(String key) => AppLocalizations.of(context)?.trans(key) ?? key;
    return [
      HomeNavItem(icon: Icons.folder_outlined, label: tr('projects')),
      HomeNavItem(icon: Icons.task_alt_outlined, label: tr('tasks')),
      HomeNavItem(icon: Icons.settings_outlined, label: tr('settings')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = _items(context);
    return Consumer<ChangeIndexController>(
      builder: (context, controller, _) {
        return Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
          padding: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: ColorConsts.gunmetalBlue.withOpacity(0.15),
                blurRadius: 30,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: -5,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
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
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      items.length,
                      (index) => HomeNavItemWidget(
                        item: items[index],
                        index: index,
                        currentIndex: controller.index,
                        onTap: () => controller.changeIndexFunction(index),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class HomeNavItem {
  const HomeNavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class HomeNavItemWidget extends StatelessWidget {
  const HomeNavItemWidget({
    super.key,
    required this.item,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  final HomeNavItem item;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 1.0 + (value * 0.15),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isSelected
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  ColorConsts.gunmetalBlue.withOpacity(0.15 + value * 0.05),
                                  ColorConsts.gunmetalBlue.withOpacity(0.1 + value * 0.05),
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
                      child: Icon(
                        item.icon,
                        color: ColorConsts.gunmetalBlue,
                        size: 24,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                style: TextStyle(
                  fontFamily: 'Almarai-Bold',
                  color: ColorConsts.gunmetalBlue,
                  fontSize: isSelected ? 11.0 : 10.0,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                child: Text(
                  item.label,
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
