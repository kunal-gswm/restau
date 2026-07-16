import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/shimmer_loader.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          // ─── App Bar Skeleton ──────────────────────────────────
          SliverAppBar(
            pinned: true,
            floating: true,
            elevation: 0,
            backgroundColor: AppColors.background.withValues(alpha: 0.97),
            toolbarHeight: 54,
            automaticallyImplyLeading: false,
            titleSpacing: AppSpacing.lg,
            title: const ShimmerContainer(width: 180, height: 36, borderRadius: AppRadii.pill),
            actions: const [
              ShimmerContainer(width: 36, height: 36, borderRadius: AppRadii.pill),
              SizedBox(width: AppSpacing.lg),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Greeting Skeleton ─────────────────────────────
                const Padding(
                  padding: EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xs),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerContainer(width: 100, height: 16, borderRadius: AppRadii.xs),
                      SizedBox(height: 8),
                      ShimmerContainer(width: 140, height: 28, borderRadius: AppRadii.xs),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppSpacing.md),

                // ─── Hero Banner Skeleton ──────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: const ShimmerContainer(
                    width: double.infinity,
                    height: 280,
                    borderRadius: AppRadii.xxl,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                
                // Pagination Dots Skeleton
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) => const ShimmerContainer(
                    width: 6, 
                    height: 6, 
                    borderRadius: AppRadii.pill, 
                    margin: EdgeInsets.symmetric(horizontal: 4)
                  )),
                ),

                const SizedBox(height: AppSpacing.lg),

                // ─── Loyalty Skeleton ──────────────────────────────
                Padding(
                  padding: AppSpacing.screenH,
                  child: const ShimmerContainer(
                    width: double.infinity,
                    height: 100,
                    borderRadius: AppRadii.xxl,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // ─── Category Pills Skeleton ───────────────────────
                SizedBox(
                  height: 52,
                  child: ListView.separated(
                    padding: AppSpacing.screenH,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    separatorBuilder: (c, i) => const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (c, i) => const ShimmerContainer(
                      width: 110,
                      height: 52,
                      borderRadius: AppRadii.pill,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // ─── Order Again Skeleton ──────────────────────────
                Padding(
                  padding: AppSpacing.screenH,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      ShimmerContainer(width: 140, height: 24, borderRadius: AppRadii.xs),
                      ShimmerContainer(width: 60, height: 16, borderRadius: AppRadii.xs),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 225,
                  child: ListView.separated(
                    padding: AppSpacing.screenH,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder: (c, i) => const SizedBox(width: AppSpacing.md),
                    itemBuilder: (c, i) => const ShimmerContainer(
                      width: 170,
                      height: 225,
                      borderRadius: AppRadii.xxl,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // ─── Today's Special Skeleton ──────────────────────
                Padding(
                  padding: AppSpacing.screenH,
                  child: const ShimmerContainer(width: 180, height: 24, borderRadius: AppRadii.xs),
                ),
                const SizedBox(height: AppSpacing.md),
                Padding(
                  padding: AppSpacing.screenH,
                  child: const ShimmerContainer(
                    width: double.infinity,
                    height: 400,
                    borderRadius: AppRadii.xxl,
                  ),
                ),
                const SizedBox(height: 120), // Bottom padding
              ],
            ),
          ),
        ],
      ),
    );
  }
}
