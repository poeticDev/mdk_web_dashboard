// 대시보드 화면을 구성한다.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/common/app_bar/common_app_bar.dart';
import 'package:web_dashboard/common/responsive/responsive_layout.dart';
import 'package:web_dashboard/features/dashboard/application/dashboard_controller.dart';
import 'package:web_dashboard/features/dashboard/application/state/dashboard_state.dart';
import 'package:web_dashboard/features/dashboard/presentation/widgets/dashboard_classroom_card.dart';
import 'package:web_dashboard/features/dashboard/presentation/widgets/dashboard_empty_state.dart';
import 'package:web_dashboard/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_classroom_card_view_model.dart';
import 'package:web_dashboard/routes/page_meta.dart';

const double _gridSpacing = 20;
const double _headerBottomSpacing = 24;
const double _gridBottomPadding = 24;
const double _mobileAspectRatio = 1.35;
const double _tabletAspectRatio = 1.2;
const double _desktopAspectRatio = 1.1;
const double _fourKAspectRatio = 1.05;

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DashboardState state = ref.watch(dashboardControllerProvider);
    final DashboardController controller =
        ref.read(dashboardControllerProvider.notifier);

    return Scaffold(
      appBar: const CommonAppBar(meta: AppPageMeta.dashboard),
      body: Padding(
        padding: context.responsivePagePadding(),
        child: _DashboardBody(
          state: state,
          controller: controller,
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.state, required this.controller});

  final DashboardState state;
  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DashboardHeader(
            metrics: state.metrics,
            filters: state.filters,
            totalFallbackCount: state.cards.length,
            isStreaming: state.isStreaming,
            onQueryChanged: controller.updateQuery,
            onToggleStatus: controller.toggleUsageStatus,
            onClearUsageFilters: controller.clearUsageFilters,
          ),
          const SizedBox(height: _headerBottomSpacing),
          if (state.cards.isEmpty && !state.isLoading)
            const SizedBox(
              height: 240,
              child: DashboardEmptyState(),
            )
          else
            _DashboardGrid(cards: state.cards),
          const SizedBox(height: _gridBottomPadding),
        ],
      ),
    );
  }
}

class _DashboardGrid extends StatelessWidget {
  const _DashboardGrid({required this.cards});

  final List<DashboardClassroomCardViewModel> cards;

  @override
  Widget build(BuildContext context) {
    final int columns = context.responsiveColumns(
      mobile: 1,
      tablet: 2,
      desktop: 3,
      fourK: 4,
    );
    final double aspectRatio = _resolveAspectRatio(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: _gridSpacing,
        crossAxisSpacing: _gridSpacing,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (BuildContext context, int index) {
        final DashboardClassroomCardViewModel card = cards[index];
        return DashboardClassroomCard(
          viewModel: card,
          onTap: () => _handleCardTap(context, card),
        );
      },
    );
  }

  void _handleCardTap(
    BuildContext context,
    DashboardClassroomCardViewModel card,
  ) {
    // TODO: classroom_detail 라우팅 연결
  }
}

double _resolveAspectRatio(BuildContext context) {
  if (context.isFourKLayout) {
    return _fourKAspectRatio;
  }
  if (context.isDesktopLayout) {
    return _desktopAspectRatio;
  }
  if (context.isTabletLayout) {
    return _tabletAspectRatio;
  }
  return _mobileAspectRatio;
}
