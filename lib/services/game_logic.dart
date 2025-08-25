import 'dart:math';
import '../models/game_unit.dart';
import '../models/level.dart';

/// 游戏逻辑服务
/// 处理游戏的核心逻辑，包括匹配检测、消除和分数计算
class GameLogic {
  // 游戏状态
  late List<List<GameUnit?>> _board;
  int _score = 0;
  int _moves = 0;
  int _plexiMatches = 0;
  int _transmutes = 0;
  int _comboChain = 0;
  late Level _level;
  bool _isGameOver = false;
  bool _isLevelCompleted = false;

  // 构造函数
  GameLogic() {
    // 创建一个默认的临时关卡，直到initGame被调用
    _level = Level(
      id: 0,
      name: "临时关卡",
      description: "临时关卡，等待初始化",
      objective: LevelObjective(type: LevelObjectiveType.score, target: 100),
      initialBoard: [],
      maxMoves: 20,
      boardWidth: 8,
      boardHeight: 8,
    );
    _board = List.generate(8, (row) => List.generate(8, (col) => null));
  }

  // 用于防止无限递归的计数器
  int _processingChainDepth = 0;
  static const int _maxChainDepth = 10;

  // Getters
  List<List<GameUnit?>> get board => _board;
  int get score => _score;
  int get moves => _moves;
  int get plexiMatches => _plexiMatches;
  int get transmutes => _transmutes;
  int get comboChain => _comboChain;
  Level get level => _level;
  bool get isGameOver => _isGameOver;
  bool get isLevelCompleted => _isLevelCompleted;
  int get movesLeft => _level.maxMoves - _moves;

  // 初始化游戏
  Future<void> initGame(Level level) async {
    try {
      _level = level;
      _processingChainDepth = 0;
      _score = 0;
      _moves = 0;
      _plexiMatches = 0;
      _transmutes = 0;
      _comboChain = 0;
      _isGameOver = false;
      _isLevelCompleted = false;

      // 检查initialBoard是否为空，如果为空则生成随机棋盘
      if (level.initialBoard.isEmpty) {
        await _generateRandomBoard(level.boardHeight, level.boardWidth);
      } else {
        _board = List.generate(
          level.boardHeight,
          (row) => List.generate(level.boardWidth, (col) {
            final initialUnit = level.initialBoard[row][col];
            if (initialUnit == null) return null;
            return initialUnit.copyWith(
              position: Position(row: row, col: col),
            );
          }),
        );
      }

      _updateObjective();
    } catch (e) {
      print('Error initializing game: $e');
      // 确保即使出错也有一个有效的棋盘
      _board = List.generate(
        level.boardHeight,
        (row) => List.generate(level.boardWidth, (col) => null),
      );
      rethrow;
    }
  }

  // 更新棋盘的选中状态
  void updateBoardSelectionState(List<List<GameUnit?>> newBoard) {
    for (int row = 0; row < _board.length; row++) {
      for (int col = 0; col < _board[row].length; col++) {
        if (_board[row][col] != null && newBoard[row][col] != null) {
          _board[row][col] = _board[row][col]!.copyWith(
            isSelected: newBoard[row][col]!.isSelected,
          );
        }
      }
    }
  }

  // 生成随机棋盘
  Future<void> _generateRandomBoard(int height, int width) async {
    final random = Random();
    final colors = ['r', 'g', 'b', 'y', 'p'];
    final shapes = ['c', 's', 't'];

    _board = List.generate(
      height,
      (row) => List.generate(
        width,
        (col) => GameUnit(
          color: colors[random.nextInt(colors.length)],
          shape: shapes[random.nextInt(shapes.length)],
          position: Position(row: row, col: col),
        ),
      ),
    );

    // 根据关卡特性设置特殊单元和目标
    if (_level.id == 999) {
      // 无尽模式：根据当前分数和移动次数动态调整难度
      _setupEndlessMode(random);
    } else {
      switch (_level.id) {
        case 1:
          // 第一关：简单的分数目标，但提高难度
          if (_level.objective.type == LevelObjectiveType.score) {
            _level.objective.target = 3000; // 提高分数目标到3000
          }
          break;
        case 2:
          // 第二关：添加更多锁定单元
          _addLockedUnits(random, 12); // 增加锁定单元数量
          // 锁定单元分布更加不规则，增加难度
          _addStrategicLockedUnits(random, 3);
          break;
        case 3:
          // 第三关：添加更多空洞和提高完美匹配目标
          _addHoles(random, width * height ~/ 5); // 约20%的空洞，增加难度
          _addStrategicHoles(random, 4); // 添加战略性空洞，增加难度
          if (_level.objective.type == LevelObjectiveType.plexiMatches) {
            _level.objective.target = 7; // 提高完美匹配目标
          }
          break;
        case 4:
          // 第四关：添加更多变色龙单元
          _addChangingUnits(random, 15); // 增加变色龙单元数量
          // 添加一些锁定单元增加难度
          _addLockedUnits(random, 3);
          break;
        case 5:
          // 第五关：添加更多污染格子
          _addPollutedTiles(random, 18); // 增加污染格子数量
          // 添加一些空洞增加难度
          _addHoles(random, width * height ~/ 10);
          break;
        case 6:
          // 第六关：终极挑战，混合目标
          if (_level.objective.type == LevelObjectiveType.score) {
            _level.objective.target = 1500; // 大幅提高分数目标
          }
          // 添加更多特殊单元增加挑战性
          _addLockedUnits(random, 6);
          _addChangingUnits(random, 6);
          _addPollutedTiles(random, 6);
          _addHoles(random, width * height ~/ 12);
          break;
      }
    }

    // 确保初始棋盘没有匹配
    await _ensureNoInitialMatches();
  }

