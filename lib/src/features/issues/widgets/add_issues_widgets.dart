import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final String? Function(String? value)? validator;
  final bool readOnly;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hint,
      this.inputFormatters,
      this.maxLines = 1,
      this.keyboardType = TextInputType.text,
      this.readOnly = false,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatters,
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
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
}

class LocationButton extends StatelessWidget {
  final String address;
  final VoidCallback onLocationSelected;

  const LocationButton(
      {super.key, required this.onLocationSelected, required this.address});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onLocationSelected,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.lightPrimaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on, size: 20),
            const Gap(8),
            Expanded(child: Text(address)),
          ],
        ),
      ),
    );
  }
}

class ImageGrid extends StatelessWidget {
  final List<File> images;
  final VoidCallback onImageAdded;
  final void Function(int index) onImageRemove;

  const ImageGrid({
    super.key,
    required this.images,
    required this.onImageAdded,
    required this.onImageRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length + 1,
      itemBuilder: (context, index) {
        if (index == images.length) {
          return AddPhotoButton(onPressed: onImageAdded);
        }
        return InkWell(
            onTap: () => onImageRemove(index),
            child: Visibility(
                visible: !kIsWeb,
                replacement: ImageTileWeb(image: images[index]),
                child: ImageTile(image: images[index])));
      },
    );
  }
}

class ImageTile extends StatelessWidget {
  final File image;

  const ImageTile({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        image,
        fit: BoxFit.cover,
      ),
    );
  }
}

class ImageTileWeb extends StatelessWidget {
  final File image;

  const ImageTileWeb({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        image.path,
        fit: BoxFit.cover,
      ),
    );
  }
}

class AddPhotoButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddPhotoButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightPrimaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.add_a_photo, color: Colors.pink),
      ),
    );
  }
}

class AnonymousSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AnonymousSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Post anonymously'),
        const Spacer(),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.lightPrimaryColor,
        ),
      ],
    );
  }
}
