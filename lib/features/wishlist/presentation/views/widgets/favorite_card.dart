import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/core/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/wishlist/data/model/favorite_model.dart';
import 'package:egyptopia/features/wishlist/data/service/favorite_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'favorite_icon.dart';

class FavoriteCard extends StatelessWidget {
  final FavoriteType type;

  const FavoriteCard({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FavoriteModel>>(
      valueListenable:
          Hive.box<FavoriteModel>(FavoriteService.boxName).listenable(),
      builder: (context, box, _) {
        final favorites = box.values.where((fav) => fav.type == type).toList();

        if (favorites.isEmpty) {
          return Center(
            child: Text(
              'No Favorites yet',
              style:
                  GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        }

        return ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final fav = favorites[index];

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              child: Container(
                height: SizeConfig.defaultSize! * 18,
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        fav.imageUrl,
                        width: SizeConfig.defaultSize! * 13,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const HorizantalSpace(1),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fav.title,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const VerticalSpace(0.5),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16),
                              const HorizantalSpace(0.5),
                              Text(
                                fav.city,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      const Color.fromARGB(255, 119, 119, 119),
                                ),
                              ),
                            ],
                          ),
                          const VerticalSpace(0.8),
                          Row(
                            children: [
                              const Icon(Icons.discount, size: 16),
                              const HorizantalSpace(0.5),
                              Text(
                                "${fav.price} LE",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          if (fav.additionalInfo != null &&
                              fav.additionalInfo!.isNotEmpty)
                            Row(
                              children: [
                                Expanded(
                                  child: CustomJoinButton(
                                    text: "Join Now",
                                    onTap: () async {
                                      final uri =
                                          Uri.parse(fav.additionalInfo!);
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri);
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Could not launch the link')),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                const HorizantalSpace(0.5),
                                FavoriteIcon(
                                  id: fav.id,
                                  type: fav.type,
                                  title: fav.title,
                                  imageUrl: fav.imageUrl,
                                  additionalInfo: fav.additionalInfo,
                                  price: fav.price,
                                  city: fav.city,
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