  // 设置无尽模式的难度
  void _setupEndlessMode(Random random) {
    // 无尽模式不需要特殊单元，保持纯净的棋盘
    // 仅根据分数和移动次数计算难度，但不添加特殊单元

    // 根据当前分数和移动次数计算难度系数（仅用于记录）
    double difficultyFactor = 1.0;

    // 分数影响难度
    if (_score > 0) {
      // 每1000分增加0.5的难度系数
      difficultyFactor += (_score / 1000) * 0.5;
    }

    // 移动次数影响难度
    if (_moves > 0) {
      // 每50步增加0.3的难度系数
      difficultyFactor += (_moves / 50) * 0.3;
    }

    // 难度系数上限为5.0
    difficultyFactor = difficultyFactor.clamp(1.0, 5.0);

    // 无尽模式不添加任何特殊单元，保持纯净的棋盘
    // 这样玩家可以自由交换单元，专注于获得高分
  }

  // 添加锁定单元
  void _addLockedUnits(Random random, int count) {
    int added = 0;
    int maxAttempts = count * 3; // 防止无限循环
    int attempts = 0;

    while (added < count && attempts < maxAttempts) {
      attempts++;
      final row = random.nextInt(_level.boardHeight);
      final col = random.nextInt(_level.boardWidth);

      if (_board[row][col] != null && !_board[row][col]!.isLocked) {
        _board[row][col] = _board[row][col]!.copyWith(isLocked: true);
        added++;
      }
    }

    // 如果是锁定单元目标类型，设置目标数量为已添加数量的85%，增加难度
    if (_level.objective.type == LevelObjectiveType.lockedUnits) {
      _level.objective.target = (added * 0.85).ceil();
    }
  }

  // 添加战略性锁定单元（形成障碍）
  void _addStrategicLockedUnits(Random random, int groupCount) {
    for (int i = 0; i < groupCount; i++) {
      // 选择一个起始点
      final startRow = random.nextInt(_level.boardHeight - 2) + 1;
      final startCol = random.nextInt(_level.boardWidth - 2) + 1;

      // 创建一个2x2或3x1的锁定单元组
      if (random.nextBool()) {
        // 创建2x2组
        for (int r = 0; r < 2; r++) {
          for (int c = 0; c < 2; c++) {
            final row = startRow + r;
            final col = startCol + c;
            if (row < _level.boardHeight &&
                col < _level.boardWidth &&
                _board[row][col] != null) {
              _board[row][col] = _board[row][col]!.copyWith(isLocked: true);
            }
          }
        }
      } else {
        // 创建3x1组（水平或垂直）
        final isHorizontal = random.nextBool();
        for (int j = 0; j < 3; j++) {
          final row = startRow + (isHorizontal ? 0 : j);
          final col = startCol + (isHorizontal ? j : 0);
          if (row < _level.boardHeight &&
              col < _level.boardWidth &&
              _board[row][col] != null) {
            _board[row][col] = _board[row][col]!.copyWith(isLocked: true);
          }
        }
      }
    }
  }

  // 添加空洞
  void _addHoles(Random random, int count) {
    int added = 0;
    int maxAttempts = count * 3; // 防止无限循环
    int attempts = 0;

    while (added < count && attempts < maxAttempts) {
      attempts++;
      final row = random.nextInt(_level.boardHeight);
      final col = random.nextInt(_level.boardWidth);

      // 避免在边缘创建太多空洞
      if (row > 0 &&
          row < _level.boardHeight - 1 &&
          col > 0 &&
          col < _level.boardWidth - 1 &&
          _board[row][col] != null) {
        _board[row][col] = null;
        added++;
      }
    }
  }

