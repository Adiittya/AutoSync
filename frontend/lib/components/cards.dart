import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? padding;
  final Color color;
  final List<Widget>? children;

  final bool showDetails, showIcon;

  const CustomCard({
    super.key,
    this.title,
    this.children,
    this.titleStyle,
    this.padding,
    this.showDetails = false,
    this.showIcon = false,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20, right: 1, left: 1),
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 0),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 0),
            blurRadius: 12,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 0),
            blurRadius: 4,
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Makes height adapt to content
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                if (title!.isEmpty)
                  SizedBox.shrink()
                else
                  Text(
                    title!,
                    style:
                        titleStyle ??
                        const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF001E3C),
                        ),
                  ),
                const SizedBox(width: 8),
                if (showIcon == true)
                  Icon(Icons.settings, size: 16, color: Colors.black87),
                Spacer(),
                if (showDetails == true) ...[
                  Text(
                    "Details",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.black87,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children ?? [],
            ),
          ),
        ],
      ),
    );
  }
}
