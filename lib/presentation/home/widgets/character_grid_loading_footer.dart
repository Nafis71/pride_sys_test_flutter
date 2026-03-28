import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CharacterGridLoadingFooter extends StatelessWidget {
  const CharacterGridLoadingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
      child: Center(
        child: SizedBox(
          width: 28.w,
          height: 28.w,
          child: CupertinoActivityIndicator(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
