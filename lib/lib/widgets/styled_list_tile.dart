import 'package:flutter/material.dart';
import 'package:lumotareas/lib/utils/constants.dart';

class StyledListTile extends StatelessWidget {
  final int index;
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final void Function()? onTap;

  const StyledListTile({
    super.key,
    required this.index,
    required this.title,
    this.subtitle,
    this.onTap,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final Color itemBackgroundColor =
        index.isOdd ? primaryColor : secondaryColor;
    return ListTile(
      leading: leading,
      trailing: trailing,
      title: title,
      subtitle: subtitle,
      tileColor: itemBackgroundColor,
      onTap: onTap,
    );
  }
}
