import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../app_theme.dart';

class HorizontalTimeline extends StatelessWidget {
  final int activeStep;
  const HorizontalTimeline({super.key, required this.activeStep});

  @override
  Widget build(BuildContext context) {
    final steps = ["Стилисты", "Личные данные", "Оплата", "Завершение"];
    return SizedBox(
      height: 80,
      child: Row(
        children: List.generate(steps.length, (index) {
          final bool isActive = index == activeStep;
          return Expanded(
            child: TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.center,
              isFirst: index == 0,
              isLast: index == steps.length - 1,
              indicatorStyle: IndicatorStyle(
                width: 24,
                color: isActive ? AppColors.onPrimaryContainer : Colors.grey,
                indicatorXY: 0.5,
              ),
              beforeLineStyle: LineStyle(
                color: index <= activeStep ? AppColors.onPrimaryContainer : Colors.grey,
                thickness: 2,
              ),
              afterLineStyle: LineStyle(
                color: index < activeStep ? AppColors.onPrimaryContainer : Colors.grey,
                thickness: 2,
              ),
              endChild: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  steps[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? AppColors.onPrimaryContainer : Colors.grey,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
