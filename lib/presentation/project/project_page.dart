import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/animation/reveal.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/launcher.dart';
import '../../core/widgets/hover_region.dart';
import '../../data/models/portfolio_content.dart';
import '../home/sections/footer_section.dart';
import '../home/sections/site_header.dart';
import '../widgets/pill_button.dart';
import 'photo_viewer.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({
    super.key,
    required this.project,
    required this.contact,
    required this.ownerName,
    this.next,
    this.onOpenNext,
  });

  final Project project;
  final ContactInfo contact;
  final String ownerName;
  final Project? next;
  final void Function(Project project)? onOpenNext;

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final ScrollController _controller = ScrollController();
  final ValueNotifier<double> _offset = ValueNotifier<double>(0);
  final GlobalKey _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!_controller.hasClients) return;
    _offset.value = _controller.offset;
  }

  @override
  void dispose() {
    _controller.removeListener(_handleScroll);
    _controller.dispose();
    _offset.dispose();
    super.dispose();
  }

  void _back() {
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) navigator.pop();
  }

  Future<void> _scrollToContact() async {
    final BuildContext? target = _contactKey.currentContext;
    if (target == null || !_controller.hasClients) return;
    final RenderObject? box = target.findRenderObject();
    if (box is! RenderBox || !box.attached) return;

    final double destination = (_controller.offset +
            box.localToGlobal(Offset.zero).dy -
            SiteHeader.totalHeight(context))
        .clamp(0.0, _controller.position.maxScrollExtent);

    await _controller.animateTo(
      destination,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScreenSize size = Breakpoints.of(context);
    final Project project = widget.project;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ScrollOffsetProvider(
        offset: _offset,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: SingleChildScrollView(
                controller: _controller,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: SiteHeader.totalHeight(context)),
                    Padding(
                      padding: EdgeInsets.only(
                        top: responsive<double>(size,
                            mobile: 18, tablet: 26, desktop: 32),
                      ),
                      child: ContentContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Reveal(
                              offsetY: 14,
                              child: _BackLink(onTap: _back),
                            ),
                            SizedBox(
                              height: responsive<double>(size,
                                  mobile: 18, tablet: 22, desktop: 26),
                            ),
                            _Intro(project: project, size: size),
                            if (project.gallery.isNotEmpty) ...<Widget>[
                              SizedBox(
                                height: responsive<double>(size,
                                    mobile: 24, tablet: 34, desktop: 40),
                              ),
                              _Gallery(photos: project.gallery, size: size),
                            ],
                            if (widget.next != null) ...<Widget>[
                              SizedBox(
                                height: responsive<double>(size,
                                    mobile: 30, tablet: 40, desktop: 48),
                              ),
                              Container(height: 1, color: AppColors.line),
                              SizedBox(
                                height: responsive<double>(size,
                                    mobile: 18, tablet: 24, desktop: 28),
                              ),
                              _NextProject(
                                project: widget.next!,
                                size: size,
                                onTap: widget.onOpenNext == null
                                    ? null
                                    : () => widget.onOpenNext!(widget.next!),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: responsive<double>(size,
                          mobile: 34, tablet: 56, desktop: 80),
                    ),
                    FooterSection(
                      key: _contactKey,
                      contact: widget.contact,
                      ownerName: widget.ownerName,
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
                scrollOffset: _offset,
                onContact: _scrollToContact,
                onLogoTap: _back,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackLink extends StatelessWidget {
  const _BackLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: onTap,
      builder: (BuildContext context, bool hovered) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedSlide(
              duration: const Duration(milliseconds: 220),
              offset: Offset(hovered ? -0.3 : 0, 0),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 15,
                color: hovered ? AppColors.primary : AppColors.primaryDeep,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'TOUS LES PROJETS',
              style: AppText.linkAll.copyWith(
                color: hovered ? AppColors.ink : AppColors.inkSoft,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro({required this.project, required this.size});

  final Project project;
  final ScreenSize size;

  @override
  Widget build(BuildContext context) {
    final bool wide = size != ScreenSize.mobile;
    final Widget heading = _Heading(project: project, size: size);
    final bool hasFacts = project.client.isNotEmpty ||
        project.year.isNotEmpty ||
        project.role.isNotEmpty ||
        (project.url ?? '').trim().isNotEmpty;

    if (!hasFacts) return Reveal(child: heading);

    final Widget facts = _Facts(project: project);

    if (wide) {
      return Reveal(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(flex: 7, child: heading),
            const SizedBox(width: 52),
            Expanded(flex: 5, child: facts),
          ],
        ),
      );
    }

    return Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          heading,
          const SizedBox(height: 22),
          facts,
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.project, required this.size});

  final Project project;
  final ScreenSize size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (project.subtitle.trim().isNotEmpty) ...<Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 26,
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 9),
              Flexible(
                child: Text(
                  project.subtitle.toUpperCase(),
                  style: AppText.kicker,
                ),
              ),
            ],
          ),
          SizedBox(
            height:
                responsive<double>(size, mobile: 12, tablet: 14, desktop: 16),
          ),
        ],
        Text(
          project.title,
          style: AppText.sectionKicker(
            responsive<double>(size, mobile: 30, tablet: 38, desktop: 46),
          ),
        ),
        if (project.description.isNotEmpty) ...<Widget>[
          SizedBox(
            height:
                responsive<double>(size, mobile: 12, tablet: 14, desktop: 16),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: responsive<double>(size,
                  mobile: 520, tablet: 540, desktop: 580),
            ),
            child: Text(
              project.description,
              style: AppText.sectionDesc.copyWith(
                fontSize: responsive<double>(size,
                    mobile: 13.5, tablet: 14, desktop: 15),
                height: 1.75,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _Facts extends StatelessWidget {
  const _Facts({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final String link = (project.url ?? '').trim();
    final List<List<String>> rows = <List<String>>[
      if (project.client.isNotEmpty) <String>['Client', project.client],
      if (project.year.isNotEmpty) <String>['Année', project.year],
      if (project.role.isNotEmpty) <String>['Rôle', project.role],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (rows.isNotEmpty)
          DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.line)),
            ),
            child: Column(
              children: <Widget>[
                for (final List<String> row in rows)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: AppColors.line)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(row[0].toUpperCase(), style: AppText.kicker),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            row[1],
                            textAlign: TextAlign.right,
                            style: AppText.featureTitle,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        if (link.isNotEmpty) ...<Widget>[
          const SizedBox(height: 18),
          PillButton(
            label: 'Voir le projet en ligne',
            icon: Icons.north_east_rounded,
            onTap: () => AppLauncher.website(context, link),
          ),
        ],
      ],
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({required this.photos, required this.size});

  static const double _fallbackRatio = 4 / 3;

  final List<ProjectPhoto> photos;
  final ScreenSize size;

  int get _columns => photos.length < 2
      ? 1
      : responsive<int>(size, mobile: 1, tablet: 2, desktop: 2);

  List<List<int>> _distribute() {
    final int count = _columns;
    final List<List<int>> columns =
        List<List<int>>.generate(count, (_) => <int>[]);
    if (count == 1) {
      for (int i = 0; i < photos.length; i++) {
        columns.first.add(i);
      }
      return columns;
    }

    final List<double> weights = List<double>.filled(count, 0);
    for (int index = 0; index < photos.length; index++) {
      final ProjectPhoto photo = photos[index];
      int target = 0;
      for (int i = 1; i < count; i++) {
        if (weights[i] < weights[target]) target = i;
      }
      columns[target].add(index);
      final double ratio = photo.aspectRatio ?? _fallbackRatio;
      weights[target] += 1 / ratio + (photo.caption.isEmpty ? 0.06 : 0.12);
    }
    return columns;
  }

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) return const SizedBox.shrink();

    final double gap =
        responsive<double>(size, mobile: 12, tablet: 16, desktop: 18);
    final List<List<int>> columns = _distribute();

    if (columns.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (int i = 0; i < photos.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: gap),
            Reveal(
              offsetY: 18,
              child: _Shot(
                key: ValueKey<String>('$i|${photos[i].url}'),
                photo: photos[i],
                onTap: () => showPhotoViewer(context,
                    photos: photos, index: i),
              ),
            ),
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int c = 0; c < columns.length; c++) ...<Widget>[
          if (c > 0) SizedBox(width: gap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 0; i < columns[c].length; i++) ...<Widget>[
                  if (i > 0) SizedBox(height: gap),
                  Reveal(
                    offsetY: 18,
                    delay: Duration(milliseconds: 60 * c + 40 * i),
                    child: _Shot(
                      key: ValueKey<String>(
                          '${columns[c][i]}|${photos[columns[c][i]].url}'),
                      photo: photos[columns[c][i]],
                      onTap: () => showPhotoViewer(context,
                          photos: photos, index: columns[c][i]),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Shot extends StatefulWidget {
  const _Shot({super.key, required this.photo, this.onTap});

  final ProjectPhoto photo;
  final VoidCallback? onTap;

  @override
  State<_Shot> createState() => _ShotState();
}

class _ShotState extends State<_Shot> {
  ImageStream? _stream;
  ImageStreamListener? _listener;
  double? _measured;

  late final ImageProvider _provider = NetworkImage(widget.photo.url);

  double get _ratio =>
      widget.photo.aspectRatio ?? _measured ?? _Gallery._fallbackRatio;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.photo.aspectRatio != null || _stream != null) return;
    _stream = _provider.resolve(createLocalImageConfiguration(context));
    _listener = ImageStreamListener(_onFrame, onError: _onError);
    _stream!.addListener(_listener!);
  }

  void _detach() {
    final ImageStream? stream = _stream;
    final ImageStreamListener? listener = _listener;
    if (stream != null && listener != null) stream.removeListener(listener);
    _listener = null;
  }

  void _onFrame(ImageInfo info, bool _) {
    final double ratio = info.image.width / info.image.height;
    info.dispose();
    scheduleMicrotask(_detach);
    if (!mounted || ratio <= 0) return;
    setState(() => _measured = ratio.clamp(0.4, 3.0));
  }

  void _onError(Object error, StackTrace? stack) {
    scheduleMicrotask(_detach);
    if (!mounted) return;
    setState(() => _measured = _Gallery._fallbackRatio);
  }

  @override
  void dispose() {
    _detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: HoverRegion(
            onTap: widget.onTap,
            cursor: widget.onTap == null
                ? MouseCursor.defer
                : SystemMouseCursors.zoomIn,
            builder: (BuildContext context, bool hovered) {
              return Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(18),
                ),
                foregroundDecoration: BoxDecoration(
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: AspectRatio(
                  aspectRatio: _ratio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      AnimatedScale(
                        duration: const Duration(milliseconds: 420),
                        curve: Curves.easeOut,
                        scale: hovered && widget.onTap != null ? 1.03 : 1,
                        child: Image(
                          image: _provider,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stack) =>
                              const Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: AppColors.inkSoft,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      if (widget.onTap != null)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 220),
                            opacity: hovered ? 1 : 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                              child: const Icon(
                                Icons.open_in_full_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.photo.caption.isNotEmpty) ...<Widget>[
          const SizedBox(height: 8),
          Text(
            widget.photo.caption,
            style: AppText.testimonialRole.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}

class _NextProject extends StatelessWidget {
  const _NextProject({
    required this.project,
    required this.size,
    this.onTap,
  });

  final Project project;
  final ScreenSize size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: onTap,
      builder: (BuildContext context, bool hovered) {
        return Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('PROJET SUIVANT', style: AppText.kicker),
                  const SizedBox(height: 5),
                  Text(
                    project.title,
                    style: AppText.sectionKicker(
                      responsive<double>(size,
                          mobile: 21, tablet: 24, desktop: 28),
                    ).copyWith(
                      color: hovered ? AppColors.primaryDeep : AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 18),
            AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              width: responsive<double>(size, mobile: 40, tablet: 44, desktop: 46),
              height: responsive<double>(size, mobile: 40, tablet: 44, desktop: 46),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hovered ? AppColors.primary : AppColors.ink,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: AppColors.cream,
              ),
            ),
          ],
        );
      },
    );
  }
}
