import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_palette.dart';

/// Editor for the specification table.
///
/// Rows the seller leaves blank are their normal state - the form starts with
/// empty ones - so they are dropped on save rather than flagged as errors.
class SellerSpecsEditor extends StatefulWidget {
  /// Empty rows offered when the product has none yet.
  static const starterRows = 3;

  final List<SpecItem> initial;
  final ValueChanged<List<SpecItem>> onChanged;

  const SellerSpecsEditor({
    super.key,
    required this.initial,
    required this.onChanged,
  });

  @override
  State<SellerSpecsEditor> createState() => _SellerSpecsEditorState();
}

class _SellerSpecsEditorState extends State<SellerSpecsEditor> {
  final _rows = <_SpecRowControllers>[];

  @override
  void initState() {
    super.initState();
    for (final spec in widget.initial) {
      _rows.add(_SpecRowControllers(key: spec.key, value: spec.value));
    }
    while (_rows.length < SellerSpecsEditor.starterRows) {
      _rows.add(_SpecRowControllers());
    }
  }

  @override
  void dispose() {
    for (final row in _rows) {
      row.dispose();
    }
    super.dispose();
  }

  void _publish() {
    widget.onChanged([
      for (final row in _rows)
        SpecItem(key: row.key.text.trim(), value: row.value.text.trim()),
    ]);
  }

  void _add() {
    setState(() => _rows.add(_SpecRowControllers()));
  }

  void _remove(int index) {
    setState(() => _rows.removeAt(index).dispose());
    _publish();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.sellerSpecsTitle,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.sellerSpecsHint,
          style: TextStyle(fontSize: 12, color: context.palette.textSecondary),
        ),
        const SizedBox(height: 12),
        for (final (index, row) in _rows.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: row.key,
                    onChanged: (_) => _publish(),
                    decoration: InputDecoration(
                      labelText: l10n.sellerSpecsKeyLabel,
                      isDense: true,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: row.value,
                    onChanged: (_) => _publish(),
                    // Storage instructions run long; the field grows instead
                    // of scrolling a single hidden line.
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: l10n.sellerSpecsValueLabel,
                      isDense: true,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _remove(index),
                  tooltip: l10n.sellerSpecsRemove,
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _add,
            icon: const Icon(Icons.add, size: 20),
            label: Text(l10n.sellerSpecsAdd),
          ),
        ),
      ],
    );
  }
}

class _SpecRowControllers {
  final TextEditingController key;
  final TextEditingController value;

  _SpecRowControllers({String key = '', String value = ''})
    : key = TextEditingController(text: key),
      value = TextEditingController(text: value);

  void dispose() {
    key.dispose();
    value.dispose();
  }
}

/// Editor for the long-form description, as a list of blocks.
///
/// Blocks rather than a rich-text box: nothing here needs sanitising before a
/// buyer sees it, and the change log can show which block moved.
class SellerDescriptionEditor extends StatefulWidget {
  final List<DescBlock> initial;
  final ValueChanged<List<DescBlock>> onChanged;

  const SellerDescriptionEditor({
    super.key,
    required this.initial,
    required this.onChanged,
  });

  @override
  State<SellerDescriptionEditor> createState() =>
      _SellerDescriptionEditorState();
}

class _SellerDescriptionEditorState extends State<SellerDescriptionEditor> {
  final _blocks = <_BlockControllers>[];

  @override
  void initState() {
    super.initState();
    for (final block in widget.initial) {
      _blocks.add(_BlockControllers.from(block));
    }
  }

  @override
  void dispose() {
    for (final block in _blocks) {
      block.dispose();
    }
    super.dispose();
  }

  void _publish() =>
      widget.onChanged([for (final block in _blocks) block.toBlock()]);

  void _addBlock(String type) {
    setState(() => _blocks.add(_BlockControllers(type: type)));
    _publish();
  }

  void _removeBlock(int index) {
    setState(() => _blocks.removeAt(index).dispose());
    _publish();
  }

