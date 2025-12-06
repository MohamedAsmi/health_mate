import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/health_provider.dart';
import '../models/health_record.dart';

class AddEditRecordScreen extends StatefulWidget {
  final HealthRecord? record;

  const AddEditRecordScreen({super.key, this.record});

  @override
  State<AddEditRecordScreen> createState() => _AddEditRecordScreenState();
}

class _AddEditRecordScreenState extends State<AddEditRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _stepsController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _waterController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      _stepsController.text = widget.record!.steps.toString();
      _caloriesController.text = widget.record!.calories.toString();
      _waterController.text = widget.record!.water.toString();
      _selectedDate = DateTime.parse(widget.record!.date);
    }
  }

  @override
  void dispose() {
    _stepsController.dispose();
    _caloriesController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.record != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Record' : 'Add New Record'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Card
                    Card(
                      elevation: 2,
                      color: Colors.blue.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                isEditing
                                    ? 'Update your health record information'
                                    : 'Track your daily health activities',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildDateSelector(),
                    const SizedBox(height: 24),

                    _buildInputField(
                      controller: _stepsController,
                      label: 'Steps Walked',
                      icon: Icons.directions_walk,
                      color: Colors.green,
                      hint: 'Enter number of steps',
                      validator: _validateSteps,
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: _caloriesController,
                      label: 'Calories Burned (kcal)',
                      icon: Icons.local_fire_department,
                      color: Colors.orange,
                      hint: 'Enter calories burned',
                      validator: _validateCalories,
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: _waterController,
                      label: 'Water Intake (ml)',
                      icon: Icons.water_drop,
                      color: Colors.blue,
                      hint: 'Enter water intake in ml',
                      validator: _validateWater,
                    ),
                    const SizedBox(height: 32),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveRecord,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              isEditing ? 'Update' : 'Save',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDateSelector() {
    final dateFormat = DateFormat('EEEE, MMMM d, y');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: _selectDate,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.calendar_today, color: Colors.blue.shade700),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(_selectedDate),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: color),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  String? _validateSteps(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter steps walked';
    }
    final steps = int.tryParse(value);
    if (steps == null) {
      return 'Please enter a valid number';
    }
    if (steps < 0) {
      return 'Steps cannot be negative';
    }
    if (steps > 100000) {
      return 'Steps value seems too high';
    }
    return null;
  }

  String? _validateCalories(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter calories burned';
    }
    final calories = int.tryParse(value);
    if (calories == null) {
      return 'Please enter a valid number';
    }
    if (calories < 0) {
      return 'Calories cannot be negative';
    }
    if (calories > 10000) {
      return 'Calories value seems too high';
    }
    return null;
  }

  String? _validateWater(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter water intake';
    }
    final water = int.tryParse(value);
    if (water == null) {
      return 'Please enter a valid number';
    }
    if (water < 0) {
      return 'Water intake cannot be negative';
    }
    if (water > 10000) {
      return 'Water intake value seems too high';
    }
    return null;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveRecord() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final record = HealthRecord(
      id: widget.record?.id,
      date: _selectedDate.toIso8601String().split('T')[0],
      steps: int.parse(_stepsController.text),
      calories: int.parse(_caloriesController.text),
      water: int.parse(_waterController.text),
    );

    final provider = context.read<HealthProvider>();
    final bool success;

    if (widget.record != null) {
      success = await provider.updateRecord(record);
    } else {
      success = await provider.addRecord(record);
    }

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.record != null
                  ? 'Record updated successfully'
                  : 'Record added successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save record'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
