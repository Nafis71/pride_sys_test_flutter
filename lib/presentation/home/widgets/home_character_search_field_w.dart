import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pride_sys_test_flutter/common/colors/app_colors.dart';
import 'package:pride_sys_test_flutter/common/utils/dimensions/app_padding.dart';

/// Debounced search field; calls [onQueryChanged] after user pauses typing.
class HomeCharacterSearchFieldW extends StatefulWidget {
  const HomeCharacterSearchFieldW({
    super.key,
    required this.onQueryChanged,
  });

  final ValueChanged<String> onQueryChanged;

  @override
  State<HomeCharacterSearchFieldW> createState() =>
      _HomeCharacterSearchFieldWState();
}

class _HomeCharacterSearchFieldWState extends State<HomeCharacterSearchFieldW> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  static const Duration _debounceDuration = Duration(milliseconds: 450);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scheduleDebouncedNotify);
  }

  void _scheduleDebouncedNotify() {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      if (mounted) {
        widget.onQueryChanged(_controller.text);
      }
    });
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    widget.onQueryChanged('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_scheduleDebouncedNotify);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppPaddings.kPaddingMedium.w,
        0,
        AppPaddings.kPaddingMedium.w,
        8.h,
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _controller,
        builder: (BuildContext context, TextEditingValue value, Widget? _) {
          return TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search by name…',
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.black.withValues(alpha: 0.45),
                size: 22.sp,
              ),
              suffixIcon: value.text.isEmpty
                  ? null
                  : IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        size: 22.sp,
                        color: AppColors.black.withValues(alpha: 0.45),
                      ),
                      onPressed: _clear,
                    ),
              filled: true,
              fillColor: AppColors.cF2F2F2,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 12.h,
              ),
            ),
          );
        },
      ),
    );
  }
}
