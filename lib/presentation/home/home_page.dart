import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../admin_mode.dart';
import '../../core/animation/reveal.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/portfolio_content.dart';
import '../../data/repositories/admin_repository.dart';
import '../../data/repositories/portfolio_repository.dart';
import '../widgets/admin_entry_button.dart';
import 'sections/about_section.dart';
import 'sections/footer_section.dart';
import 'sections/hero_section.dart';
import 'sections/projects_section.dart';
import 'sections/site_header.dart';
import 'sections/skills_section.dart';
import 'sections/testimonials_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.content,
    required this.repository,
    this.adminRepository,
    this.onContentChanged,
  });

  final PortfolioContent content;
  final PortfolioRepository repository;
  final AdminRepository? adminRepository;
  final VoidCallback? onContentChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier<double>(0);

  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _testimonialsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    _scrollOffset.value = _scrollController.offset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  Future<void> _scrollTo(GlobalKey key, {double extra = 0}) async {
    final BuildContext? targetContext = key.currentContext;
    if (targetContext == null || !_scrollController.hasClients) return;
    final RenderObject? box = targetContext.findRenderObject();
    if (box is! RenderBox || !box.attached) return;

    final double headerHeight = SiteHeader.totalHeight(context);
    final double target = (_scrollController.offset +
            box.localToGlobal(Offset.zero).dy -
            headerHeight -
            extra)
        .clamp(0.0, _scrollController.position.maxScrollExtent);

    await _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 750),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _scrollToTop() {
    if (!_scrollController.hasClients) return Future<void>.value();
    return _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
    );
  }

  void _goHome() {
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.popUntil((Route<dynamic> route) => route.isFirst);
    }
    _scrollToTop();
  }

  @override
  Widget build(BuildContext context) {
    final PortfolioContent content = widget.content;
    final ScreenSize size = Breakpoints.of(context);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: ScrollOffsetProvider(
        offset: _scrollOffset,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    HeroSection(
                      profile: content.profile,
                      topPadding: SiteHeader.totalHeight(context) -
                          SiteHeader.barHeight(context) * 0.45,
                      onProjects: () => _scrollTo(_projectsKey, extra: 12),
                      onContact: () => _scrollTo(_contactKey),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: ContentContainer(
                        child: Container(height: 1, color: AppColors.line),
                      ),
                    ),
                    if (content.about.isShown)
                      AboutSection(
                        key: _aboutKey,
                        about: content.about,
                        signature: content.profile.signature,
                      ),
                    SkillsSection(
                      key: _skillsKey,
                      copy: content.skillsSection,
                      skills: content.skills,
                      quote: content.quote,
                      features: content.features,
                    ),
                    ProjectsSection(
                      key: _projectsKey,
                      copy: content.projectsSection,
                      projects: content.projects,
                      onSeeAll: () => _scrollTo(_projectsKey, extra: 12),
                    ),
                    if (content.testimonialsVisible)
                      TestimonialsSection(
                        key: _testimonialsKey,
                        copy: content.testimonialsSection,
                        testimonials: content.testimonials,
                        onSubmitReview: widget.repository.acceptsReviews
                            ? widget.repository.submitReview
                            : null,
                      ),
                    FooterSection(
                      key: _contactKey,
                      contact: content.contact,
                      ownerName: content.profile.fullName,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SiteHeader(
                scrollOffset: _scrollOffset,
                onContact: () => _scrollTo(_contactKey),
                onLogoTap: _goHome,
                navItems: <NavItem>[
                  if (content.about.isShown)
                    NavItem(
                      label: 'À propos',
                      onTap: () => _scrollTo(_aboutKey, extra: 12),
                    ),
                  NavItem(
                    label: 'Projets',
                    onTap: () => _scrollTo(_projectsKey, extra: 12),
                  ),
                  if (content.testimonialsVisible)
                    NavItem(
                      label: 'Avis',
                      onTap: () => _scrollTo(_testimonialsKey, extra: 12),
                    ),
                ],
              ),
            ),
            Positioned(
              right: Breakpoints.gutter(size),
              bottom: Breakpoints.gutter(size),
              child: _BackToTopButton(
                scrollOffset: _scrollOffset,
                onTap: _scrollToTop,
              ),
            ),
            if (kAdminVisible && widget.adminRepository != null)
              Positioned(
                left: Breakpoints.gutter(size),
                bottom: Breakpoints.gutter(size),
                child: AdminEntryButton(
                  repository: widget.adminRepository!,
                  onClosed: widget.onContentChanged,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BackToTopButton extends StatelessWidget {
  const _BackToTopButton({required this.scrollOffset, required this.onTap});

  final ValueListenable<double> scrollOffset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: scrollOffset,
      builder: (BuildContext context, double offset, Widget? child) {
        final bool visible = offset > 420;
        return IgnorePointer(
          ignoring: !visible,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 260),
            offset: Offset(0, visible ? 0 : 0.4),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 260),
              opacity: visible ? 1 : 0,
              child: child,
            ),
          ),
        );
      },
      child: Material(
        color: AppColors.ink,
        shape: const CircleBorder(),
        elevation: 6,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: const SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              Icons.arrow_upward_rounded,
              size: 18,
              color: AppColors.cream,
            ),
          ),
        ),
      ),
    );
  }
}
