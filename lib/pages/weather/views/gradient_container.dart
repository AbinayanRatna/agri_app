import 'package:agri_app/pages/weather/constants/app_colors.dart';
import 'package:flutter/material.dart';


class GradientContainer extends StatelessWidget {
  const GradientContainer({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            AppColors.darkGreen,
            AppColors.darkGreen.withOpacity(.99),
            AppColors.darkGreen.withOpacity(.98),
            AppColors.darkGreen.withOpacity(.97),
            AppColors.darkGreen.withOpacity(.96),
            AppColors.darkGreen.withOpacity(.95),
            AppColors.darkGreen.withOpacity(.94),
            AppColors.darkGreen.withOpacity(.93),
            AppColors.darkGreen.withOpacity(.92),
            AppColors.darkGreen.withOpacity(.91),
            AppColors.darkGreen.withOpacity(.90),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 36.0,
        ),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
