class SuggestedQuestion {
  final String id;
  final String question;
  final String icon;
  final String category;

  const SuggestedQuestion({
    required this.id,
    required this.question,
    required this.icon,
    required this.category,
  });
}

// 12 preset questions
final List<SuggestedQuestion> suggestedQuestions = [
  SuggestedQuestion(
    id: '1',
    question: 'How to take natural street photos?',
    icon: '📸',
    category: 'Photography',
  ),
  SuggestedQuestion(
    id: '2',
    question: 'What are popular fall/winter styles?',
    icon: '🧥',
    category: 'Seasonal',
  ),
  SuggestedQuestion(
    id: '3',
    question: 'How to dress taller for petites?',
    icon: '👗',
    category: 'Body Type',
  ),
  SuggestedQuestion(
    id: '4',
    question: 'What defines streetwear style?',
    icon: '🎨',
    category: 'Style Guide',
  ),
  SuggestedQuestion(
    id: '5',
    question: 'How to choose color combinations?',
    icon: '🎨',
    category: 'Color',
  ),
  SuggestedQuestion(
    id: '6',
    question: 'What to wear on a date?',
    icon: '💝',
    category: 'Occasion',
  ),
  SuggestedQuestion(
    id: '7',
    question: 'How to pose naturally in photos?',
    icon: '🤳',
    category: 'Posing',
  ),
  SuggestedQuestion(
    id: '8',
    question: 'How to style vintage outfits?',
    icon: '🕰️',
    category: 'Style Guide',
  ),
  SuggestedQuestion(
    id: '9',
    question: 'Stylish yet comfy work outfits?',
    icon: '💼',
    category: 'Occasion',
  ),
  SuggestedQuestion(
    id: '10',
    question: 'How to elevate looks with accessories?',
    icon: '👜',
    category: 'Accessories',
  ),
  SuggestedQuestion(
    id: '11',
    question: 'Best lighting for street photography?',
    icon: '☀️',
    category: 'Photography',
  ),
  SuggestedQuestion(
    id: '12',
    question: 'How to achieve minimalist style?',
    icon: '✨',
    category: 'Style Guide',
  ),
];