  // 添加战略性空洞（形成更难的布局）
  void _addStrategicHoles(Random random, int patternCount) {
    final patterns = [
      // L形空洞
      [
        [1, 0],
        [1, 1],
        [1, 2],
      ],
      // Z形空洞
      [
        [0, 0],
        [1, 1],
        [2, 1],
      ],
      // 十字形空洞
      [
        [0, 1],
        [1, 0],
        [1, 1],
        [1, 2],
        [2, 1],
      ],
      // 对角线空洞
      [
        [0, 0],
        [1, 1],
        [2, 2],
      ],
    ];

    for (int i = 0; i < patternCount; i++) {
      // 随机选择一个模式
      final pattern = patterns[random.nextInt(patterns.length)];

      // 随机选择一个起始点，避免边缘
      final startRow = random.nextInt(_level.boardHeight - 3) + 1;
      final startCol = random.nextInt(_level.boardWidth - 3) + 1;

      // 应用模式
      for (final point in pattern) {
        final row = startRow + point[0];
        final col = startCol + point[1];

        if (row >= 0 &&
            row < _level.boardHeight &&
            col >= 0 &&
            col < _level.boardWidth) {
          _board[row][col] = null;
        }
      }
    }
  }

  // 添加变色龙单元
  void _addChangingUnits(Random random, int count) {
    int added = 0;
    int maxAttempts = count * 3; // 防止无限循环
    int attempts = 0;

    while (added < count && attempts < maxAttempts) {
      attempts++;
      final row = random.nextInt(_level.boardHeight);
      final col = random.nextInt(_level.boardWidth);

      if (_board[row][col] != null &&
          !_board[row][col]!.isChanging &&
          !_board[row][col]!.isLocked) {
        _board[row][col] = _board[row][col]!.copyWith(isChanging: true);
        added++;
      }
    }

    // 如果是变色龙单元目标类型，设置目标数量为已添加数量的85%，增加难度
    if (_level.objective.type == LevelObjectiveType.changingUnits) {
      _level.objective.target = (added * 0.85).ceil();
    }

    // 在第4关及以上，变色龙单元每次匹配后会随机改变颜色和形状
    // 这个逻辑将在processMatches方法中实现
  }

  // 添加污染格子
  void _addPollutedTiles(Random random, int count) {
    int added = 0;
    int maxAttempts = count * 3; // 防止无限循环
    int attempts = 0;

    while (added < count && attempts < maxAttempts) {
      attempts++;
      final row = random.nextInt(_level.boardHeight);
      final col = random.nextInt(_level.boardWidth);

      if (_board[row][col] != null &&
          !_board[row][col]!.isPolluted &&
          !_board[row][col]!.isLocked) {
        _board[row][col] = _board[row][col]!.copyWith(isPolluted: true);
        added++;
      }
    }

    // 如果是净化污染格子目标类型，设置目标数量为已添加数量的85%，增加难度
    if (_level.objective.type == LevelObjectiveType.purifyTiles) {
      _level.objective.target = (added * 0.85).ceil();
    }

    // 添加污染扩散机制，在第5关及以上，每次匹配后有几率产生新的污染格子
    // 这个逻辑将在processMatches方法中实现
  }

  // 确保初始棋盘没有匹配
  Future<void> _ensureNoInitialMatches() async {
    bool hasMatches = true;
    int attempts = 0;
    const maxAttempts = 10;

    while (hasMatches && attempts < maxAttempts) {
      // 使用微任务让UI有机会更新
      if (attempts > 0 && attempts % 2 == 0) {
        await Future.delayed(Duration.zero);
      }

      final matches = _findMatches();
      if (matches.isEmpty) {
        hasMatches = false;
      } else {
        // 对每个匹配，随机改变一个单元的属性
        for (final match in matches) {
          if (match.isNotEmpty) {
            final pos = match[0];
            if (_board[pos.row][pos.col] != null) {
              _randomizeUnit(pos.row, pos.col);
            }
          }
        }
      }
      attempts++;
    }

    // 如果达到最大尝试次数仍有匹配，就重新生成整个棋盘
    if (hasMatches) {
      final random = Random();
      final colors = ['r', 'g', 'b', 'y', 'p'];
      final shapes = ['c', 's', 't'];

      // 完全重新生成棋盘
      for (int row = 0; row < _level.boardHeight; row++) {
        for (int col = 0; col < _level.boardWidth; col++) {
          if (_board[row][col] != null) {
            _board[row][col] = GameUnit(
              color: colors[random.nextInt(colors.length)],
              shape: shapes[random.nextInt(shapes.length)],
              position: Position(row: row, col: col),
              isLocked: _board[row][col]!.isLocked,
              isChanging: _board[row][col]!.isChanging,
              isPolluted: _board[row][col]!.isPolluted,
            );
          }
        }
      }
    }
  }

  // 随机化单元的颜色和形状
  void _randomizeUnit(int row, int col) {
    final random = Random();
    final colors = ['r', 'g', 'b', 'y', 'p'];
    final shapes = ['c', 's', 't'];

    final currentUnit = _board[row][col]!;
    String newColor;
    String newShape;

    // 最多尝试10次找到不会导致匹配的颜色和形状组合
    int attempts = 0;
    const maxAttempts = 10;

    do {
      newColor = colors[random.nextInt(colors.length)];
      newShape = shapes[random.nextInt(shapes.length)];
      attempts++;

      // 如果尝试次数过多，就使用随机颜色和形状
      if (attempts >= maxAttempts) {
        break;
      }
    } while (_wouldCauseMatch(row, col, newColor, newShape));

    _board[row][col] = currentUnit.copyWith(color: newColor, shape: newShape);
  }

