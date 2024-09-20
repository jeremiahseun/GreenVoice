import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/src/models/project/project_model.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class ProjectStatusPicker extends StatefulWidget {
  final ProjectStatus initialStatus;
  final ValueChanged<ProjectStatus> onStatusChanged;

  const ProjectStatusPicker({
    super.key,
    required this.initialStatus,
    required this.onStatusChanged,
  });

  @override
  _ProjectStatusPickerState createState() => _ProjectStatusPickerState();
}

class _ProjectStatusPickerState extends State<ProjectStatusPicker> {
  late ProjectStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
            onTap: () => _showStatusPicker(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightPrimaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.view_kanban_outlined, size: 20),
                  const Gap(8),
                  Expanded(
                      child: Text(switch (_selectedStatus) {
                    ProjectStatus.closed => "Closed",
                    ProjectStatus.open => "Open",
                    ProjectStatus.inProgress => "In Progress",
                  })),
                ],
              ),
            )),
      ],
    );
  }

  void _showStatusPicker(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: CupertinoPicker(
              magnification: 1.22,
              squeeze: 1.2,
              useMagnifier: true,
              itemExtent: 32,
              onSelectedItemChanged: (int selectedItem) {
                setState(() {
                  _selectedStatus = ProjectStatus.values[selectedItem];
                  widget.onStatusChanged(_selectedStatus);
                });
              },
              children: List<Widget>.generate(ProjectStatus.values.length,
                  (int index) {
                final status = ProjectStatus.values[index];
                return Center(
                  child: Text(
                    switch (status) {
                      ProjectStatus.closed => "Closed",
                      ProjectStatus.open => "Open",
                      ProjectStatus.inProgress => "In Progress",
                    },
                  ),
                );
              }),
            ),
          ),
        ),
      );
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Project Status'),
            content: DropdownButton<ProjectStatus>(
              value: _selectedStatus,
              underline: const SizedBox(),
              onChanged: (ProjectStatus? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedStatus = newValue;
                    widget.onStatusChanged(_selectedStatus);
                  });
                  Navigator.of(context).pop();
                }
              },
              items: ProjectStatus.values.map((ProjectStatus status) {
                return DropdownMenuItem<ProjectStatus>(
                  value: status,
                  child: Text(switch (status) {
                    ProjectStatus.closed => "Closed",
                    ProjectStatus.open => "Open",
                    ProjectStatus.inProgress => "In Progress",
                  }),
                );
              }).toList(),
            ),
          );
        },
      );
    }
  }
}
