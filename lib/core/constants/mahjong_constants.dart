/// Constants related to Mahjong tiles and game mechanics
class MahjongConstants {
  // Private constructor to prevent instantiation
  MahjongConstants._();

  /// Suit types
  static const String wanSuit = 'w'; // Character tiles
  static const String tongSuit = 't'; // Circle/dot tiles
  static const String tiaoSuit = 'd'; // Bamboo tiles

  /// Honor tile prefixes
  static const String windPrefix = 'f'; // Wind tiles
  static const String dragonPrefix = 'z'; // Dragon tiles

  /// Wind tiles
  static const String eastWind = 'fE';
  static const String southWind = 'fS';
  static const String westWind = 'fW';
  static const String northWind = 'fN';

  /// Dragon tiles
  static const String redDragon = 'zZ';
  static const String greenDragon = 'zF';
  static const String whiteDragon = 'zB';

  /// All possible tile types grouped by category
  static const List<String> wanTiles = [
    'w1',
    'w2',
    'w3',
    'w4',
    'w5',
    'w6',
    'w7',
    'w8',
    'w9',
  ];
  static const List<String> tongTiles = [
    't1',
    't2',
    't3',
    't4',
    't5',
    't6',
    't7',
    't8',
    't9',
  ];
  static const List<String> tiaoTiles = [
    'd1',
    'd2',
    'd3',
    'd4',
    'd5',
    'd6',
    'd7',
    'd8',
    'd9',
  ];
  static const List<String> windTiles = [
    eastWind,
    southWind,
    westWind,
    northWind,
  ];
  static const List<String> dragonTiles = [redDragon, greenDragon, whiteDragon];
  static const List<String> honorTiles = [...windTiles, ...dragonTiles];

  /// Complete set of all tiles
  static const List<String> allTiles = [
    ...wanTiles,
    ...tongTiles,
    ...tiaoTiles,
    ...honorTiles,
  ];

  /// Map of tile display names
  static const Map<String, Map<String, String>> tileDisplays = {
    'w1': {'num': '一', 'suit': '萬'},
    'w2': {'num': '二', 'suit': '萬'},
    'w3': {'num': '三', 'suit': '萬'},
    'w4': {'num': '四', 'suit': '萬'},
    'w5': {'num': '五', 'suit': '萬'},
    'w6': {'num': '六', 'suit': '萬'},
    'w7': {'num': '七', 'suit': '萬'},
    'w8': {'num': '八', 'suit': '萬'},
    'w9': {'num': '九', 'suit': '萬'},
    'fE': {'char': '東', 'type': 'honor'},
    'fS': {'char': '南', 'type': 'honor'},
    'fW': {'char': '西', 'type': 'honor'},
    'fN': {'char': '北', 'type': 'honor'},
    'zZ': {'char': '中', 'type': 'honor', 'color': 'red'},
    'zF': {'char': '發', 'type': 'honor', 'color': 'green'},
    'zB': {'char': '白', 'type': 'honor', 'isBox': 'true'},
  };

  /// Level configurations
  static const Map<String, int> levelTileCounts = {
    'small': 54, // Levels 1-3: 18 types × 3 tiles each
    'medium': 72, // Levels 4-7: 24 types × 3 tiles each
    'large': 90, // Levels 8-12: 30 types × 3 tiles each
  };

  /// Level groupings
  static const Map<int, String> levelSizes = {
    1: 'small',
    2: 'small',
    3: 'small',
    4: 'medium',
    5: 'medium',
    6: 'medium',
    7: 'medium',
    8: 'large',
    9: 'large',
    10: 'large',
    11: 'large',
    12: 'large',
  };

  /// Chapter definitions
  static const Map<String, List<int>> chapters = {
    'Chapter 1: 入门': [1, 2, 3],
    'Chapter 2: 进阶': [4, 5, 6, 7],
    'Chapter 3: 终局': [8, 9, 10, 11, 12],
  };
}