  // 检查给定的颜色和形状是否会导致匹配
  bool _wouldCauseMatch(int row, int col, String color, String shape) {
    // 检查水平方向
    int colorMatchesLeft = 0;
    int shapeMatchesLeft = 0;
    for (int c = col - 1; c >= 0 && c >= col - 2; c--) {
      if (c < 0 || c >= _level.boardWidth) continue;
      if (_board[row][c] != null) {
        if (_board[row][c]!.color == color) colorMatchesLeft++;
        if (_board[row][c]!.shape == shape) shapeMatchesLeft++;
      } else {
        break;
      }
    }

    int colorMatchesRight = 0;
    int shapeMatchesRight = 0;
    for (int c = col + 1; c < _level.boardWidth && c <= col + 2; c++) {
      if (c < 0 || c >= _level.boardWidth) continue;
      if (_board[row][c] != null) {
        if (_board[row][c]!.color == color) colorMatchesRight++;
        if (_board[row][c]!.shape == shape) shapeMatchesRight++;
      } else {
        break;
      }
    }

    // 检查垂直方向
    int colorMatchesUp = 0;
    int shapeMatchesUp = 0;
    for (int r = row - 1; r >= 0 && r >= row - 2; r--) {
      if (r < 0 || r >= _level.boardHeight) continue;
      if (_board[r][col] != null) {
        if (_board[r][col]!.color == color) colorMatchesUp++;
        if (_board[r][col]!.shape == shape) shapeMatchesUp++;
      } else {
        break;
      }
    }

    int colorMatchesDown = 0;
    int shapeMatchesDown = 0;
    for (int r = row + 1; r < _level.boardHeight && r <= row + 2; r++) {
      if (r < 0 || r >= _level.boardHeight) continue;
      if (_board[r][col] != null) {
        if (_board[r][col]!.color == color) colorMatchesDown++;
        if (_board[r][col]!.shape == shape) shapeMatchesDown++;
      } else {
        break;
      }
    }

    // 如果任何方向有2个或以上的匹配，则会导致匹配
    return (colorMatchesLeft + colorMatchesRight >= 2) ||
        (shapeMatchesLeft + shapeMatchesRight >= 2) ||
        (colorMatchesUp + colorMatchesDown >= 2) ||
        (shapeMatchesUp + shapeMatchesDown >= 2);
  }

  // 更新关卡目标
  void _updateObjective() {
    switch (_level.objective.type) {
      case LevelObjectiveType.score:
        _level.objective.current = _score;
        break;
      case LevelObjectiveType.plexiMatches:
        _level.objective.current = _plexiMatches;
        break;
      case LevelObjectiveType.matches:
        // 使用更准确的匹配计数方式
        _level.objective.current = (_score ~/ 10) + (_plexiMatches * 2);
        break;
      case LevelObjectiveType.lockedUnits:
        // 锁定单元的逻辑在processMatches中已更新
        // 第二关特殊处理：需要同时满足消除锁定单元和至少1次完美匹配
        if (_level.id == 2 &&
            _level.objective.current >= _level.objective.target &&
            _plexiMatches < 1) {
          _isLevelCompleted = false;
        }
        break;
      case LevelObjectiveType.changingUnits:
        // 变色龙单元的逻辑在processMatches中已更新
        break;
      case LevelObjectiveType.purifyTiles:
        // 净化格子的逻辑在processMatches中已更新
        break;
    }

    // 检查是否完成关卡目标
    if (_level.objective.isCompleted) {
      // 第二关特殊处理：需要同时满足消除锁定单元和至少1次完美匹配
      if (_level.id == 2 &&
          _level.objective.type == LevelObjectiveType.lockedUnits &&
          _plexiMatches < 1) {
        _isLevelCompleted = false;
      }
      // 第六关特殊处理：需要同时满足消除变色龙单元和净化污染格子
      else if (_level.id == 6 &&
          _level.objective.type == LevelObjectiveType.changingUnits) {
        // 检查是否同时满足了两个目标
        int purifiedTilesCount = 0;

        // 在第6关，我们需要单独跟踪净化的污染格子数量
        // 这个数值存储在关卡的objective.current之外
        // 我们可以使用一个静态变量来跟踪，但为了简单，这里直接检查棋盘上剩余的污染格子

        // 计算剩余的污染格子数量
        int remainingPollutedTiles = 0;
        for (int row = 0; row < _level.boardHeight; row++) {
          for (int col = 0; col < _level.boardWidth; col++) {
            final unit = _board[row][col];
            if (unit != null && unit.isPolluted) {
              remainingPollutedTiles++;
            }
          }
        }

        // 假设初始有16个污染格子，净化的数量 = 16 - 剩余数量
        purifiedTilesCount = 16 - remainingPollutedTiles;

        // 如果变色龙单元目标已达成，但污染格子净化数量不足16个，则不完成关卡
        if (_level.objective.current >= _level.objective.target &&
            purifiedTilesCount < 16) {
          _isLevelCompleted = false;
        } else if (_level.objective.current >= _level.objective.target &&
            purifiedTilesCount >= 16) {
          _isLevelCompleted = true;
        } else {
          _isLevelCompleted = false;
        }
      } else {
        _isLevelCompleted = true;
      }
    }

    // 检查是否游戏结束
    if (_moves >= _level.maxMoves && !_isLevelCompleted) {
      _isGameOver = true;
    }
  }

