import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme.dart';
import '../utils/app_strings.dart';

class EnhancedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int? maxLength;
  final int maxLines;
  final bool obscureText;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final bool autofocus;
  final bool enabled;
  final FocusNode? focusNode;
  final String? errorText;
  final String? helperText;
  final EdgeInsetsGeometry? contentPadding;

  const EnhancedTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.maxLines = 1,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.onSubmitted,
    this.onChanged,
    this.autofocus = false,
    this.enabled = true,
    this.focusNode,
    this.errorText,
    this.helperText,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            errorText: errorText,
            helperText: helperText,
            contentPadding: contentPadding,
            counterText: maxLength != null
                ? '${controller.text.length}/$maxLength'
                : null,
          ),
          validator: validator,
          keyboardType: keyboardType,
          maxLength: maxLength,
          maxLines: maxLines,
          obscureText: obscureText,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          onFieldSubmitted: onSubmitted,
          onChanged: onChanged,
          autofocus: autofocus,
          enabled: enabled,
          focusNode: focusNode,
        ),
      ],
    );
  }
}

class EnhancedDatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final String label;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? helperText;
  final bool enabled;

  const EnhancedDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.label,
    this.firstDate,
    this.lastDate,
    this.helperText,
    this.enabled = true,
  });

  Future<void> _selectDate(BuildContext context) async {
    if (!enabled) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.accentPurple,
              onPrimary: Colors.white,
              surface: AppTheme.darkBlue,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppTheme.darkBlue,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: AppTheme.inputVerticalPadding,
            ),
            decoration: AppTheme.datePickerDecoration.copyWith(
              color: enabled
                  ? AppTheme.darkBlue.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: enabled ? Colors.white : Colors.grey,
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: enabled ? AppTheme.accentPurple : Colors.grey,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              helperText!,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}

class EnhancedCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;
  final bool enabled;

  const EnhancedCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => onChanged(!value) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeColor: AppTheme.accentPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: enabled ? Colors.white : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EnhancedRadioGroup<T> extends StatelessWidget {
  final T value;
  final List<T> options;
  final List<String> labels;
  final ValueChanged<T?> onChanged;
  final bool enabled;
  final String? title;
  final Axis direction;

  const EnhancedRadioGroup({
    super.key,
    required this.value,
    required this.options,
    required this.labels,
    required this.onChanged,
    this.enabled = true,
    this.title,
    this.direction = Axis.vertical,
  }) : assert(options.length == labels.length);

  @override
  Widget build(BuildContext context) {
    final children = List.generate(
      options.length,
      (index) => InkWell(
        onTap: enabled ? () => onChanged(options[index]) : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Radio<T>(
                value: options[index],
                groupValue: value,
                onChanged: enabled ? (T? val) => onChanged(val) : null,
                activeColor: AppTheme.accentPurple,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  labels[index],
                  style: TextStyle(
                    color: enabled ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title!,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        if (direction == Axis.vertical)
          Column(children: children)
        else
          Row(
              children:
                  children.map((child) => Expanded(child: child)).toList()),
      ],
    );
  }
}

class EnhancedSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final bool enabled;

  const EnhancedSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => onChanged(!value) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: enabled ? Colors.white : Colors.grey,
              ),
            ),
            Switch(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeColor: AppTheme.accentPurple,
              activeTrackColor: AppTheme.accentPurple.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class EnhancedDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final List<String> labels;
  final ValueChanged<T?> onChanged;
  final String label;
  final bool enabled;
  final String? hint;

  const EnhancedDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.labels,
    required this.onChanged,
    required this.label,
    this.enabled = true,
    this.hint,
  }) : assert(items.length == labels.length);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: AppTheme.datePickerDecoration.copyWith(
            color: enabled
                ? AppTheme.darkBlue.withOpacity(0.5)
                : Colors.grey.withOpacity(0.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButton<T>(
                value: value,
                onChanged: enabled ? onChanged : null,
                isExpanded: true,
                underline: const SizedBox(),
                dropdownColor: AppTheme.darkBlue,
                hint: hint != null ? Text(hint!) : null,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: enabled ? AppTheme.accentPurple : Colors.grey,
                ),
                items: List.generate(
                  items.length,
                  (index) => DropdownMenuItem<T>(
                    value: items[index],
                    child: Text(
                      labels[index],
                      style: TextStyle(
                        color: enabled ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final bool collapsible;
  final bool initiallyExpanded;

  const FormSection({
    super.key,
    required this.title,
    required this.children,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0),
    this.collapsible = false,
    this.initiallyExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    if (collapsible) {
      return ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        initiallyExpanded: initiallyExpanded,
        tilePadding: const EdgeInsets.symmetric(horizontal: 0),
        childrenPadding: const EdgeInsets.only(top: 8),
        iconColor: AppTheme.accentPurple,
        collapsedIconColor: Colors.grey,
        children: children,
      );
    }

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
