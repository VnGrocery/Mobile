import 'package:flutter/material.dart';

class OnboardingPageData {
  final String title;
  final String description;
  final IconData icon;

  const OnboardingPageData(this.title, this.description, this.icon);
}

class OnboardingPages {
  const OnboardingPages._();

  static const items = [
    OnboardingPageData(
      'Xem dữ liệu sản phẩm',
      'Mỗi sản phẩm có điểm đánh giá và lịch sử ghi nhận rõ ràng.',
      Icons.verified_user,
    ),
    OnboardingPageData(
      'Chụp ảnh kiểm tra',
      'Quét mã hoặc chụp ảnh tại quầy để kiểm tra với dữ liệu gần nhất.',
      Icons.photo_camera,
    ),
    OnboardingPageData(
      'Ra quyết định dễ dàng',
      'Dễ so sánh hơn khi thông tin đến từ các lượt ghi nhận thực tế.',
      Icons.check_circle,
    ),
  ];
}
