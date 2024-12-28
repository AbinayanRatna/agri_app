enum DetectionClasses { Tomato_Bacterial_Spot, early_blight, leaf_mold, mosaic_virus,septoria_leaf_spot, two_spotted_spider_mite,nothing }

extension DetectionClassesExtension on DetectionClasses {
  String get label {
    switch (this) {
      case DetectionClasses.Tomato_Bacterial_Spot:
        return "Tomato_Bacterial_Spot";
      case DetectionClasses.early_blight:
        return "early_blight";
      case DetectionClasses.leaf_mold:
        return "leaf_mold";
      case DetectionClasses.mosaic_virus:
        return "mosaic_virus";
      case DetectionClasses.septoria_leaf_spot:
        return "septoria_leaf_spot";
      case DetectionClasses.two_spotted_spider_mite:
        return "two_spotted_spider_mite";
      case DetectionClasses.nothing:
        return "nothing";
    }
  }
}
//
// enum DetectionClasses { rock, paper, scissors, nothing }
//
// extension DetectionClassesExtension on DetectionClasses {
//   String get label {
//     switch (this) {
//       case DetectionClasses.rock:
//         return "Rock";
//       case DetectionClasses.paper:
//         return "Paper";
//       case DetectionClasses.scissors:
//         return "Scissors";
//       case DetectionClasses.nothing:
//         return "Nothing";
//     }
//   }
// }