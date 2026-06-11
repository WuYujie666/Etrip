import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/location_model.dart';

/// 位置详情底部弹窗
class LocationDetailSheet extends StatelessWidget {
  final LocationModel location;
  final VoidCallback? onAddToItinerary;
  final VoidCallback? onAddToWishlist;
  final VoidCallback? onNavigate;

  const LocationDetailSheet({
    Key? key,
    required this.location,
    this.onAddToItinerary,
    this.onAddToWishlist,
    this.onNavigate,
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // 拖动指示器
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 图片
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Center(
                            child: Icon(
                              _getTypeIcon(),
                              size: 60,
                              color: Colors.grey[400],
                            ),
                          ),
                          // 类型标签
                          Positioned(
                            top: 16,
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getTypeColor(),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                location.typeLabel,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          // 评分
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star, size: 16, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                    location.rating.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
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
                  
                  const SizedBox(height: 20),
                  
                  // 分类标签
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getTypeColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      location.category,
                      style: TextStyle(
                        color: _getTypeColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 名称
                  Text(
                    location.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // 英文名
                  Text(
                    location.nameEn,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 价格信息
                  if (location.price != null && location.price! > 0) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.local_offer, color: Colors.green[700]),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '门票价格',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${location.price} ${location.currency ?? 'EGP'}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // 描述
                  Text(
                    '简介',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    location.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 地址信息
                  if (location.address != null) ...[
                    _buildInfoRow(
                      Icons.location_on,
                      '地址',
                      location.address!,
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  // 电话
                  if (location.phone != null) ...[
                    _buildInfoRow(
                      Icons.phone,
                      '电话',
                      location.phone!,
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  // 营业时间
                  if (location.openingHours != null && location.openingHours!.isNotEmpty) ...[
                    _buildInfoRow(
                      Icons.access_time,
                      '营业时间',
                      location.openingHours!.join('\n'),
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  // 坐标信息
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.my_location, color: Colors.grey[600]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '坐标',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${location.lat.toStringAsFixed(4)}, ${location.lng.toStringAsFixed(4)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 操作按钮
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            onAddToItinerary?.call();
                          },
                          icon: const Icon(Icons.add_location),
                          label: const Text('添加到行程'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            onAddToWishlist?.call();
                          },
                          icon: const Icon(Icons.favorite_border),
                          label: const Text('收藏'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 导航按钮
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        onNavigate?.call();
                      },
                      icon: const Icon(Icons.directions),
                      label: const Text('开始导航'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
