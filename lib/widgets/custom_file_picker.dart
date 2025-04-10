import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/provider/assessment_provider/assessment_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_colors.dart';
import '../app_const/app_size.dart';
import 'custom_container.dart';

class CustomFilePicker extends StatefulWidget {
  final bool allowMultiple;
  final IconData? icon;
  final List<String>? allowedExtensions;
  final int questionId;
  const CustomFilePicker({
    super.key,
    this.allowMultiple = false,
    this.icon,
    this.allowedExtensions,
    required this.questionId,
  });

  @override
  State<CustomFilePicker> createState() => _CustomFilePickerState();
}

class _CustomFilePickerState extends State<CustomFilePicker> {
  List<PlatformFile> _selectedFiles = [];

  Future<void> pickFiles({
    required AssessmentProvider assessmentProvider,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: widget.allowMultiple,
      type: FileType.custom,
      withData: true,
      allowedExtensions:
          widget.allowedExtensions ?? ["jpg", "pdf", "doc", "mp4"],
    );

    if (result != null) {
      setState(() {
        _selectedFiles = result.files;
      });
      assessmentProvider.makeFilesSelection(
        questionId: widget.questionId,
        selectedFiles: result.files,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AssessmentProvider assessmentProvider = context.read<AssessmentProvider>();
    return GestureDetector(
      onTap: () => pickFiles(assessmentProvider: assessmentProvider),
      child: CustomContainer(
        alignment: Alignment.center,
        width: 90.w,
        height: _selectedFiles.isEmpty ? 15.h : null,
        borderRadius: BorderRadius.circular(AppSize.size10),
        backGroundColor: AppColors.white,
        child:
            _selectedFiles.isNotEmpty
                ? ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    ..._selectedFiles.map(
                      (file) => ListTile(
                        leading: Icon(
                          Icons.insert_drive_file,
                          color: AppColors.grey,
                        ),
                        title: Text(file.name),
                        subtitle: Text(
                          '${(file.size / 1024).toStringAsFixed(2)} KB',
                        ),
                      ),
                    ),
                  ],
                )
                : Icon(
                  widget.icon ?? Icons.add,
                  size: AppSize.size30,
                  color: AppColors.primary,
                ),
      ),
    );
  }
}
