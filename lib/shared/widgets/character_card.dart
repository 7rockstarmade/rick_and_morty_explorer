import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.species,
    this.isFavorite = false,
    this.onFavoritePressed,
    this.onTap,
  });

  final String imageUrl;
  final String name;
  final String species;
  final bool isFavorite;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onTap;

  static const _radius = 16.0;
  static const _imageSize = 72.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(_radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(_radius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: _imageSize,
                  height: _imageSize,
                  fit: BoxFit.cover,
                  placeholder: (context, _) => Container(
                    width: _imageSize,
                    height: _imageSize,
                    color: scheme.surfaceContainerHighest,
                  ),
                  errorWidget: (context, _, _) => Container(
                    width: _imageSize,
                    height: _imageSize,
                    color: scheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.person,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      species,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onFavoritePressed,
                icon: Icon(isFavorite ? Icons.star : Icons.star_border),
                tooltip: 'Favorite',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
