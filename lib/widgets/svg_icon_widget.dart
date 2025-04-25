
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  final String path;
  final Color? color;
  final double? size;

  const SvgIcon(
      this.path, {super.key, 
        this.color,
        this.size = 24,
      });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      color: color,
      height: size,
      width: size,
    );
  }
}