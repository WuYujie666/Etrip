import 'package:egyptopia/features/wishlist/data/model/favorite_model.dart';
import 'package:egyptopia/features/wishlist/data/service/favorite_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteIcon extends StatefulWidget {
  final String id;
  final FavoriteType type;
  final String title;
  final String imageUrl;
  final String? additionalInfo;
  final String price;
  final String city;
  final double? iconSize;
  const FavoriteIcon({
    super.key,
    required this.id,
    required this.type,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.city,
    this.additionalInfo,
    this.iconSize,
  });

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  Widget build(BuildContext context) {
    final key = '${widget.id}_${widget.type.name}';

    return ValueListenableBuilder(
      valueListenable:
          Hive.box<FavoriteModel>(FavoriteService.boxName).listenable(),
      builder: (context, Box<FavoriteModel> box, _) {
        final isFav = box.containsKey(key);

        return IconButton(
          onPressed: () async {
            final model = FavoriteModel(
              id: widget.id,
              type: widget.type,
              title: widget.title,
              imageUrl: widget.imageUrl,
              additionalInfo: widget.additionalInfo,
              price: widget.price,
              city: widget.city,
            );
            await FavoriteService.toggleFavorite(model);
            if (!mounted) return;
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isFav
                      ? '${widget.title} has been removed from favorites'
                      : '${widget.title} has been added to favorites',
                  style: GoogleFonts.playfairDisplay(color: Colors.white),
                ),
                backgroundColor: Colors.black87,
                duration: const Duration(seconds: 1), // مدة عرض الـ Snackbar
              ),
            );
          },
          icon: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? Colors.red : Colors.black45,
            size: widget.iconSize ?? 35,
          ),
        );
      },
    );
  }
}
