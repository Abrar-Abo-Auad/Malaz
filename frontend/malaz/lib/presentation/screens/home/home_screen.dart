import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/core/config/color/app_color.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/config/routes/route_info.dart';
import '../../../l10n/app_localizations.dart';
import '../../cubits/home/home_cubit.dart';
import '../../cubits/search/search_cubit.dart';
import '../../global_widgets/cards/apartment/apartment_card.dart';
import '../../global_widgets/cards/apartment/apartment_shimmer_card.dart';
import '../property/build_no_results_view.dart';
import '../side_drawer/app_drawer.dart';
import 'filter_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  bool _showStickyHeader = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    final cubit = context.read<HomeCubit>();
    if (cubit.state is HomeInitial) {
      cubit.loadApartments();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<HomeCubit>().loadApartments(loadNext: true);
    }

    if (_scrollController.hasClients) {
      final show = _scrollController.offset > 200;
      if (show != _showStickyHeader) {
        setState(() {
          _showStickyHeader = show;
        });
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (query.isNotEmpty) {
        context.read<SearchCubit>().search(query);
      } else {
        context.read<SearchCubit>().search("");
      }
    });
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutQuint,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            _BuildScrollableBody(
              scrollController: _scrollController,
              scaffoldKey: _scaffoldKey,
              onSearchChanged: _onSearchChanged,
            ),
            _BuildStickyHeader(
              isVisible: _showStickyHeader,
              onTapBack: _scrollToTop,
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// [UI_BUILDING_WIDGETS]
/// ============================================================================

/// [_BuildScrollableBody]
class _BuildScrollableBody extends StatelessWidget {
  final ScrollController scrollController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(String) onSearchChanged;

  const _BuildScrollableBody({
    required this.scrollController,
    required this.scaffoldKey,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<HomeCubit>().loadApartments(isRefresh: true);
      },
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: _BuildMainBrandingHeader(scaffoldKey: scaffoldKey),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),

          SliverPersistentHeader(
            pinned: true,
            delegate: _SearchAppBarDelegate(
              minHeight: 90,
              maxHeight: 90,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF1E1E1E)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8)
                          )
                        ],
                        border: Border.all(color: AppColors.primaryLight.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 15),
                          const Icon(Icons.search_rounded, color: AppColors.primaryLight, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              onChanged: onSearchChanged,
                              style: const TextStyle(fontSize: 16),
                              decoration: const InputDecoration(
                                hintText: "Search by title or owner...",
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => const FilterBottomSheet(),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(6),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: AppColors.premiumGoldGradient2,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.tune_rounded, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 10)),

          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, searchState) {
              if (searchState is SearchLoading) {
                return const SliverToBoxAdapter(child: _BuildShimmerLoading());
              }

              if (searchState is SearchSuccess) {
                if (searchState.results.isEmpty) return const BuildNoResultsView();

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => ApartmentCard(
                      apartment: searchState.results[index],
                      onTap: () => context.pushNamed(RouteNames.details, extra: searchState.results[index]),
                    ),
                    childCount: searchState.results.length,
                  ),
                );
              }

              return const _BuildHomeList();
            },
          ),
        ],
      ),
    );
  }
}

/// [_BuildHomeList]
class _BuildHomeList extends StatelessWidget {
  const _BuildHomeList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const SliverToBoxAdapter(child: _BuildShimmerLoading());
        }

        if (state is HomeError) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: _BuildErrorView(message: state.message),
          );
        }

        if (state is HomeLoaded) {
          if (state.apartments.isEmpty) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: _BuildErrorView(message: AppLocalizations.of(context).unexpected_error_message),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                if (index >= state.apartments.length) {
                  return state.hasReachedMax
                      ? const SizedBox.shrink()
                      : const _BuildBottomLoader();
                }
                final apartment = state.apartments[index];
                return ApartmentCard(
                  apartment: apartment,
                  onTap: () {
                    context.pushNamed(RouteNames.details, extra: apartment);
                  },
                );
              },
              childCount: state.hasReachedMax
                  ? state.apartments.length
                  : state.apartments.length + 1,
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}

/// [_BuildMainBrandingHeader]
class _BuildMainBrandingHeader extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const _BuildMainBrandingHeader({required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Stack(
        children: [
          Container(
            height: 100,
            decoration: const BoxDecoration(
              gradient: AppColors.premiumGoldGradient2,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 35, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _BuildIconButton(
                  icon: Icons.notes_rounded,
                  onTap: () => scaffoldKey.currentState?.openDrawer(),
                ),
                Text(
                  AppLocalizations.of(context).malaz,
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                    letterSpacing: 5,
                  ),
                ),
                _BuildIconButton(
                  icon: Icons.notifications_none_rounded,
                  onTap: () {},
                  showBadge: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// [_BuildStickyHeader]
class _BuildStickyHeader extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onTapBack;

  const _BuildStickyHeader({required this.isVisible, required this.onTapBack});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutBack,
      top: isVisible ? 90 : -80,
      left: 0,
      right: 0,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTapBack,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 100,
              height: 25,
              decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(32)),
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                color: theme.colorScheme.primary,
                size: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// [HELPER_WIDGETS]
/// ============================================================================
class _BuildIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool showBadge;

  const _BuildIconButton({required this.icon, required this.onTap, this.showBadge = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).scaffoldBackgroundColor),
            ),
            child: Icon(icon, size: 22, color: Theme.of(context).scaffoldBackgroundColor,),
          ),
          if (showBadge)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BuildBottomLoader extends StatelessWidget {
  const _BuildBottomLoader();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(24.0),
    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
  );
}

class _BuildShimmerLoading extends StatelessWidget {
  const _BuildShimmerLoading();
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: List.generate(3, (index) => Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
        child: const BuildShimmerCard(),
      ),
      ),
    );
  }
}

class _BuildErrorView extends StatelessWidget {
  final String message;
  const _BuildErrorView({required this.message});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<HomeCubit>().loadApartments(isRefresh: true),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}

class _SearchAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;
  _SearchAppBarDelegate({required this.minHeight, required this.maxHeight, required this.child});
  @override double get minExtent => minHeight;
  @override double get maxExtent => maxHeight;
  @override Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => SizedBox.expand(child: child);
  @override bool shouldRebuild(_SearchAppBarDelegate oldDelegate) => true;
}