  // 选择单元
  bool selectUnit(int row, int col) {
    if (_isGameOver || _isLevelCompleted) return false;
    if (row < 0 ||
        row >= _level.boardHeight ||
        col < 0 ||
        col >= _level.boardWidth)
      return false;

    final unit = _board[row][col];
    if (unit == null) return false;

    // 如果单元被锁定，不能选择
    if (unit.isLocked) return false;

    // 切换选中状态
    _board[row][col] = unit.copyWith(isSelected: !unit.isSelected);
    return true;
  }

  // 交换两个单元
  bool swapUnits(Position pos1, Position pos2) {
    if (_isGameOver || _isLevelCompleted) return false;

    // 检查位置是否有效
    if (!_isValidPosition(pos1) || !_isValidPosition(pos2)) return false;

    // 获取单元
    final unit1 = _board[pos1.row][pos1.col];
    final unit2 = _board[pos2.row][pos2.col];

    // 检查单元是否存在
    if (unit1 == null || unit2 == null) return false;

    // 检查是否相邻
    if (!_isAdjacent(pos1, pos2)) return false;

    // 检查是否有锁定单元
    if (unit1.isLocked || unit2.isLocked) return false;

    // 交换单元
    _board[pos1.row][pos1.col] = unit2.copyWith(
      position: pos1,
      isSelected: false,
      // 无尽模式下交换锁定单元时保持锁定状态
      isLocked: unit2.isLocked,
    );
    _board[pos2.row][pos2.col] = unit1.copyWith(
      position: pos2,
      isSelected: false,
      // 无尽模式下交换锁定单元时保持锁定状态
      isLocked: unit1.isLocked,
    );

    // 增加移动次数
    _moves++;

    // 检查是否形成匹配
    final matches = _findMatches();

    // 处理没有匹配的情况
    if (matches.isEmpty) {
      // 即使没有匹配，也允许交换
      // 不再交换回来，也不撤销移动次数

      // 更新关卡目标
      _updateObjective();
      return true; // 返回true表示交换成功，即使没有匹配
    }

    // 重置递归深度计数器
    _processingChainDepth = 0;

    // 处理匹配
    _processMatches(matches);

    // 更新关卡目标
    _updateObjective();

    return true;
  }

  // 使用嬗变能力
  bool useTransmute(Position position, bool changeColor) {
    if (_isGameOver || _isLevelCompleted) return false;
    if (_transmutes <= 0) return false;
    if (!_isValidPosition(position)) return false;

    final unit = _board[position.row][position.col];
    if (unit == null) return false;

    // 如果单元被锁定，不能使用嬗变
    if (unit.isLocked) return false;

    // 第4关特殊处理：只有变色龙单元可以被嬗变消除
    if (_level.id == 4 &&
        _level.objective.type == LevelObjectiveType.changingUnits) {
      // 如果不是变色龙单元，不能使用嬗变
      if (!unit.isChanging) {
        return false;
      }

      // 消除变色龙单元
      _board[position.row][position.col] = null;

      // 更新目标计数
      _level.objective.current += 1;

      // 减少嬗变次数
      _transmutes--;

      // 更新关卡目标
      _updateObjective();

      return true;
    }

    // 第5关特殊处理：如果是污染格子，先将其转换为变色龙单元
    if (_level.id == 5 && unit.isPolluted) {
      // 将污染格子转换为变色龙单元
      _board[position.row][position.col] = unit.copyWith(
        isPolluted: false,
        isChanging: true,
      );

      // 减少嬗变次数
      _transmutes--;

      // 更新关卡目标（净化进度在消除变色龙单元时更新）
      _updateObjective();

      return true;
    }
    // 第5关特殊处理：如果是变色龙单元（由污染格子转换而来），消除它并更新净化目标
    else if (_level.id == 5 && unit.isChanging && !unit.isPolluted) {
      // 消除变色龙单元
      _board[position.row][position.col] = null;

      // 更新净化目标计数
      if (_level.objective.type == LevelObjectiveType.purifyTiles) {
        _level.objective.current += 1;
      }

      // 减少嬗变次数
      _transmutes--;

      // 更新关卡目标
      _updateObjective();

      return true;
    }
    // 第6关特殊处理：同时处理变色龙单元和污染格子
    else if (_level.id == 6) {
      // 如果是变色龙单元，直接消除
      if (unit.isChanging) {
        _board[position.row][position.col] = null;

        // 更新变色龙单元目标计数
        if (_level.objective.type == LevelObjectiveType.changingUnits) {
          _level.objective.current += 1;
        }

        // 减少嬗变次数
        _transmutes--;

        // 更新关卡目标
        _updateObjective();

        return true;
      }
      // 如果是污染格子，先将其转换为变色龙单元
      else if (unit.isPolluted) {
        _board[position.row][position.col] = unit.copyWith(
          isPolluted: false,
          isChanging: true,
        );

        // 减少嬗变次数
        _transmutes--;

        // 更新关卡目标
        _updateObjective();

        return true;
      }
    }

    // 随机生成新的颜色或形状（普通嬗变逻辑）
    final random = Random();
    final colors = ['r', 'g', 'b', 'y', 'p'];
    final shapes = ['c', 's', 't'];

    if (changeColor) {
      // 随机选择一个不同的颜色
      String newColor;
      do {
        newColor = colors[random.nextInt(colors.length)];
      } while (newColor == unit.color);

      _board[position.row][position.col] = unit.copyWith(
        color: newColor,
        isLocked: unit.isLocked,
      );
    } else {
      // 随机选择一个不同的形状
      String newShape;
      do {
        newShape = shapes[random.nextInt(shapes.length)];
      } while (newShape == unit.shape);

      _board[position.row][position.col] = unit.copyWith(
        shape: newShape,
        isLocked: unit.isLocked,
      );
    }

    // 减少嬗变次数
    _transmutes--;

    // 重置递归深度计数器
    _processingChainDepth = 0;

    // 检查是否形成匹配
    final matches = _findMatches();
    if (matches.isNotEmpty) {
      _processMatches(matches);
    }

    // 更新关卡目标
    _updateObjective();

    return true;
  }

