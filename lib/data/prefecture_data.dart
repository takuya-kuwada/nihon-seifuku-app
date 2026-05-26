import 'package:flutter/material.dart';

class PrefectureInfo {
  final String name;
  final String stampEmoji;
  final String specialty;
  final String note;
  final Color color;

  const PrefectureInfo({
    required this.name,
    required this.stampEmoji,
    required this.specialty,
    required this.note,
    required this.color,
  });
}

const Map<String, PrefectureInfo> prefectureData = {
  // 北海道
  '北海道': PrefectureInfo(name: '北海道', stampEmoji: '🦀', specialty: 'ズワイガニ', note: '広大な大地と新鮮な海の幸', color: Color(0xFF1565C0)),
  // 東北
  '青森県': PrefectureInfo(name: '青森県', stampEmoji: '🍎', specialty: 'りんご', note: '生産量日本一のりんごの里', color: Color(0xFFE53935)),
  '岩手県': PrefectureInfo(name: '岩手県', stampEmoji: '🍜', specialty: 'わんこそば', note: '食べ放題の伝統そば文化', color: Color(0xFF43A047)),
  '宮城県': PrefectureInfo(name: '宮城県', stampEmoji: '🦪', specialty: '牡蠣', note: '仙台・松島の絶景と海鮮', color: Color(0xFF00838F)),
  '秋田県': PrefectureInfo(name: '秋田県', stampEmoji: '🍶', specialty: '日本酒', note: 'きりたんぽと豊かな米文化', color: Color(0xFF6A1B9A)),
  '山形県': PrefectureInfo(name: '山形県', stampEmoji: '🍒', specialty: 'さくらんぼ', note: '生産量日本一のさくらんぼ', color: Color(0xFFC62828)),
  '福島県': PrefectureInfo(name: '福島県', stampEmoji: '🍑', specialty: '桃', note: '会津・磐梯の自然と桃の名産', color: Color(0xFFEF6C00)),
  // 関東
  '茨城県': PrefectureInfo(name: '茨城県', stampEmoji: '🥜', specialty: '納豆', note: '水戸といえば水戸黄門と納豆', color: Color(0xFF558B2F)),
  '栃木県': PrefectureInfo(name: '栃木県', stampEmoji: '🍓', specialty: 'いちご', note: '生産量日本一のとちおとめ', color: Color(0xFFAD1457)),
  '群馬県': PrefectureInfo(name: '群馬県', stampEmoji: '♨️', specialty: '温泉', note: '草津・伊香保の名湯の里', color: Color(0xFF00695C)),
  '埼玉県': PrefectureInfo(name: '埼玉県', stampEmoji: '🍠', specialty: '芋けんぴ', note: '川越の小江戸と芋文化', color: Color(0xFFF9A825)),
  '千葉県': PrefectureInfo(name: '千葉県', stampEmoji: '🥜', specialty: '落花生', note: '生産量日本一の落花生の里', color: Color(0xFF283593)),
  '東京都': PrefectureInfo(name: '東京都', stampEmoji: '🗼', specialty: '東京バナナ', note: '日本の首都・世界の大都市', color: Color(0xFFB71C1C)),
  '神奈川県': PrefectureInfo(name: '神奈川県', stampEmoji: '🍜', specialty: '横浜中華', note: '横浜・鎌倉・湘南の魅力', color: Color(0xFF0D47A1)),
  // 中部
  '新潟県': PrefectureInfo(name: '新潟県', stampEmoji: '🍚', specialty: 'コシヒカリ', note: '日本一の米どころ', color: Color(0xFF33691E)),
  '富山県': PrefectureInfo(name: '富山県', stampEmoji: '🦐', specialty: 'ホタルイカ', note: '黒部ダムと神秘のホタルイカ', color: Color(0xFF004D40)),
  '石川県': PrefectureInfo(name: '石川県', stampEmoji: '🦀', specialty: '加能ガニ', note: '金沢・兼六園と日本海の幸', color: Color(0xFF1A237E)),
  '福井県': PrefectureInfo(name: '福井県', stampEmoji: '🦀', specialty: '越前ガニ', note: '恐竜化石と越前ガニの産地', color: Color(0xFF880E4F)),
  '山梨県': PrefectureInfo(name: '山梨県', stampEmoji: '🍇', specialty: 'ぶどう', note: '富士山とフルーツ王国', color: Color(0xFF4A148C)),
  '長野県': PrefectureInfo(name: '長野県', stampEmoji: '🍎', specialty: 'りんご・そば', note: '信州の大自然とそば文化', color: Color(0xFF1B5E20)),
  '岐阜県': PrefectureInfo(name: '岐阜県', stampEmoji: '🪨', specialty: '飛騨牛', note: '白川郷と飛騨の匠の里', color: Color(0xFFE65100)),
  '静岡県': PrefectureInfo(name: '静岡県', stampEmoji: '🍵', specialty: 'お茶', note: '富士山と日本一の茶の産地', color: Color(0xFF2E7D32)),
  '愛知県': PrefectureInfo(name: '愛知県', stampEmoji: '🍱', specialty: '名古屋めし', note: '味噌カツ・ひつまぶしの故郷', color: Color(0xFF0277BD)),
  // 近畿
  '三重県': PrefectureInfo(name: '三重県', stampEmoji: '🦞', specialty: '伊勢海老', note: '伊勢神宮と海の幸の聖地', color: Color(0xFF00838F)),
  '滋賀県': PrefectureInfo(name: '滋賀県', stampEmoji: '🐟', specialty: 'ふなずし', note: '琵琶湖と日本最古の発酵食品', color: Color(0xFF37474F)),
  '京都府': PrefectureInfo(name: '京都府', stampEmoji: '⛩️', specialty: '京料理', note: '千年の都・和の文化の中心', color: Color(0xFF6A1B9A)),
  '大阪府': PrefectureInfo(name: '大阪府', stampEmoji: '🐙', specialty: 'たこ焼き', note: '食いだおれの街・天下の台所', color: Color(0xFFE65100)),
  '兵庫県': PrefectureInfo(name: '兵庫県', stampEmoji: '🥩', specialty: '神戸牛', note: '神戸・姫路城と世界最高の牛肉', color: Color(0xFFC62828)),
  '奈良県': PrefectureInfo(name: '奈良県', stampEmoji: '🦌', specialty: '柿の葉寿司', note: '大仏と鹿が暮らす古都', color: Color(0xFF33691E)),
  '和歌山県': PrefectureInfo(name: '和歌山県', stampEmoji: '🍊', specialty: 'みかん', note: '熊野古道と紀州みかんの里', color: Color(0xFFE65100)),
  // 中国
  '鳥取県': PrefectureInfo(name: '鳥取県', stampEmoji: '🏜️', specialty: '松葉ガニ', note: '砂丘と日本一小さな県の誇り', color: Color(0xFFF57F17)),
  '島根県': PrefectureInfo(name: '島根県', stampEmoji: '⛩️', specialty: '出雲そば', note: '出雲大社と縁結びの聖地', color: Color(0xFF4527A0)),
  '岡山県': PrefectureInfo(name: '岡山県', stampEmoji: '🍑', specialty: '白桃', note: '晴れの国・桃太郎の故郷', color: Color(0xFFFF6F00)),
  '広島県': PrefectureInfo(name: '広島県', stampEmoji: '🦪', specialty: 'かき', note: '平和の街と広島カキの名産', color: Color(0xFF283593)),
  '山口県': PrefectureInfo(name: '山口県', stampEmoji: '🐡', specialty: 'ふぐ', note: '下関とふぐ料理の本場', color: Color(0xFF006064)),
  // 四国
  '徳島県': PrefectureInfo(name: '徳島県', stampEmoji: '💃', specialty: '阿波踊り', note: '鳴門の渦潮と阿波踊りの里', color: Color(0xFFAD1457)),
  '香川県': PrefectureInfo(name: '香川県', stampEmoji: '🍜', specialty: '讃岐うどん', note: 'うどん県！讃岐うどんの聖地', color: Color(0xFF00695C)),
  '愛媛県': PrefectureInfo(name: '愛媛県', stampEmoji: '🍊', specialty: 'みかん', note: 'みきゃんの国・道後温泉', color: Color(0xFFE65100)),
  '高知県': PrefectureInfo(name: '高知県', stampEmoji: '🐟', specialty: 'カツオ', note: '坂本龍馬の故郷・土佐の一本釣り', color: Color(0xFF1565C0)),
  // 九州・沖縄
  '福岡県': PrefectureInfo(name: '福岡県', stampEmoji: '🍜', specialty: '博多ラーメン', note: '九州の玄関口・屋台文化の街', color: Color(0xFFC62828)),
  '佐賀県': PrefectureInfo(name: '佐賀県', stampEmoji: '🏺', specialty: '有田焼', note: '伝統磁器と名護屋城の里', color: Color(0xFF4A148C)),
  '長崎県': PrefectureInfo(name: '長崎県', stampEmoji: '🏮', specialty: 'ちゃんぽん', note: '出島・ハウステンボスと異国情緒', color: Color(0xFF0277BD)),
  '熊本県': PrefectureInfo(name: '熊本県', stampEmoji: '🐻', specialty: '馬刺し', note: 'くまモンの故郷・阿蘇の大地', color: Color(0xFF2E7D32)),
  '大分県': PrefectureInfo(name: '大分県', stampEmoji: '♨️', specialty: '関アジ関サバ', note: '温泉大国・別府地獄めぐり', color: Color(0xFFBF360C)),
  '宮崎県': PrefectureInfo(name: '宮崎県', stampEmoji: '🥭', specialty: 'マンゴー', note: '日南海岸と南国フルーツの里', color: Color(0xFF558B2F)),
  '鹿児島県': PrefectureInfo(name: '鹿児島県', stampEmoji: '🌋', specialty: '黒豚', note: '桜島と黒豚・芋焼酎の故郷', color: Color(0xFF37474F)),
  '沖縄県': PrefectureInfo(name: '沖縄県', stampEmoji: '🌺', specialty: 'ゴーヤー', note: '青い海・首里城・琉球文化', color: Color(0xFF00838F)),
};

String normalizePrefecture(String raw) {
  if (raw.endsWith('都') || raw.endsWith('道') ||
      raw.endsWith('府') || raw.endsWith('県')) {
    return raw;
  }
  if (raw == '東京') return '東京都';
  if (raw == '北海道') return '北海道';
  if (raw == '大阪') return '大阪府';
  if (raw == '京都') return '京都府';
  return '$raw県';
}
