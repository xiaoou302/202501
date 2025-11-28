import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final List<DateTime> loggedDates;
  final Function(DateTime) onDateSelected;

  const CalendarWidget({
    super.key,
    required this.selectedDate,
    required this.loggedDates,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMonthSelector(),
        const SizedBox(height: 12),
        _buildCalendarGrid(),
      ],
    );
  }

  Widget _buildMonthSelector() {
    return Center(
      child: Text(
        '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
        style: const TextStyle(
          color: AppConstants.offWhite,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Column(
      children: [
        _buildWeekDays(),
        const SizedBox(height: 6),
        _buildDaysGrid(),
      ],
    );
  }

  Widget _buildWeekDays() {
    const weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekDays
          .map((day) => SizedBox(
                width: 36,
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      color: AppConstants.midGray,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildDaysGrid() {
    final daysInMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final startingWeekday = firstDayOfMonth.weekday % 7;
    final today = DateTime.now();
    final isCurrentMonth = selectedDate.year == today.year && selectedDate.month == today.month;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.0,
      ),
      itemCount: daysInMonth + startingWeekday,
      itemBuilder: (context, index) {
        if (index < startingWeekday) {
          return const SizedBox();
        }

        final day = index - startingWeekday + 1;
        final date = DateTime(selectedDate.year, selectedDate.month, day);
        final isSelected = date.day == selectedDate.day &&
            date.month == selectedDate.month &&
            date.year == selectedDate.year;
        final isToday = isCurrentMonth && day == today.day;
        final hasLog = loggedDates.any((d) =>
            d.day == date.day && d.month == date.month && d.year == date.year);

        return GestureDetector(
          onTap: () => onDateSelected(date),
          child: Container(
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppConstants.theatreRed,
                        AppConstants.balletPink,
                      ],
                    )
                  : null,
              color: isSelected
                  ? null
                  : (isToday
                      ? AppConstants.graphite.withValues(alpha: 0.5)
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(12),
              border: isToday && !isSelected
                  ? Border.all(
                      color: AppConstants.theatreRed.withValues(alpha: 0.5),
                      width: 1.5,
                    )
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppConstants.theatreRed.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isToday
                            ? AppConstants.theatreRed
                            : AppConstants.offWhite),
                    fontSize: 13,
                    fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                if (hasLog && !isSelected)
                  Positioned(
                    bottom: 4,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppConstants.theatreRed,
                            AppConstants.balletPink,
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.theatreRed.withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
