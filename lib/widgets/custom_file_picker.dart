import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_icons.dart';
import 'package:mindful_youth/provider/assessment_provider/assessment_provider.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
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
  final int maxFileSizeBytes;
  const CustomFilePicker({
    super.key,
    this.allowMultiple = false,
    this.icon,
    this.allowedExtensions,
    required this.questionId,
    this.maxFileSizeBytes = 5 * 1024 * 1024,
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
    if (result == null) return;
    // 1️⃣ separate into accepted vs oversized
    final List<PlatformFile> oversized =
        result.files.where((f) => f.size > widget.maxFileSizeBytes).toList();
    final List<PlatformFile> accepted =
        result.files.where((f) => f.size <= widget.maxFileSizeBytes).toList();
    // 2️⃣ notify user about any too-large files
    if (oversized.isNotEmpty) {
      final names = oversized.map((f) => f.name).join(', ');
      WidgetHelper.customSnackBar(
        title:
            'These files exceed the '
            '${(widget.maxFileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB limit: $names',
        isError: true,
        autoClose: false
      );
    }
    // 3️⃣ update state & provider with only the accepted ones
    if (accepted.isNotEmpty) {
      setState(() => _selectedFiles = accepted);
      assessmentProvider.makeFilesSelection(
        questionId: widget.questionId,
        selectedFiles: accepted,
        maxFileSize:widget.maxFileSizeBytes
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
                        leading: MethodHelper.buildFilePreview(file),
                        title: CustomText(text: file.name),
                        subtitle: CustomText(
                          text: '${(file.size / 1024).toStringAsFixed(2)} KB',
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            _selectedFiles.removeWhere(
                              (e) => e.name == file.name,
                            );
                            setState(() {});
                          },
                          child: AppIcons.delete,
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