  // 检查位置是否有效
  bool _isValidPosition(Position position) {
    return position.row >= 0 &&
        position.row < _level.boardHeight &&
        position.col >= 0 &&
        position.col < _level.boardWidth;
  }

  // 检查两个位置是否相邻
  bool _isAdjacent(Position pos1, Position pos2) {
    return (pos1.row == pos2.row && (pos1.col - pos2.col).abs() == 1) ||
        (pos1.col == pos2.col && (pos1.row - pos2.row).abs() == 1);
  }

  // 查找所有匹配
  List<List<Position>> _findMatches() {
    List<List<Position>> allMatches = [];

    // 检查水平匹配
    for (int row = 0; row < _level.boardHeight; row++) {
      for (int col = 0; col < _level.boardWidth - 2; col++) {
        final colorMatches = _checkHorizontalMatch(row, col, true);
        if (colorMatches.length >= 3) {
          allMatches.add(colorMatches);
        }

        final shapeMatches = _checkHorizontalMatch(row, col, false);
        if (shapeMatches.length >= 3) {
          allMatches.add(shapeMatches);
        }
      }
    }

    // 检查垂直匹配
    for (int col = 0; col < _level.boardWidth; col++) {
      for (int row = 0; row < _level.boardHeight - 2; row++) {
        final colorMatches = _checkVerticalMatch(row, col, true);
        if (colorMatches.length >= 3) {
          allMatches.add(colorMatches);
        }

        final shapeMatches = _checkVerticalMatch(row, col, false);
        if (shapeMatches.length >= 3) {
          allMatches.add(shapeMatches);
        }
      }
    }

    return allMatches;
  }

  // 检查水平匹配
  List<Position> _checkHorizontalMatch(
    int startRow,
    int startCol,
    bool checkColor,
  ) {
    List<Position> matches = [];

    final startUnit = _board[startRow][startCol];
    if (startUnit == null) return matches;

    matches.add(Position(row: startRow, col: startCol));

    for (int col = startCol + 1; col < _level.boardWidth; col++) {
      final unit = _board[startRow][col];
      if (unit == null) break;

      bool isMatch = checkColor
          ? unit.color == startUnit.color
          : unit.shape == startUnit.shape;

      if (isMatch) {
        matches.add(Position(row: startRow, col: col));
      } else {
        break;
      }
    }

    return matches;
  }

  // 检查垂直匹配
  List<Position> _checkVerticalMatch(
    int startRow,
    int startCol,
    bool checkColor,
  ) {
    List<Position> matches = [];

    final startUnit = _board[startRow][startCol];
    if (startUnit == null) return matches;

    matches.add(Position(row: startRow, col: startCol));

    for (int row = startRow + 1; row < _level.boardHeight; row++) {
      final unit = _board[row][startCol];
      if (unit == null) break;

      bool isMatch = checkColor
          ? unit.color == startUnit.color
          : unit.shape == startUnit.shape;

      if (isMatch) {
        matches.add(Position(row: row, col: startCol));
      } else {
        break;
      }
    }

    return matches;
  }

