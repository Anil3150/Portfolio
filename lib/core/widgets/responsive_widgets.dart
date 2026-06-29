import 'package:flutter/material.dart';
import '../utils/breakpoints.dart';

/// Wraps content in a centered max-width container for web/desktop.
/// On mobile/tablet it passes through naturally.
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = AppBreakpoints.maxContent,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final sH = AppSpacing.sectionH(w);
        final sV = AppSpacing.sectionV(w);
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: padding ?? EdgeInsets.symmetric(horizontal: sH, vertical: sV),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Section header: title + gradient underline
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          title,
          style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Container(
          width: 56,
          height: 4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 16),
          Text(
            subtitle!,
            style: textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Responsive grid that switches columns based on width
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double itemMinWidth;
  final double spacing;
  final double runSpacing;
  final double? itemHeight;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.itemMinWidth = 320,
    this.spacing = 24,
    this.runSpacing = 24,
    this.itemHeight,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        int cols = (w / itemMinWidth).floor().clamp(1, 4);

        final List<Widget> rows = [];
        for (int i = 0; i < children.length; i += cols) {
          final rowChildren = children.skip(i).take(cols).toList();
          
          // Fill remaining slots in the last row with empty space if needed
          final paddedChildren = List<Widget>.from(rowChildren);
          while (paddedChildren.length < cols) {
            paddedChildren.add(const SizedBox.shrink());
          }

          final rowWidget = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: paddedChildren.asMap().entries.map((entry) {
              final isLast = entry.key == paddedChildren.length - 1;
              Widget child = entry.value;
              if (itemHeight != null && child is! SizedBox) { // ignore the SizedBox.shrink()
                child = SizedBox(height: itemHeight, child: child);
              }
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : spacing),
                  child: child,
                ),
              );
            }).toList(),
          );

          rows.add(rowWidget);
        }

        if (rows.isEmpty) return const SizedBox.shrink();

        // Add runSpacing between rows
        final List<Widget> columnChildren = [];
        for (int i = 0; i < rows.length; i++) {
          columnChildren.add(rows[i]);
          if (i < rows.length - 1) columnChildren.add(SizedBox(height: runSpacing));
        }

        return Column(
          crossAxisAlignment: itemHeight != null ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
          children: columnChildren,
        );
      },
    );
  }
}