  void _move(int index, int delta) {
    final target = index + delta;
    if (target < 0 || target >= _blocks.length) return;
    setState(() => _blocks.insert(target, _blocks.removeAt(index)));
    _publish();
  }

  /// Fills in the section headings most listings end up wanting, so the seller
  /// writes under prompts instead of into an empty box.
  void _applyTemplate() {
    final l10n = AppLocalizations.of(context);
    setState(() {
      for (final block in _blocks) {
        block.dispose();
      }
      _blocks
        ..clear()
        ..addAll([
          for (final heading in [
            l10n.sellerDescTemplateHighlights,
            l10n.sellerDescTemplateUsage,
            l10n.sellerDescTemplateStorage,
            l10n.sellerDescTemplatePackaging,
          ]) ...[
            _BlockControllers(type: DescBlock.heading, text: heading),
            _BlockControllers(type: DescBlock.paragraph),
          ],
        ]);
    });
    _publish();
  }

  String _hintFor(AppLocalizations l10n, String type) => switch (type) {
    DescBlock.heading => l10n.sellerDescHeadingHint,
    DescBlock.bullets => l10n.sellerDescBulletsHint,
    _ => l10n.sellerDescParagraphHint,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.sellerDescTitle,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: _applyTemplate,
              child: Text(l10n.sellerDescTemplate),
            ),
          ],
        ),
        for (final (index, block) in _blocks.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: block.text,
                    onChanged: (_) => _publish(),
                    maxLines: block.type == DescBlock.heading ? 1 : null,
                    style: block.type == DescBlock.heading
                        ? const TextStyle(fontWeight: FontWeight.bold)
                        : null,
                    decoration: InputDecoration(
                      hintText: _hintFor(l10n, block.type),
                      isDense: true,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: index == 0 ? null : () => _move(index, -1),
                      tooltip: l10n.sellerDescMoveUp,
                      icon: const Icon(Icons.arrow_upward, size: 18),
                    ),
                    IconButton(
                      onPressed: index == _blocks.length - 1
                          ? null
                          : () => _move(index, 1),
                      tooltip: l10n.sellerDescMoveDown,
                      icon: const Icon(Icons.arrow_downward, size: 18),
                    ),
                    IconButton(
                      onPressed: () => _removeBlock(index),
                      tooltip: l10n.sellerDescRemoveBlock,
                      icon: const Icon(Icons.close, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        Wrap(
          spacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: () => _addBlock(DescBlock.heading),
              icon: const Icon(Icons.title, size: 18),
              label: Text(l10n.sellerDescAddHeading),
            ),
            OutlinedButton.icon(
              onPressed: () => _addBlock(DescBlock.paragraph),
              icon: const Icon(Icons.notes, size: 18),
              label: Text(l10n.sellerDescAddParagraph),
            ),
            OutlinedButton.icon(
              onPressed: () => _addBlock(DescBlock.bullets),
              icon: const Icon(Icons.format_list_bulleted, size: 18),
              label: Text(l10n.sellerDescAddBullets),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // A quality claim typed here would bypass the pledge system, which is
        // the one record a buyer can actually check.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, size: 16, color: palette.textSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.sellerDescPledgeNotice,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: palette.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BlockControllers {
  final String type;
  final TextEditingController text;

  _BlockControllers({required this.type, String text = ''})
    : text = TextEditingController(text: text);

  factory _BlockControllers.from(DescBlock block) => _BlockControllers(
    type: block.type,
    // Bullets are edited as one line per item, which avoids a list of fields
    // inside a list of fields for what is a handful of short phrases.
    text: block.type == DescBlock.bullets
        ? block.items.join('\n')
        : block.text,
  );

  DescBlock toBlock() {
    if (type == DescBlock.bullets) {
      return DescBlock(
        type: type,
        items: text.text
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .toList(),
      );
    }
    return DescBlock(type: type, text: text.text.trim());
  }

  void dispose() => text.dispose();
}
