import 'package:flutter/material.dart';
import '../models/location_model.dart';

/// 位置卡片组件
class LocationCard extends StatelessWidget {
  final LocationModel location;
  final VoidCallback onTap;
  final double? distance;

  const LocationCard({
    Key? key,
    required this.location,
    required this.onTap,
    this.distance,
  }) : super(key: key);

  Color _getTypeColor() {
    switch (location.type) {
      case LocationType.place:
        return Colors.red;
      case LocationType.activity:
        return Colors.green;
      case LocationType.event:
        return Colors.purple;
    }
  }

  IconData _getTypeIcon() {
    switch (location.type) {
      case LocationType.place:
        return Icons.place;
      case LocationType.activity:
        return Icons.local_activity;
      case LocationType.event:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片区域
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 90,
                color: Colors.grey[300],
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 占位图
                    Center(
                      child: Icon(
                        _getTypeIcon(),
                        size: 36,
                        color: Colors.grey[400],
                      ),
                    ),
                    
                    // 类型标签
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getTypeColor(),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          location.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    // 评分
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 12, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              location.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 信息区域
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    location.nameEn,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (distance != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          _formatDistance(distance!),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (location.price != null && location.price! > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${location.price} ${location.currency ?? 'EGP'}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} 米';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} 公里';
    }
  }
}
