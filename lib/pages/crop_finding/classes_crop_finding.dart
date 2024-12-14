
enum DetectionClassesCrop { rice, maize, chickpea, kidneybeans, pigeonpeas, mothbeans, mungbean, blackgram, lentil, pomegranate, banana, mango, grapes, watermelon, muskmelon, apple, orange, papaya, coconut, cotton, jute, coffee }

extension DetectionClassesExtension on DetectionClassesCrop {
  String get label {
    switch (this) {
      case DetectionClassesCrop.rice:
        return "Rice";
      case DetectionClassesCrop.maize:
        return "Maize";
      case DetectionClassesCrop.chickpea:
        return "Chickpea";
      case DetectionClassesCrop.kidneybeans:
        return "Kidney beans";
      case DetectionClassesCrop.pigeonpeas:
        return "Pigeon peas";
      case DetectionClassesCrop.mothbeans:
        return "Moth beans";
      case DetectionClassesCrop.mungbean:
        return "Mung bean";
      case DetectionClassesCrop.blackgram:
        return "Black gram";
      case DetectionClassesCrop.lentil:
        return "Lentil";
      case DetectionClassesCrop.pomegranate:
        return "Pomegranate";
      case DetectionClassesCrop.banana:
        return "Banana";
      case DetectionClassesCrop.mango:
        return "Mango";
      case DetectionClassesCrop.grapes:
        return "Grapes";
      case DetectionClassesCrop.watermelon:
        return "Watermelon";
      case DetectionClassesCrop.muskmelon:
        return "Muskmelon";
      case DetectionClassesCrop.apple:
        return "Apple";
      case DetectionClassesCrop.orange:
        return "Orange";
      case DetectionClassesCrop.papaya:
        return "Papaya";
      case DetectionClassesCrop.coconut:
        return "Coconut";
      case DetectionClassesCrop.cotton:
        return "Cotton";
      case DetectionClassesCrop.jute:
        return "Jute";
      case DetectionClassesCrop.coffee:
        return "Coffee";
    }
  }
}