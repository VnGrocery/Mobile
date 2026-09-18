import 'package:flutter/material.dart';

import 'package:vngrocery/core/widgets/collapsible_list.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_palette.dart';

/// The specification table.
///
/// Renders nothing at all when the seller filled none in, rather than an empty
/// card: a heading over a blank box reads as a loading failure.
class ProductSpecsTable extends StatelessWidget {
  /// Rows shown before the table offers to expand. Six fits on a phone screen
  /// without pushing the price history out of reach.
  static const collapsedRows = 6;

  final List<SpecItem> specs;

  const ProductSpecsTable({super.key, required this.specs});

  @override
  Widget build(BuildContext context) {
    if (specs.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.productDetailSpecsTitle,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          // The change log's collapse behaviour, reused: same show-more
          // wording, same accessible ink on the toggle.
          child: CollapsibleList(
            itemCount: specs.length,
            collapsedCount: collapsedRows,
            itemBuilder: (context, index, _) =>
                _SpecRow(spec: specs[index], shaded: index.isOdd),
          ),
        ),
      ],
    );
  }
}

class _SpecRow extends StatelessWidget {
  final SpecItem spec;
  final bool shaded;

  const _SpecRow({required this.spec, required this.shaded});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      color: shaded ? palette.mutedSurface : palette.card,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              spec.key,
              style: TextStyle(fontSize: 13, color: palette.textSecondary),
            ),
          ),
          const SizedBox(width: 12),
          // Wraps rather than ellipsising: a storage instruction cut off
          // halfway is worse than a tall row.
          Expanded(
            child: Text(
              spec.value,
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// The long-form description, collapsed until asked for.
class ProductDescriptionBlocks extends StatefulWidget {
  /// Roughly two or three paragraphs: enough to judge whether to read on,
  /// short enough that the comments below stay within reach of a thumb.
  static const collapsedHeight = 320.0;

  final List<DescBlock> blocks;

  /// The flat description carried by every product created before blocks
  /// existed. Used only when [blocks] is empty.
  final String fallbackText;

  const ProductDescriptionBlocks({
    super.key,
    required this.blocks,
    required this.fallbackText,
  });

  @override
  State<ProductDescriptionBlocks> createState() =>
      _ProductDescriptionBlocksState();
}

class _ProductDescriptionBlocksState extends State<ProductDescriptionBlocks> {
  final _headerKey = GlobalKey();
  bool _expanded = false;

  List<DescBlock> get _blocks {
    if (widget.blocks.isNotEmpty) return widget.blocks;
    final text = widget.fallbackText.trim();
    if (text.isEmpty) return const [];
    return [DescBlock(type: DescBlock.paragraph, text: text)];
  }

  void _collapse() {
    setState(() => _expanded = false);
    // Collapsing from far down the article would otherwise drop the reader
    // into the comments with no idea where they landed.
    final headerContext = _headerKey.currentContext;
    if (headerContext == null) return;
    Scrollable.ensureVisible(
      headerContext,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final blocks = _blocks;
    if (blocks.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (final block in blocks) _DescBlockView(block: block)],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.productDetailDescriptionTitle,
          key: _headerKey,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (_expanded)
          body
        else
          _FadedPreview(
            maxHeight: ProductDescriptionBlocks.collapsedHeight,
            child: body,
          ),
        Center(
          child: TextButton.icon(
            onPressed: _expanded
                ? _collapse
                : () => setState(() => _expanded = true),
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            label: Text(
              _expanded
                  ? l10n.productDetailDescriptionCollapse
                  : l10n.productDetailDescriptionExpand,
            ),
          ),
        ),
      ],
    );
  }
}

/// Clips the description to [maxHeight] and fades its last strip out, so it
/// reads as continuing rather than as ending abruptly.
class _FadedPreview extends StatelessWidget {
  final double maxHeight;
  final Widget child;

  const _FadedPreview({required this.maxHeight, required this.child});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        // Opaque until the last 64dp, which is where the text fades out.
        stops: [0, (bounds.height - 64) / bounds.height, 1],
        colors: const [Colors.white, Colors.white, Colors.transparent],
      ).createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: ClipRect(
        child: SizedBox(
          height: maxHeight,
          child: OverflowBox(
            alignment: Alignment.topCenter,
            maxHeight: double.infinity,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _DescBlockView extends StatelessWidget {
  final DescBlock block;

  const _DescBlockView({required this.block});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    switch (block.type) {
      case DescBlock.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: Text(
            block.text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      case DescBlock.paragraph:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            block.text,
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
        );
      case DescBlock.bullets:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final item in block.items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16, top: 7, right: 8),
                        child: Icon(Icons.circle, size: 5),
                      ),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 15, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      case DescBlock.image:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  block.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // A broken illustration must not take the description down
                  // with it; the text around it is still worth reading.
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
              if (block.caption.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    block.caption,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: palette.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        );
      default:
        // Types this build does not know about are skipped rather than shown
        // as a gap. The server filters them too; this is the second line.
        return const SizedBox.shrink();
    }
  }
}
