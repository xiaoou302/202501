class DanceTopic {
  final String id;
  final String question;
  final String imagePath;
  final String category;

  DanceTopic({
    required this.id,
    required this.question,
    required this.imagePath,
    required this.category,
  });

  static List<DanceTopic> getAllTopics() {
    return [
      // 技术类问题
      DanceTopic(
        id: '1',
        question: 'How can I improve my balance and stability in dance?',
        imagePath: 'assets/wdht/14371763483906_.pic_hd.jpg',
        category: 'Technique',
      ),
      DanceTopic(
        id: '2',
        question: 'What are the key elements of proper posture in ballet?',
        imagePath: 'assets/wdht/14381763483907_.pic_hd.jpg',
        category: 'Technique',
      ),
      DanceTopic(
        id: '3',
        question: 'How do I develop better flexibility for dance?',
        imagePath: 'assets/wdht/14391763483908_.pic_hd.jpg',
        category: 'Technique',
      ),
      DanceTopic(
        id: '4',
        question: 'What exercises help strengthen my core for dance?',
        imagePath: 'assets/wdht/14401763483909_.pic_hd.jpg',
        category: 'Technique',
      ),
      
      // 艺术表现类问题
      DanceTopic(
        id: '5',
        question: 'How can I express emotions better through dance?',
        imagePath: 'assets/wdht/14411763483910_.pic_hd.jpg',
        category: 'Artistry',
      ),
      DanceTopic(
        id: '6',
        question: 'What is musicality and how do I improve it?',
        imagePath: 'assets/wdht/14421763483911_.pic_hd.jpg',
        category: 'Artistry',
      ),
      DanceTopic(
        id: '7',
        question: 'How do I connect with the audience during performance?',
        imagePath: 'assets/wdht/14431763483912_.pic_hd.jpg',
        category: 'Artistry',
      ),
      DanceTopic(
        id: '8',
        question: 'What makes a dance performance memorable?',
        imagePath: 'assets/wdht/14441763483913_.pic_hd.jpg',
        category: 'Artistry',
      ),
      
      // 训练和练习类问题
      DanceTopic(
        id: '9',
        question: 'How often should I practice to see improvement?',
        imagePath: 'assets/wdht/14451763483914_.pic_hd.jpg',
        category: 'Training',
      ),
      DanceTopic(
        id: '10',
        question: 'What is the best warm-up routine before dancing?',
        imagePath: 'assets/wdht/14461763483915_.pic_hd.jpg',
        category: 'Training',
      ),
      DanceTopic(
        id: '11',
        question: 'How do I overcome performance anxiety?',
        imagePath: 'assets/wdht/14471763483916_.pic_hd.jpg',
        category: 'Training',
      ),
      DanceTopic(
        id: '12',
        question: 'What should I focus on as a beginner dancer?',
        imagePath: 'assets/wdht/14481763483917_.pic_hd.jpg',
        category: 'Training',
      ),
      
      // 舞蹈风格和历史类问题
      DanceTopic(
        id: '13',
        question: 'What are the main differences between ballet and contemporary dance?',
        imagePath: 'assets/wdht/14491763483919_.pic_hd.jpg',
        category: 'Styles',
      ),
      DanceTopic(
        id: '14',
        question: 'How did hip hop dance evolve and develop?',
        imagePath: 'assets/wdht/14501763483920_.pic_hd.jpg',
        category: 'Styles',
      ),
      DanceTopic(
        id: '15',
        question: 'What dance style should I learn first?',
        imagePath: 'assets/wdht/14511763483921_.pic_hd.jpg',
        category: 'Styles',
      ),
      DanceTopic(
        id: '16',
        question: 'How can I develop my own unique dance style?',
        imagePath: 'assets/wdht/14521763483922_.pic_hd.jpg',
        category: 'Styles',
      ),
    ];
  }
}
