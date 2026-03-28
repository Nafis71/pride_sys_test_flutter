import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/common/colors/app_colors.dart';
import 'package:pride_sys_test_flutter/common/utils/dimensions/app_padding.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';
import 'package:pride_sys_test_flutter/presentation/character_details/view_models/edit_character_details_vm.dart';
import 'package:pride_sys_test_flutter/presentation/character_details/widgets/edit_character_field_w.dart';

class EditCharacterDetailsView extends StatefulWidget {
  const EditCharacterDetailsView({super.key});

  @override
  State<EditCharacterDetailsView> createState() =>
      _EditCharacterDetailsViewState();
}

class _EditCharacterDetailsViewState extends State<EditCharacterDetailsView> {
  static const String _editVmTag = 'edit_character';

  final EditCharacterDetailsVM _editCharacterDetailsVM = Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _statusController;
  late final TextEditingController _speciesController;
  late final TextEditingController _typeController;
  late final TextEditingController _genderController;
  late final TextEditingController _originNameController;
  late final TextEditingController _locationNameController;

  @override
  void initState() {
    super.initState();
    final CharacterEntity? character = _editCharacterDetailsVM
        .bindRouteArguments(Get.arguments);
    _nameController = TextEditingController(text: character?.name ?? '');
    _statusController = TextEditingController(text: character?.status ?? '');
    _speciesController = TextEditingController(text: character?.species ?? '');
    _typeController = TextEditingController(text: character?.type ?? '');
    _genderController = TextEditingController(text: character?.gender ?? '');
    _originNameController = TextEditingController(
      text: character?.originEntity?.name ?? '',
    );
    _locationNameController = TextEditingController(
      text: character?.locationEntity?.name ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    _speciesController.dispose();
    _typeController.dispose();
    _genderController.dispose();
    _originNameController.dispose();
    _locationNameController.dispose();
    Get.delete<EditCharacterDetailsVM>(tag: _editVmTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFAFAFA,
      appBar: AppBar(
        title: const Text('Edit character'),
        backgroundColor: AppColors.cFAFAFA,
        foregroundColor: AppColors.c1F222A,
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppPaddings.kPaddingMedium.w),
          children: [
            Text(
              'Edits are saved locally. Empty fields stay empty. Tap Restore (home) to reset all edits to cached API data.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.black.withValues(alpha: 0.6),
                  ),
            ),
            SizedBox(height: 20.h),
            EditCharacterField(label: 'Name', controller: _nameController),
            EditCharacterField(
              label: 'Status',
              controller: _statusController,
              hint: 'e.g. Alive, Dead, unknown',
            ),
            EditCharacterField(
              label: 'Species',
              controller: _speciesController,
            ),
            EditCharacterField(label: 'Type', controller: _typeController),
            EditCharacterField(label: 'Gender', controller: _genderController),
            EditCharacterField(
              label: 'Origin name',
              controller: _originNameController,
            ),
            EditCharacterField(
              label: 'Location name',
              controller: _locationNameController,
            ),
            SizedBox(height: 24.h),
            Obx(
              () => FilledButton(
                onPressed: _editCharacterDetailsVM.isSaving.value
                    ? null
                    : () => _editCharacterDetailsVM.submitFromFormInputs(
                        nameText: _nameController.text,
                        statusText: _statusController.text,
                        speciesText: _speciesController.text,
                        typeText: _typeController.text,
                        genderText: _genderController.text,
                        originNameText: _originNameController.text,
                        locationNameText: _locationNameController.text,
                      ),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  backgroundColor: AppColors.c1F222A,
                  foregroundColor: AppColors.white,
                ),
                child: _editCharacterDetailsVM.isSaving.value
                    ? SizedBox(
                        height: 22.h,
                        width: 22.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
