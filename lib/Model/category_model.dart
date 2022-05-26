class Category{
  final String name,image;

  Category({required this.name, required this.image});
}
 List<Category> categories=<Category>[
   Category(name: "Memorize", image: "images/memory.png"),
   Category(name: "Text Recognition", image: "images/text.png"),
   Category(name: "Text To Speech", image: "images/tts.png"),
   Category(name: "Speech To Text", image: "images/stt.png"),
];