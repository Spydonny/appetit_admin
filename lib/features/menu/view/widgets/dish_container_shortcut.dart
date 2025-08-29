import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/widgets.dart';

class DishContainerShortcut extends StatefulWidget {
  const DishContainerShortcut({super.key,
    required this.name, required this.description, required this.price, required this.imageUrl, this.onTap});
  final String imageUrl;
  final String name;
  final String description;
  final double price;
  final VoidCallback? onTap;

  @override
  State<DishContainerShortcut> createState() => _DishContainerShortcutState();
}

class _DishContainerShortcutState extends State<DishContainerShortcut> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    return GestureDetector(
      onTap: widget.onTap,
      child:DefaultContainer(
        width: screenWidth * 0.9,
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 180,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) =>
              const Icon(Icons.broken_image, size: 80),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 12),
                  Text(
                    widget.description,
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'От ${widget.price}',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
