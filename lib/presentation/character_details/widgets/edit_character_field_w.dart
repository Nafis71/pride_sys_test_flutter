import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pride_sys_test_flutter/common/colors/app_colors.dart';

class EditCharacterField extends StatelessWidget {
  const EditCharacterField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}
