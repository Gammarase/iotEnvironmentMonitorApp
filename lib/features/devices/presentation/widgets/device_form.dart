import 'package:flutter/material.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';

/// Device form widget (shared between add and edit)
class DeviceForm extends StatefulWidget {
  final String? initialDeviceId;
  final String? initialName;
  final String? initialLatitude;
  final String? initialLongitude;
  final String? initialDescription;
  final bool? initialIsActive;
  final bool isEdit;
  final Function({
    required String name,
    String? deviceId,
    double? latitude,
    double? longitude,
    String? description,
    bool? isActive,
  }) onSubmit;
  final bool isLoading;

  const DeviceForm({
    super.key,
    this.initialDeviceId,
    this.initialName,
    this.initialLatitude,
    this.initialLongitude,
    this.initialDescription,
    this.initialIsActive,
    this.isEdit = false,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<DeviceForm> createState() => _DeviceFormState();
}

class _DeviceFormState extends State<DeviceForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _deviceIdController;
  late final TextEditingController _nameController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  late final TextEditingController _descriptionController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _deviceIdController = TextEditingController(text: widget.initialDeviceId);
    _nameController = TextEditingController(text: widget.initialName);
    _latitudeController = TextEditingController(text: widget.initialLatitude);
    _longitudeController = TextEditingController(text: widget.initialLongitude);
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _isActive = widget.initialIsActive ?? true;
  }

  @override
  void dispose() {
    _deviceIdController.dispose();
    _nameController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSubmit(
      deviceId: widget.isEdit ? null : _deviceIdController.text.trim(),
      name: _nameController.text.trim(),
      latitude: _latitudeController.text.isEmpty
          ? null
          : double.tryParse(_latitudeController.text),
      longitude: _longitudeController.text.isEmpty
          ? null
          : double.tryParse(_longitudeController.text),
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text.trim(),
      isActive: widget.isEdit ? _isActive : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!widget.isEdit) ...[
            CustomTextField(
              label: 'Device ID',
              hint: 'Enter unique device ID',
              controller: _deviceIdController,
              validator: (value) => Validators.validateRequired(value, 'Device ID'),
              enabled: !widget.isLoading,
              prefixIcon: const Icon(Icons.qr_code),
            ),
            const SizedBox(height: 16),
          ],
          CustomTextField(
            label: 'Device Name',
            hint: 'Enter device name',
            controller: _nameController,
            validator: Validators.validateName,
            enabled: !widget.isLoading,
            prefixIcon: const Icon(Icons.label_outline),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Latitude (optional)',
            hint: 'e.g., 50.4501',
            controller: _latitudeController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
            validator: Validators.validateLatitude,
            enabled: !widget.isLoading,
            prefixIcon: const Icon(Icons.location_on_outlined),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Longitude (optional)',
            hint: 'e.g., 30.5234',
            controller: _longitudeController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
            validator: Validators.validateLongitude,
            enabled: !widget.isLoading,
            prefixIcon: const Icon(Icons.location_on_outlined),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Description (optional)',
            hint: 'Enter device description',
            controller: _descriptionController,
            maxLines: 3,
            enabled: !widget.isLoading,
            prefixIcon: const Icon(Icons.description_outlined),
          ),
          if (widget.isEdit) ...[
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Active Status'),
              subtitle: Text(_isActive ? 'Device is active' : 'Device is inactive'),
              value: _isActive,
              onChanged: widget.isLoading
                  ? null
                  : (value) {
                      setState(() {
                        _isActive = value;
                      });
                    },
            ),
          ],
          const SizedBox(height: 24),
          CustomButton(
            label: widget.isEdit ? 'Update Device' : 'Create Device',
            onPressed: _handleSubmit,
            isLoading: widget.isLoading,
            icon: widget.isEdit ? Icons.save : Icons.add,
          ),
        ],
      ),
    );
  }
}
