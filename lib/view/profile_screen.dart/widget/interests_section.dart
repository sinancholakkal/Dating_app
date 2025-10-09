import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InterestsSection extends StatelessWidget {
  final Set<String> selectedInterests;
  final ValueChanged<String> onInterestSelected;
  final List<String> allInterests;

  const InterestsSection({
    super.key,
    required this.selectedInterests,
    required this.onInterestSelected,
    required this.allInterests,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: allInterests.map((interest) {
        final bool isSelected = selectedInterests.contains(interest);
        return _InterestChip(
          label: interest,
          isSelected: isSelected,
          onSelected: () => onInterestSelected(interest),
        );
      }).toList(),
    );
  }
}

class _InterestChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _InterestChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 13,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      backgroundColor: isSelected
          ? primary.withOpacity(0.9)
          : const Color(0xFF23262B),
      selectedColor: primary.withOpacity(0.9),
      pressElevation: 0,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? Colors.transparent : kWhite.withOpacity(0.30),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
    );
  }
}