  // 处理匹配
  void _processMatches(List<List<Position>> matches) {
    // 防止无限递归
    _processingChainDepth++;
    if (_processingChainDepth > _maxChainDepth) {
      _comboChain = 0;
      return;
    }

    // 记录已处理的位置
    Set<String> processedPositions = {};

    // 检查完美匹配
    int plexiMatchCount = 0;
    int lockedUnitsRemoved = 0;
    int changingUnitsRemoved = 0;
    int purifiedTiles = 0;

    // 记录需要在后续处理的特殊效果
    List<Position> newPollutedPositions = [];
    List<Position> changingUnitPositions = [];

    for (final match in matches) {
      // 检查是否为完美匹配
      bool isPerfectMatch = _isPerfectMatch(match);
      if (isPerfectMatch) {
        plexiMatchCount++;
      }

      // 处理匹配的单元
      for (final position in match) {
        final posKey = '${position.row},${position.col}';
        if (!processedPositions.contains(posKey)) {
          processedPositions.add(posKey);

          final unit = _board[position.row][position.col];
          if (unit != null) {
            // 检查是否为锁定单元
            if (unit.isLocked) {
              lockedUnitsRemoved++;
            }

            // 检查是否为变色龙单元
            if (unit.isChanging) {
              // 注意：在第4、5、6关，变色龙单元只能通过嬗变能力消除，而不是通过普通匹配
              // 所以这里不计入changingUnitsRemoved
              if (_level.id < 4) {
                changingUnitsRemoved++;
              }

              // 在第4关及以上，变色龙单元消除后会随机在附近生成新的变色龙单元
              if (_level.id >= 4 && Random().nextDouble() < 0.5) {
                // 尝试在附近找一个位置放置新的变色龙单元
                _findAdjacentPositionForSpecialUnit(
                  position,
                  changingUnitPositions,
                );
              }
            }

            // 检查是否为污染格子
            if (unit.isPolluted) {
              // 注意：在第5、6关，污染格子只能通过嬗变能力净化，而不是通过普通匹配
              // 所以这里不计入purifiedTiles
              if (_level.id < 5) {
                purifiedTiles++;
              }

              // 在第5关及以上，污染格子消除后会随机在附近生成新的污染格子
              if (_level.id >= 5 && Random().nextDouble() < 0.6) {
                // 尝试在附近找一个位置放置新的污染格子
                _findAdjacentPositionForSpecialUnit(
                  position,
                  newPollutedPositions,
                );
              }
            }
          }

          // 移除单元
          _board[position.row][position.col] = null;
        }
      }

      // 计算分数
      int matchScore = match.length * 10;
      if (isPerfectMatch) {
        matchScore *= 2; // 完美匹配额外奖励，是常规匹配的一倍
      }
      _score += matchScore;
    }

    // 更新完美匹配计数
    _plexiMatches += plexiMatchCount;

    // 更新关卡特殊目标计数
    if (_level.objective.type == LevelObjectiveType.lockedUnits) {
      _level.objective.current += lockedUnitsRemoved;
    } else if (_level.objective.type == LevelObjectiveType.changingUnits &&
        _level.id < 4) {
      // 只有在非特殊关卡中，才通过普通匹配更新变色龙单元目标
      _level.objective.current += changingUnitsRemoved;
    } else if (_level.objective.type == LevelObjectiveType.purifyTiles &&
        _level.id < 5) {
      // 只有在非特殊关卡中，才通过普通匹配更新净化目标
      _level.objective.current += purifiedTiles;
    }

    // 每个完美匹配奖励一个嬗变技能
    // 在第4、5、6关，嬗变能力是唯一可以消除变色龙单元和净化污染格子的方法
    if (_level.id <= 3) {
      _transmutes += plexiMatchCount;
    } else if (_level.id <= 5) {
      _transmutes += plexiMatchCount; // 保持完整的嬗变奖励，因为这是唯一的方法
    } else {
      _transmutes += plexiMatchCount; // 保持完整的嬗变奖励，因为这是唯一的方法
    }

    // 填充空缺
    _fillEmptySpaces();

    // 处理特殊效果（在填充空缺后）
    _processSpecialEffects(changingUnitPositions, newPollutedPositions);
  }

  // 查找附近可用位置放置特殊单元
  void _findAdjacentPositionForSpecialUnit(
    Position origin,
    List<Position> targetList,
  ) {
    final random = Random();
    final directions = [
      [-1, 0], [1, 0], [0, -1], [0, 1], // 上下左右
      [-1, -1], [-1, 1], [1, -1], [1, 1], // 对角线
    ];

    // 随机打乱方向顺序
    directions.shuffle(random);

    // 尝试每个方向
    for (final dir in directions) {
      final newRow = origin.row + dir[0];
      final newCol = origin.col + dir[1];

      // 检查位置是否有效
      if (newRow >= 0 &&
          newRow < _level.boardHeight &&
          newCol >= 0 &&
          newCol < _level.boardWidth) {
        // 将该位置添加到目标列表
        targetList.add(Position(row: newRow, col: newCol));
        break; // 找到一个位置就退出
      }
    }
  }

