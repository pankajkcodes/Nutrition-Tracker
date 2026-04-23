import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeatmapCalendar extends StatelessWidget {
  final Map<DateTime, int> datasets;
  final double cellSize;
  final double spacing;
  final int year;
  final int? highlightMonth;

  const HeatmapCalendar({
    super.key,
    required this.datasets,
    required this.year,
    this.highlightMonth,
    this.cellSize = 12.0,
    this.spacing = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the date range
    final DateTime startDate;
    final DateTime endDate;
    final double dayCellSize = highlightMonth != null ? 18.0 : 12.0;
    final double daySpacing = highlightMonth != null ? 5.0 : 3.0;

    if (highlightMonth != null) {
      startDate = DateTime(year, highlightMonth!, 1);
      endDate = DateTime(year, highlightMonth! + 1, 0); // Last day of selected month
    } else {
      startDate = DateTime(year, 1, 1);
      endDate = DateTime(year, 12, 31);
    }

    // Adjust start date to the beginning of that week (Monday) to keep grid aligned
    final adjustedStart = startDate.subtract(Duration(days: startDate.weekday - 1));
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activity Heatmap',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true, // Show most recent on the right
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDayLabels(dayCellSize, daySpacing),
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMonthLabels(startDate, endDate, dayCellSize, daySpacing),
                    const SizedBox(height: 4),
                    _buildGrid(startDate, endDate, dayCellSize, daySpacing),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildDayLabels(double dayCellSize, double daySpacing) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20), // Height of month labels
        ...labels.map((label) => SizedBox(
              height: dayCellSize + daySpacing,
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                      fontSize: dayCellSize * 0.55, // Slightly smaller font for more labels
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildMonthLabels(DateTime startDate, DateTime endDate, double dayCellSize, double daySpacing) {
    List<Widget> labels = [];
    DateTime current = startDate.subtract(Duration(days: startDate.weekday - 1));
    int? lastMonth;

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      if (current.month != lastMonth && (current.month == startDate.month || lastMonth != null)) {
        labels.add(
          SizedBox(
            width: 0,
            height: 20,
            child: UnconstrainedBox(
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.none,
              child: Text(
                DateFormat('MMM').format(current),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
        lastMonth = current.month;
      }
      
      labels.add(SizedBox(width: dayCellSize + daySpacing));
      current = current.add(const Duration(days: 7));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: labels,
    );
  }

  Widget _buildGrid(DateTime startDate, DateTime endDate, double dayCellSize, double daySpacing) {
    List<Widget> columns = [];
    DateTime current = startDate.subtract(Duration(days: startDate.weekday - 1));

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      columns.add(_buildWeekColumn(current, startDate, endDate, dayCellSize, daySpacing));
      current = current.add(const Duration(days: 7));
    }

    return Row(children: columns);
  }

  Widget _buildWeekColumn(DateTime weekStart, DateTime startDate, DateTime endDate, double dayCellSize, double daySpacing) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(7, (index) {
        final day = weekStart.add(Duration(days: index));
        
        // Hide days outside our range
        if (day.isBefore(startDate) || day.isAfter(endDate)) {
          return SizedBox(width: dayCellSize + daySpacing, height: dayCellSize + daySpacing);
        }
        
        final score = datasets[DateTime(day.year, day.month, day.day)] ?? 0;
        
        return Padding(
          padding: EdgeInsets.only(right: daySpacing, bottom: daySpacing),
          child: Tooltip(
            message: '${DateFormat('MMM d, yyyy').format(day)}: $score%',
            child: Container(
              width: dayCellSize,
              height: dayCellSize,
              decoration: BoxDecoration(
                color: _getColor(score),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        );
      }),
    );
  }

  Color _getColor(int score) {
    if (score == 0) return const Color(0xFFF3F4F6); // Soft light grey
    if (score < 25) return const Color(0xFFD1FAE5); // Emerald 100
    if (score < 50) return const Color(0xFF6EE7B7); // Emerald 300
    if (score < 75) return const Color(0xFF10B981); // Emerald 500
    if (score < 90) return const Color(0xFF059669); // Emerald 600
    return const Color(0xFF047857); // Emerald 700
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Less ', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
        _buildLegendBox(0),
        _buildLegendBox(15),
        _buildLegendBox(35),
        _buildLegendBox(55),
        _buildLegendBox(75),
        _buildLegendBox(95),
        Text(' More', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
      ],
    );
  }

  Widget _buildLegendBox(int score) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: _getColor(score),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
