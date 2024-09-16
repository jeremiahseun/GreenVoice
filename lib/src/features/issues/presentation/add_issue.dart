import 'dart:io';

import 'package:flutter/material.dart';
import 'package:greenvoice/utils/styles/styles.dart';
import 'package:image_picker/image_picker.dart';

class AddIssueScreen extends StatefulWidget {
  const AddIssueScreen({super.key});

  @override
  _AddIssueScreenState createState() => _AddIssueScreenState();
}

class _AddIssueScreenState extends State<AddIssueScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _location;
  final List<File> _images = [];
  bool _postAnonymously = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Report an issue'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Issue',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTextField(_titleController, 'Title'),
            const SizedBox(height: 16),
            const Text('Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTextField(_descriptionController, 'Description', maxLines: 5),
            const SizedBox(height: 16),
            _buildLocationButton(),
            const SizedBox(height: 16),
            _buildImageGrid(),
            const SizedBox(height: 16),
            _buildAnonymousSwitch(),
            const SizedBox(height: 24),
            _buildPostButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.lightPrimaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildLocationButton() {
    return InkWell(
      onTap: () {
        // Implement location selection
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.lightPrimaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, size: 20),
            SizedBox(width: 8),
            Text('Add location'),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _images.length + 1,
      itemBuilder: (context, index) {
        if (index == _images.length) {
          return _buildAddPhotoButton();
        }
        return _buildImageTile(_images[index]);
      },
    );
  }

  Widget _buildImageTile(File image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        image,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildAddPhotoButton() {
    return InkWell(
      onTap: _showImageSourceBottomSheet,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightPrimaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.add_a_photo, color: Colors.pink),
      ),
    );
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Widget _buildAnonymousSwitch() {
    return Row(
      children: [
        const Text('Post anonymously'),
        const Spacer(),
        Switch(
          value: _postAnonymously,
          onChanged: (value) {
            setState(() {
              _postAnonymously = value;
            });
          },
          activeColor: AppColors.lightPrimaryColor,
        ),
      ],
    );
  }

  Widget _buildPostButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _postAnonymously ? _postIssue : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightPrimaryColor,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Post anonymously'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _postIssue,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Post'),
          ),
        ),
      ],
    );
  }

  void _postIssue() {
    // Implement issue posting logic
    print('Posting issue:');
    print('Title: ${_titleController.text}');
    print('Description: ${_descriptionController.text}');
    print('Location: $_location');
    print('Images: ${_images.length}');
    print('Post anonymously: $_postAnonymously');
  }
}