  // 处理特殊效果（在填充空缺后）
  void _processSpecialEffects(
    List<Position> changingUnitPositions,
    List<Position> newPollutedPositions,
  ) {
    final random = Random();
    final colors = ['r', 'g', 'b', 'y', 'p'];
    final shapes = ['c', 's', 't'];

    // 处理新的变色龙单元
    for (final pos in changingUnitPositions) {
      if (_isValidPosition(pos) &&
          _board[pos.row][pos.col] != null &&
          !_board[pos.row][pos.col]!.isLocked &&
          !_board[pos.row][pos.col]!.isChanging) {
        _board[pos.row][pos.col] = _board[pos.row][pos.col]!.copyWith(
          isChanging: true,
        );
      }
    }

    // 处理新的污染格子
    for (final pos in newPollutedPositions) {
      if (_isValidPosition(pos) &&
          _board[pos.row][pos.col] != null &&
          !_board[pos.row][pos.col]!.isPolluted &&
          !_board[pos.row][pos.col]!.isLocked) {
        _board[pos.row][pos.col] = _board[pos.row][pos.col]!.copyWith(
          isPolluted: true,
        );
      }
    }

    // 在第4关及以上，随机改变部分变色龙单元的颜色或形状
    if (_level.id >= 4) {
      for (int row = 0; row < _level.boardHeight; row++) {
        for (int col = 0; col < _level.boardWidth; col++) {
          final unit = _board[row][col];
          if (unit != null && unit.isChanging && random.nextDouble() < 0.3) {
            if (random.nextBool()) {
              // 改变颜色
              String newColor;
              do {
                newColor = colors[random.nextInt(colors.length)];
              } while (newColor == unit.color);
              _board[row][col] = unit.copyWith(color: newColor);
            } else {
              // 改变形状
              String newShape;
              do {
                newShape = shapes[random.nextInt(shapes.length)];
              } while (newShape == unit.shape);
              _board[row][col] = unit.copyWith(shape: newShape);
            }
          }
        }
      }
    }
  }

  // 检查是否为完美匹配
  bool _isPerfectMatch(List<Position> match) {
    if (match.length < 3) return false;

    final firstUnit = _board[match[0].row][match[0].col];
    if (firstUnit == null) return false;

    String firstColor = firstUnit.color;
    String firstShape = firstUnit.shape;

    for (int i = 1; i < match.length; i++) {
      final unit = _board[match[i].row][match[i].col];
      if (unit == null) return false;

      if (unit.color != firstColor || unit.shape != firstShape) {
        return false;
      }
    }

    return true;
  }

  // 填充空缺并实现重力效果
  void _fillEmptySpaces() {
    // 从底部向上处理每一列

    // 第一步：应用重力，让单元向下掉落
    for (int col = 0; col < _level.boardWidth; col++) {
      // 从底部向上移动单元
      for (int row = _level.boardHeight - 2; row >= 0; row--) {
        // 如果当前位置有单元，而下方是空的，则下移
        if (_board[row][col] != null) {
          int dropRow = row;
          // 查找该单元可以下落到的最低位置
          while (dropRow + 1 < _level.boardHeight &&
              _board[dropRow + 1][col] == null) {
            dropRow++;
          }

          // 如果找到了更低的位置，移动单元
          if (dropRow != row) {
            final unit = _board[row][col]!;
            _board[dropRow][col] = unit.copyWith(
              position: Position(row: dropRow, col: col),
            );
            _board[row][col] = null;
          }
        }
      }
    }

    // 第二步：在顶部填充新单元
    for (int col = 0; col < _level.boardWidth; col++) {
      for (int row = 0; row < _level.boardHeight; row++) {
        if (_board[row][col] == null) {
          _board[row][col] = _generateRandomUnit(row, col);
        }
      }
    }

    // 检查是否有新的匹配
    final newMatches = _findMatches();
    if (newMatches.isNotEmpty) {
      _comboChain++;
      // 如果递归深度未达到上限，继续处理匹配
      if (_processingChainDepth < _maxChainDepth) {
        _processMatches(newMatches);
      }
    } else {
      _comboChain = 0;
    }
  }

  // 生成随机单元
  GameUnit _generateRandomUnit(int row, int col) {
    final random = Random();
    final colors = ['r', 'g', 'b', 'y', 'p'];
    final shapes = ['c', 's', 't'];

    // 尝试生成一个不会立即导致匹配的单元
    for (int attempt = 0; attempt < 5; attempt++) {
      final color = colors[random.nextInt(colors.length)];
      final shape = shapes[random.nextInt(shapes.length)];

      if (!_wouldCauseMatch(row, col, color, shape)) {
        return GameUnit(
          color: color,
          shape: shape,
          position: Position(row: row, col: col),
        );
      }
    }

    // 如果尝试多次仍无法避免匹配，就返回一个随机单元
    return GameUnit(
      color: colors[random.nextInt(colors.length)],
      shape: shapes[random.nextInt(shapes.length)],
      position: Position(row: row, col: col),
    );
  }
}
