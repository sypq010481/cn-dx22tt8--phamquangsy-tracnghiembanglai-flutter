import 'package:flutter/material.dart';
import '../models/question.dart';
import 'quiz_screen.dart'; // chỉnh đường dẫn nếu khác

class ReviewByCategoryScreen extends StatelessWidget {
  const ReviewByCategoryScreen({super.key});

  void _onSelectCategory(BuildContext context, String categoryName) {
    final mockQuestions = _getQuestionsForCategory(categoryName);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            QuizScreen(title: categoryName, questions: mockQuestions),
      ),
    );
  }

  List<Question> _getQuestionsForCategory(String category) {
    switch (category) {
      case 'Bộ đề số 1':
        return [
          Question(
            content:
                'Phần của đường bộ được sử dụng cho phương tiện giao thông đường bộ đi lại là gì?',
            options: [
              'Phần mặt đường và lề đường.',
              'Phần đường xe chạy.',
              'Phần đường xe cơ giới.',
            ],
            correctAnswerIndex: 1,
          ),
          Question(
            content:
                '“Người tham gia giao thông đường bộ" gồm những đối tượng nào?',
            options: [
              'Người điều khiển, người được chở trên phương tiện tham gia giao thông đường bộ',
              'Người điều khiển, dẫn dắt vật nuôi trên đường bộ; người đi bộ trên đường bộ.',
              'Cả hai ý trên.',
            ],
            correctAnswerIndex: 2,
          ),
          Question(
            content: "Hành vi nào sau đây bị nghiêm cấm?",
            options: [
              "Điều khiển xe cơ giới lạng lách, đánh võng, rú ga liên tục khi tham gia giao thông trên đường.",
              "Xúc phạm, đe dọa, cản trở, chống đối hoặc không chấp hành hiệu lệnh, hướng dẫn, yêu cầu kiểm tra, kiểm soát của người thi hành công vụ về bảo đảm trật tự, an toàn giao thông đường bộ.",
              "Cả hai ý trên.",
            ],
            correctAnswerIndex: 2,
          ),
          Question(
            content:
                "Khi hiệu lệnh của người điều khiển giao thông trái với tín hiệu đèn giao thông hoặc biển báo hiệu đường bộ thì người tham gia giao thông đường bộ phải chấp hành báo hiệu đường bộ nào dưới đây?",
            options: [
              "Theo hiệu lệnh của người điều khiển giao thông.",
              "Theo tín hiệu đèn giao thông.",
              "Theo biển báo hiệu đường bộ.",
            ],
            correctAnswerIndex: 0,
          ),
          Question(
            content:
                "Khi lái xe trong khu đông dân cư, khu vực cơ sở khám bệnh, chữa bệnh trừ các khu vực có biển cấm sử dụng còi, người lái xe được sử dụng còi trong thời gian nào?",
            options: [
              "Từ 22 giờ ngày hôm trước đến 05 giờ ngày hôm sau.",
              "Từ 05 giờ đến 22 giờ.",
              "Từ 23 giờ ngày hôm trước đến 05 giờ sáng hôm sau.",
            ],
            correctAnswerIndex: 1,
          ),
          Question(
            content:
                "Khi điều khiển xe mô tô hai bánh, xe mô tô ba bánh, xe gắn máy, những hành vi nào sau đây không được phép?",
            options: [
              "Buông cả hai tay; sử dụng xe để kéo, đẩy xe khác, vật khác; sử dụng chân chống hoặc vật khác quệt xuống đường khi xe đang chạy.",
              "Sử dụng xe để chở người hoặc hàng hóa; để chân chạm xuống đất khi khởi hành.",
              "Đội mũ bảo hiểm; chạy xe đúng tốc độ quy định và chấp hành đúng quy tắc giao thông đường bộ.",
              "Chở người ngồi sau dưới 16 tuổi.",
            ],
            correctAnswerIndex: 0,
          ),
          Question(
            content:
                "Trường hợp người được chở trên xe mô tô, xe gắn máy, các loại xe tương tự xe mô tô và các loại xe tương tự xe gắn máy không đội mũ bảo hiểm cho người đi mô tô, xe máy hoặc không cài quai đúng quy cách (trừ trường hợp chở người bệnh đi cấp cứu, trẻ em dưới 06 tuổi, áp giải người có hành vi vi phạm pháp luật) thì việc xử phạt vi phạm hành chính được quy định như thế nào?",
            options: [
              "Không bị xử phạt chỉ bị nhắc nhở.",
              "Người được chở không bị xử phạt, chỉ xử phạt người điều khiển xe mô tô, xe gắn máy.",
              "Người được chở bị xử phạt, không xử phạt người điều khiển xe mô tô, xe gắn máy.",
              "Xử phạt cả người điều khiển và người được chở trên xe mô tô, xe gắn máy.",
            ],
            correctAnswerIndex: 3,
          ),
          Question(
            content:
                "Tại nơi đường giao nhau không có báo hiệu đi theo vòng xuyến, người điều khiển phương tiện phải nhường đường như thế nào là đúng quy tắc giao thông?",
            options: [
              "Phải nhường đường cho xe đi đến từ bên phải.",
              "Xe báo hiệu xin đường trước, xe đó được đi trước.",
              "Phải nhường đường cho xe đi đến từ bên trái.",
            ],
            correctAnswerIndex: 0,
          ),
          Question(
            content:
                "Người lái xe được phép vượt xe khác về bên phải trong trường hợp nào dưới đây?",
            options: [
              "Xe phía trước có tín hiệu rẽ trái hoặc đang rẽ trái hoặc khi xe chuyên dùng đang làm việc trên đường mà không thể vượt bên trái.",
              "Xe phía trước đang đi sát lề đường bên trái.",
              "Cả hai ý trên.",
            ],
            correctAnswerIndex: 0,
          ),
          Question(
            content:
                "Người có giấy phép lái xe chưa bị trừ hết 12 điểm, được phục hồi điểm giấy phép lái xe trong trường hợp nào sau đây?",
            options: [
              "Không được phục hồi.",
              "Được phục hồi đủ 12 điểm, nếu không bị trừ điểm trong thời hạn 12 tháng từ ngày bị trừ điểm gần nhất.",
            ],
            correctAnswerIndex: 1,
          ),
          Question(
            content:
                "Những hành vi nào sau đây thể hiện là người có văn hóa giao thông?",
            options: [
              "Luôn tuân thủ pháp luật về trật tự, an toàn giao thông đường bộ, nhường nhịn và giúp đỡ người khác.",
              "Đi nhanh, vượt đèn đỏ nếu không có lực lượng Công an.",
              "Bấm còi và nháy đèn liên tục để cảnh báo xe khác.",
              "Tránh nhường đường để đi nhanh hơn.",
            ],
            correctAnswerIndex: 0,
          ),
          Question(
            content:
                "Khi điều khiển xe mô tô tay ga xuống đường dốc dài, độ dốc cao, người lái xe cần thực hiện các thao tác nào dưới đây để bảo đảm an toàn?",
            options: [
              "Giữ tay ga ở mức độ phù hợp, sử dụng phanh trước và phanh sau để giảm tốc độ.",
              "Nhả hết tay ga, tắt động cơ, sử dụng phanh trước và phanh sau để giảm tốc độ.",
              "Sử dụng phanh trước để giảm tốc độ kết hợp với tắt chìa khóa điện của xe.",
            ],
            correctAnswerIndex: 0,
          ),
          Question(
            content:
                "Khi điều khiển xe mô tô quay đầu, người lái xe cần thực hiện như thế nào để bảo đảm an toàn?",
            options: [
              "Bật tín hiệu báo rẽ trước khi quay đầu, từ từ giảm tốc độ đến mức có thể dừng lại.",
              "Chỉ quay đầu xe tại những nơi được phép quay đầu.",
              "Quan sát an toàn các phương tiện tới từ phía trước, phía sau, hai bên đồng thời nhường đường cho xe từ bên phải và phía trước đi tới.",
              "Cả ba ý trên.",
            ],
            correctAnswerIndex: 3,
          ),
          Question(
            content: "Biển nào cấm quay đầu xe?",
            imageAsset: "assets/images/317.jpg",
            options: [
              "Biển 1.",
              "Biển 2.",
              "Không biển nào.",
              "Cả hai biển.",
            ],
            correctAnswerIndex: 1,
          ),
          Question(
            content:
                "Khi gặp biển nào xe ưu tiên theo luật định vẫn phải dừng lại?",
            imageAsset: "assets/images/333.jpg",
            options: ["Biển 1.", "Biển 2.", "Cả ba biển."],
            correctAnswerIndex: 1,
          ),
          Question(
            content: "Biển này có ý nghĩa như thế nào?",
            imageAsset: "assets/images/358.jpg",
            options: [
              "Cấm dừng xe về hướng bên trái.",
              "Cấm dừng và đỗ xe theo hướng bên phải.",
              "Được phép đỗ xe và dừng xe theo hướng bên phải.",
            ],
            correctAnswerIndex: 1,
          ),
          Question(
            content: 'Biển nào báo hiệu "Giao nhau có tín hiệu đèn?"',
            imageAsset: "assets/images/374.jpg",
            options: ["Biển 1.", "Biển 2.", "Biển 3.", "Cả ba biển."],
            correctAnswerIndex: 2,
          ),
          Question(
            content:
                'Biển nào báo hiệu "Đường giao nhau" của các tuyến đường cùng cấp?',
            imageAsset: "assets/images/390.jpg",
            options: ["Biển 1.", "Biển 2.", "Biển 3."],
            correctAnswerIndex: 0,
          ),
          Question(
            content: "Biển nào dưới đây là biển Cầu hẹp?",
            imageAsset: "assets/images/406.jpg",
            options: ["Biển 1.", "Biển 2.", "Biển 3."],
            correctAnswerIndex: 1,
          ),
          Question(
            content:
                "Biển nào (đặt trước ngã ba, ngã tư) cho phép xe được rẽ sang hướng khác?",
            imageAsset: "assets/images/436.jpg",
            options: ["Biển 1.", "Biển 2.", "Không biển nào."],
            correctAnswerIndex: 2,
          ),
          Question(
            content: "Biển số 1 có ý nghĩa như thế nào?",
            imageAsset: "assets/images/449.jpg",
            options: [
              "Biển chỉ dẫn hết cấm đỗ xe theo giờ trong khu vực.",
              "Biển chỉ dẫn hết hiệu lực khu vực đỗ xe trên các tuyến đường đối ngoại.",
              "Biển chỉ dẫn khu vực đỗ xe trên các tuyến đường đối ngoại.",
            ],
            correctAnswerIndex: 0,
          ),
          Question(
            content:
                'Tại đoạn đường có biển "Làn đường dành riêng cho từng loại xe" dưới đây, các phương tiện có được phép chuyển sang làn khác để đi theo hành trình mong muốn khi đến gần nơi đường bộ giao nhau hay không?',
            imageAsset: "assets/images/465.jpg",
            options: [
              "Được phép chuyển sang làn khác.",
              "Không được phép chuyển sang làn khác, chỉ được đi trong làn quy định theo biển.",
            ],
            correctAnswerIndex: 0,
          ),
          Question(
            content: "Theo tín hiệu đèn, xe nào được phép đi?",
            imageAsset: "assets/images/499.jpg",
            options: ["Xe con và xe khách.", "Xe mô tô."],
            correctAnswerIndex: 0,
          ),
          Question(
            content: "Xe nào được quyền đi trước trong trường hợp này?",
            imageAsset: "assets/images/525.jpg",
            options: ["Xe mô tô.", "Xe con."],
            correctAnswerIndex: 0,
          ),
          Question(
            content: "Bạn có được phép vượt xe mô tô phía trước không?",
            imageAsset: "assets/images/556.jpg",
            options: ["Cho phép.", "Không được vượt."],
            correctAnswerIndex: 1,
          ),
        ];
      case 'Bộ đề số 2':
        return [
          Question(
            content: 'Thứ tự xe đi đúng quy tắc giao thông?',
            options: [
              'Xe tải - xe máy - xe con',
              'Xe con - xe máy - xe tải',
              'Xe máy - xe tải - xe con',
              'Xe máy - xe con - xe tải',
            ],
            correctAnswerIndex: 3,
          ),
        ];
      case 'Bộ đề số 3':
        return [
          Question(
            content: 'Khi gặp xe cứu hỏa đang làm nhiệm vụ, bạn phải làm gì?',
            options: ['Đi tiếp', 'Dừng lại', 'Nhường đường', 'Bấm còi'],
            correctAnswerIndex: 2,
          ),
        ];
      case 'Bộ đề số 4':
        return [
          Question(
            content:
                'Khái niệm “phương tiện giao thông cơ giới đường bộ” gồm những loại nào?',
            options: [
              'Ô tô, xe máy, xe đạp',
              'Xe máy, ô tô, xe đạp điện',
              'Ô tô, xe máy, máy kéo',
              'Cả ba đáp án trên',
            ],
            correctAnswerIndex: 2,
          ),
        ];
      case 'Bộ đề số 5':
        return [
          Question(
            content: 'Biển nào là biển cấm rẽ trái?',
            options: ['Biển 1', 'Biển 2', 'Biển 3', 'Biển 4'],
            correctAnswerIndex: 0,
          ),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      'Bộ đề số 1',
      'Bộ đề số 2',
      'Bộ đề số 3',
      'Bộ đề số 4',
      'Bộ đề số 5',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Ôn Tập Theo Chương')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: categories.length,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return ElevatedButton.icon(
              icon: const Icon(Icons.book),
              label: Text(categories[index]),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
              ),
              onPressed: () => _onSelectCategory(context, categories[index]),
            );
          },
        ),
      ),
    );
  }
}
