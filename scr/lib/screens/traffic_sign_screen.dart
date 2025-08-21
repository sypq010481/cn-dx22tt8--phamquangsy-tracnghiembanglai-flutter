import 'package:flutter/material.dart';

class TrafficSignScreen extends StatefulWidget {
  const TrafficSignScreen({super.key});

  @override
  State<TrafficSignScreen> createState() => _TrafficSignScreenState();
}

class _TrafficSignScreenState extends State<TrafficSignScreen> {
  final List<_TrafficSignCategory> _categories = [
    _TrafficSignCategory(
      title: 'Biển báo cấm',
      icon: Icons.block,
      iconColor: Colors.red,
      description:
          'Biển báo cấm có viền đỏ, nền trắng, hình vẽ màu đen thể hiện điều cấm. Biển có hiệu lực với mọi làn đường hoặc một số làn nhất định. Tổng cộng có 39 kiểu, từ 101 đến 139.',
      imageUrl: 'assets/images/1.webp',
    ),
    _TrafficSignCategory(
      title: 'Biển báo nguy hiểm',
      icon: Icons.warning,
      iconColor: Colors.orange,
      description:
          'Biển báo nguy hiểm với đặc trưng là hình tam giác đều, viền đỏ, nền vàng, hình vẽ màu đen, nhằm cảnh báo cho người tham gia giao thông lường trước các nguy hiểm trên đường để có các biện pháp xử lý kịp thời. Nhóm biển báo này có 47 kiểu, được đánh số từ 201 đến 247.',
      imageUrl: 'assets/images/2.webp',
    ),
    _TrafficSignCategory(
      title: 'Biển hiệu lệnh',
      icon: Icons.directions,
      iconColor: Colors.blue,
      description:
          'Biển hiệu lệnh có hình tròn, nền xanh, hình vẽ màu trắng, có chức năng hướng dẫn các hiệu lệnh mà người tham gia giao thông phải thực hiện. Nhóm biển báo này gồm 10 kiểu, được đánh số từ 301 đến 310.',
      imageUrl: 'assets/images/3.webp',
    ),
    _TrafficSignCategory(
      title: 'Biển chỉ dẫn',
      icon: Icons.info,
      iconColor: Colors.indigo,
      description:
          'Biển chỉ dẫn có hình vuông hoặc hình chữ nhật, nền màu xanh, hình vẽ màu trắng. Nhóm biển báo này gồm 48 kiểu, được đánh số từ 401 đến 448.',
      imageUrl: 'assets/images/4.webp',
    ),
    _TrafficSignCategory(
      title: 'Biển phụ',
      icon: Icons.more_horiz,
      iconColor: Colors.grey,
      description:
          'Biển báo phụ có hình vuông hoặc hình chữ nhật, nền trắng, viền và hình vẽ màu đen. Nhóm biển báo này gồm 10 kiểu, được đánh số từ 501 đến 510.',
      imageUrl: 'assets/images/5.webp',
    ),
  ];

  final Set<int> _expandedIndex = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Các Loại Biển Báo Giao Thông'),
        backgroundColor: Colors.amber,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return ExpansionTile(
            initiallyExpanded: _expandedIndex.contains(index),
            onExpansionChanged: (expanded) {
              setState(() {
                if (expanded) {
                  _expandedIndex.add(index);
                } else {
                  _expandedIndex.remove(index);
                }
              });
            },
            leading: Icon(cat.icon, color: cat.iconColor),
            title: Text(
              cat.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  cat.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (cat.imageUrl != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Image.asset(cat.imageUrl!, fit: BoxFit.cover),
                ),
              const Divider(thickness: 1),
            ],
          );
        },
      ),
    );
  }
}

class _TrafficSignCategory {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String description;
  final String? imageUrl;

  const _TrafficSignCategory({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.description,
    this.imageUrl,
  });
}
