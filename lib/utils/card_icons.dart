import 'package:flutter/material.dart';

/// 卡片图标工具类
class CardIcons {
  /// 获取指定主题的图标列表
  static List<String> getIconsForTheme(String theme) {
    switch (theme) {
      case 'nature':
        // 第一关：自然主题 - 使用与记忆力相关的图标
        return [
          'brain',
          'psychology',
          'lightbulb',
          'extension',
          'school',
          'insights',
          'tips_and_updates',
          'auto_awesome_motion',
          'auto_awesome',
          'emoji_objects',
          'visibility',
          'search',
          'memory',
          'biotech',
          'science',
          'self_improvement',
          'spa',
          'extension',
          'emoji_symbols',
          'emoji_events',
        ];
      case 'animals':
        // 第二关：动物主题 - 使用游戏和娱乐相关的图标
        return [
          'sports_esports',
          'games',
          'casino',
          'sports_score',
          'emoji_events',
          'celebration',
          'videogame_asset',
          'extension',
          'sports_basketball',
          'sports_soccer',
          'sports_tennis',
          'sports_volleyball',
          'golf_course',
          'sports_football',
          'sports_baseball',
          'sports_cricket',
          'sports_hockey',
          'sports_handball',
          'sports_kabaddi',
          'sports_mma',
        ];
      case 'food':
        // 第三关：食物主题 - 使用思考和策略相关的图标
        return [
          'psychology',
          'lightbulb',
          'extension',
          'tips_and_updates',
          'insights',
          'grid_view',
          'view_module',
          'dashboard',
          'category',
          'view_quilt',
          'apps',
          'grain',
          'bubble_chart',
          'view_carousel',
          'view_array',
          'view_column',
          'memory',
          'view_day',
          'view_list',
          'view_module',
        ];
      case 'travel':
        // 第四关：旅行主题 - 使用挑战和成就相关的图标
        return [
          'emoji_events',
          'military_tech',
          'workspace_premium',
          'verified',
          'thumb_up',
          'stars',
          'star_rate',
          'star_half',
          'star',
          'star_border',
          'recommend',
          'leaderboard',
          'grade',
          'flare',
          'filter_vintage',
          'diamond',
          'bolt',
          'auto_awesome',
          'auto_fix_high',
          'extension',
        ];
      case 'space':
        // 第五关：太空主题 - 使用时间和速度相关的图标
        return [
          'timer',
          'timelapse',
          'timer_10',
          'timer_3',
          'schedule',
          'speed',
          'rocket_launch',
          'rocket',
          'pending',
          'hourglass_top',
          'hourglass_empty',
          'hourglass_bottom',
          'history_toggle_off',
          'history',
          'fast_forward',
          'fast_rewind',
          'av_timer',
          'extension',
          'memory',
          'science',
        ];
      case 'tech':
        // 第六关：科技主题 - 使用游戏控制和技术相关的图标
        return [
          'videogame_asset',
          'sports_esports',
          'games',
          'gamepad',
          'keyboard',
          'mouse',
          'memory',
          'developer_board',
          'devices',
          'computer',
          'laptop',
          'smartphone',
          'tablet',
          'headphones',
          'headset',
          'speaker',
          'memory',
          'extension',
          'settings',
          'code',
        ];
      case 'fantasy':
        // 第七关：幻想主题 - 使用魔法和特殊能力相关的图标
        return [
          'auto_awesome',
          'auto_fix_high',
          'bolt',
          'flare',
          'flash_on',
          'emoji_objects',
          'emoji_nature',
          'energy_savings_leaf',
          'fireplace',
          'forest',
          'local_fire_department',
          'self_improvement',
          'spa',
          'water_drop',
          'waves',
          'wb_sunny',
          'whatshot',
          'extension',
          'memory',
          'psychology',
        ];
      default:
        // 默认图标 - 使用记忆游戏相关的图标
        return [
          'memory',
          'extension',
          'grid_view',
          'view_module',
          'dashboard',
          'category',
          'apps',
          'psychology',
          'lightbulb',
          'emoji_objects',
          'visibility',
          'search',
          'science',
          'biotech',
          'insights',
          'tips_and_updates',
          'auto_awesome',
          'emoji_events',
          'stars',
          'sports_esports',
        ];
    }
  }

  /// 获取图标数据
  static IconData getIconData(String iconName) {
    switch (iconName) {
      // 记忆游戏相关图标
      case 'brain':
        return Icons.psychology;
      case 'psychology':
        return Icons.psychology;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'extension':
        return Icons.extension;
      case 'school':
        return Icons.school;
      case 'insights':
        return Icons.insights;
      case 'tips_and_updates':
        return Icons.tips_and_updates;
      case 'auto_awesome_motion':
        return Icons.auto_awesome_motion;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'emoji_objects':
        return Icons.emoji_objects;
      case 'visibility':
        return Icons.visibility;
      case 'search':
        return Icons.search;
      case 'memory':
        return Icons.memory;
      case 'biotech':
        return Icons.biotech;
      case 'science':
        return Icons.science;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'spa':
        return Icons.spa;
      case 'emoji_symbols':
        return Icons.emoji_symbols;
      case 'emoji_events':
        return Icons.emoji_events;

      // 游戏相关图标
      case 'sports_esports':
        return Icons.sports_esports;
      case 'games':
        return Icons.games;
      case 'casino':
        return Icons.casino;
      case 'sports_score':
        return Icons.sports_score;
      case 'celebration':
        return Icons.celebration;
      case 'videogame_asset':
        return Icons.videogame_asset;
      case 'toys':
        return Icons.toys;
      case 'sports_basketball':
        return Icons.sports_basketball;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'sports_tennis':
        return Icons.sports_tennis;
      case 'sports_volleyball':
        return Icons.sports_volleyball;
      case 'golf_course':
        return Icons.golf_course;
      case 'sports_football':
        return Icons.sports_football;
      case 'sports_baseball':
        return Icons.sports_baseball;
      case 'sports_cricket':
        return Icons.sports_cricket;
      case 'sports_hockey':
        return Icons.sports_hockey;
      case 'sports_handball':
        return Icons.sports_handball;
      case 'sports_kabaddi':
        return Icons.sports_kabaddi;
      case 'sports_mma':
        return Icons.sports_mma;

      // 思考和策略相关图标
      case 'grid_view':
        return Icons.grid_view;
      case 'view_module':
        return Icons.view_module;
      case 'dashboard':
        return Icons.dashboard;
      case 'category':
        return Icons.category;
      case 'view_quilt':
        return Icons.view_quilt;
      case 'apps':
        return Icons.apps;
      case 'grain':
        return Icons.grain;
      case 'bubble_chart':
        return Icons.bubble_chart;
      case 'view_carousel':
        return Icons.view_carousel;
      case 'view_array':
        return Icons.view_array;
      case 'view_column':
        return Icons.view_column;
      case 'view_day':
        return Icons.view_day;
      case 'view_list':
        return Icons.view_list;

      // 成就相关图标
      case 'workspace_premium':
        return Icons.workspace_premium;
      case 'verified':
        return Icons.verified;
      case 'thumb_up':
        return Icons.thumb_up;
      case 'stars':
        return Icons.stars;
      case 'star_rate':
        return Icons.star_rate;
      case 'star_half':
        return Icons.star_half;
      case 'star':
        return Icons.star;
      case 'star_border':
        return Icons.star_border;
      case 'recommend':
        return Icons.recommend;
      case 'leaderboard':
        return Icons.leaderboard;
      case 'grade':
        return Icons.grade;
      case 'flare':
        return Icons.flare;
      case 'filter_vintage':
        return Icons.filter_vintage;
      case 'diamond':
        return Icons.diamond;
      case 'bolt':
        return Icons.bolt;
      case 'auto_fix_high':
        return Icons.auto_fix_high;

      // 时间相关图标
      case 'timer':
        return Icons.timer;
      case 'timelapse':
        return Icons.timelapse;
      case 'timer_10':
        return Icons.timer_10;
      case 'timer_3':
        return Icons.timer_3;
      case 'schedule':
        return Icons.schedule;
      case 'speed':
        return Icons.speed;
      case 'rocket_launch':
        return Icons.rocket_launch;
      case 'rocket':
        return Icons.rocket;
      case 'pending':
        return Icons.pending;
      case 'hourglass_top':
        return Icons.hourglass_top;
      case 'hourglass_empty':
        return Icons.hourglass_empty;
      case 'hourglass_bottom':
        return Icons.hourglass_bottom;
      case 'history_toggle_off':
        return Icons.history_toggle_off;
      case 'history':
        return Icons.history;
      case 'fast_forward':
        return Icons.fast_forward;
      case 'fast_rewind':
        return Icons.fast_rewind;
      case 'av_timer':
        return Icons.av_timer;

      // 游戏控制和技术图标
      case 'gamepad':
        return Icons.gamepad;
      case 'computer':
        return Icons.computer;
      case 'smartphone':
        return Icons.smartphone;
      case 'devices':
        return Icons.devices;
      case 'laptop':
        return Icons.laptop;
      case 'tablet':
        return Icons.tablet;
      case 'headphones':
        return Icons.headphones;
      case 'headset':
        return Icons.headset;
      case 'speaker':
        return Icons.speaker;
      case 'keyboard':
        return Icons.keyboard;
      case 'mouse':
        return Icons.mouse;
      case 'developer_board':
        return Icons.developer_board;
      case 'settings':
        return Icons.settings;
      case 'code':
        return Icons.code;

      // 魔法和特殊能力图标
      case 'flash_on':
        return Icons.flash_on;
      case 'whatshot':
        return Icons.whatshot;
      case 'emoji_nature':
        return Icons.emoji_nature;
      case 'energy_savings_leaf':
        return Icons.energy_savings_leaf;
      case 'fireplace':
        return Icons.fireplace;
      case 'forest':
        return Icons.forest;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'water_drop':
        return Icons.water_drop;
      case 'waves':
        return Icons.waves;
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'wb_twilight':
        return Icons.wb_twilight;
      case 'thunderstorm':
        return Icons.thunderstorm;
      case 'tornado':
        return Icons.tornado;

      // 通用图标
      case 'favorite':
        return Icons.favorite;
      case 'flag':
        return Icons.flag;
      case 'build':
        return Icons.build;
      case 'music_note':
        return Icons.music_note;
      case 'camera':
        return Icons.camera;
      case 'brush':
        return Icons.brush;
      case 'color_lens':
        return Icons.color_lens;
      case 'palette':
        return Icons.palette;
      case 'gift':
        return Icons.card_giftcard;

      default:
        return Icons.help_outline;
    }
  }
}
