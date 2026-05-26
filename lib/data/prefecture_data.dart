import 'package:flutter/material.dart';

class PrefectureInfo {
  final String name;
  final String englishName;
  final String stampEmoji;
  final String specialty;
  final String specialMove;
  final String note;
  final Color color;

  const PrefectureInfo({
    required this.name,
    required this.englishName,
    required this.stampEmoji,
    required this.specialty,
    required this.specialMove,
    required this.note,
    required this.color,
  });
}

const Map<String, PrefectureInfo> prefectureData = {
  // 北海道
  '北海道': PrefectureInfo(
    name: '北海道', englishName: 'HOKKAIDO', stampEmoji: '🦀',
    specialty: 'ズワイガニ、ジンギスカン', specialMove: '流氷アイスクラッシュ',
    note: '広大な大地と新鮮な海の幸', color: Color(0xFF1565C0)),
  // 東北
  '青森県': PrefectureInfo(
    name: '青森県', englishName: 'AOMORI', stampEmoji: '🍎',
    specialty: 'りんご、ねぶた', specialMove: 'ねぶた炎爆弾',
    note: '生産量日本一のりんごの里', color: Color(0xFFE53935)),
  '岩手県': PrefectureInfo(
    name: '岩手県', englishName: 'IWATE', stampEmoji: '🍜',
    specialty: 'わんこそば、南部鉄器', specialMove: '南部鉄器プレス',
    note: '食べ放題の伝統そば文化', color: Color(0xFF43A047)),
  '宮城県': PrefectureInfo(
    name: '宮城県', englishName: 'MIYAGI', stampEmoji: '🦪',
    specialty: '牛タン、牡蠣', specialMove: '牛タン一刀斬り',
    note: '仙台・松島の絶景と海鮮', color: Color(0xFF00838F)),
  '秋田県': PrefectureInfo(
    name: '秋田県', englishName: 'AKITA', stampEmoji: '🍶',
    specialty: 'きりたんぽ、日本酒', specialMove: 'きりたんぽ連打',
    note: 'きりたんぽと豊かな米文化', color: Color(0xFF6A1B9A)),
  '山形県': PrefectureInfo(
    name: '山形県', englishName: 'YAMAGATA', stampEmoji: '🍒',
    specialty: 'さくらんぼ、芋煮', specialMove: 'さくらんぼ爆弾',
    note: '生産量日本一のさくらんぼ', color: Color(0xFFC62828)),
  '福島県': PrefectureInfo(
    name: '福島県', englishName: 'FUKUSHIMA', stampEmoji: '🍑',
    specialty: '桃、会津工芸', specialMove: '桃ホールド',
    note: '会津・磐梯の自然と桃の名産', color: Color(0xFFEF6C00)),
  // 関東
  '茨城県': PrefectureInfo(
    name: '茨城県', englishName: 'IBARAKI', stampEmoji: '🥜',
    specialty: '納豆、れんこん', specialMove: '納豆ネバネバ絡み',
    note: '水戸といえば水戸黄門と納豆', color: Color(0xFF558B2F)),
  '栃木県': PrefectureInfo(
    name: '栃木県', englishName: 'TOCHIGI', stampEmoji: '🍓',
    specialty: 'いちご、日光', specialMove: 'とちおとめスピン',
    note: '生産量日本一のとちおとめ', color: Color(0xFFAD1457)),
  '群馬県': PrefectureInfo(
    name: '群馬県', englishName: 'GUNMA', stampEmoji: '♨️',
    specialty: 'こんにゃく、温泉', specialMove: '空っ風カッター',
    note: '草津・伊香保の名湯の里', color: Color(0xFF00695C)),
  '埼玉県': PrefectureInfo(
    name: '埼玉県', englishName: 'SAITAMA', stampEmoji: '🍠',
    specialty: '川越芋、深谷ねぎ', specialMove: '小江戸芋ストーム',
    note: '川越の小江戸と芋文化', color: Color(0xFFF9A825)),
  '千葉県': PrefectureInfo(
    name: '千葉県', englishName: 'CHIBA', stampEmoji: '🥜',
    specialty: '落花生、房総', specialMove: '落花生バレット',
    note: '生産量日本一の落花生の里', color: Color(0xFF283593)),
  '東京都': PrefectureInfo(
    name: '東京都', englishName: 'TOKYO', stampEmoji: '🗼',
    specialty: '東京バナナ、寿司', specialMove: 'スカイツリー昇竜拳',
    note: '日本の首都・世界の大都市', color: Color(0xFFB71C1C)),
  '神奈川県': PrefectureInfo(
    name: '神奈川県', englishName: 'KANAGAWA', stampEmoji: '🍜',
    specialty: '横浜シュウマイ、湘南の海', specialMove: 'シュウマイ・グレート・ウェーブ',
    note: '横浜・鎌倉・湘南の魅力', color: Color(0xFF0D47A1)),
  // 中部
  '新潟県': PrefectureInfo(
    name: '新潟県', englishName: 'NIIGATA', stampEmoji: '🍚',
    specialty: 'コシヒカリ、日本酒', specialMove: '米どころ米弾',
    note: '日本一の米どころ', color: Color(0xFF33691E)),
  '富山県': PrefectureInfo(
    name: '富山県', englishName: 'TOYAMA', stampEmoji: '🦐',
    specialty: 'ホタルイカ、富山湾の幸', specialMove: 'ホタルイカ閃光',
    note: '黒部ダムと神秘のホタルイカ', color: Color(0xFF004D40)),
  '石川県': PrefectureInfo(
    name: '石川県', englishName: 'ISHIKAWA', stampEmoji: '🦀',
    specialty: '加能ガニ、金箔', specialMove: '百万石の極意',
    note: '金沢・兼六園と日本海の幸', color: Color(0xFF1A237E)),
  '福井県': PrefectureInfo(
    name: '福井県', englishName: 'FUKUI', stampEmoji: '🦀',
    specialty: '越前ガニ、恐竜化石', specialMove: '恐竜化石パンチ',
    note: '恐竜化石と越前ガニの産地', color: Color(0xFF880E4F)),
  '山梨県': PrefectureInfo(
    name: '山梨県', englishName: 'YAMANASHI', stampEmoji: '🍇',
    specialty: 'ぶどう、富士山', specialMove: 'ぶどう重力波',
    note: '富士山とフルーツ王国', color: Color(0xFF4A148C)),
  '長野県': PrefectureInfo(
    name: '長野県', englishName: 'NAGANO', stampEmoji: '🍎',
    specialty: 'りんご、信州そば', specialMove: '信州りんご回転斬り',
    note: '信州の大自然とそば文化', color: Color(0xFF1B5E20)),
  '岐阜県': PrefectureInfo(
    name: '岐阜県', englishName: 'GIFU', stampEmoji: '🪨',
    specialty: '飛騨牛、白川郷', specialMove: '飛騨高山の陣',
    note: '白川郷と飛騨の匠の里', color: Color(0xFFE65100)),
  '静岡県': PrefectureInfo(
    name: '静岡県', englishName: 'SHIZUOKA', stampEmoji: '🍵',
    specialty: 'お茶、富士山', specialMove: '富士山噴火ビーム',
    note: '富士山と日本一の茶の産地', color: Color(0xFF2E7D32)),
  '愛知県': PrefectureInfo(
    name: '愛知県', englishName: 'AICHI', stampEmoji: '🍱',
    specialty: '名古屋めし、味噌カツ', specialMove: '名古屋城天守斬り',
    note: '味噌カツ・ひつまぶしの故郷', color: Color(0xFF0277BD)),
  // 近畿
  '三重県': PrefectureInfo(
    name: '三重県', englishName: 'MIE', stampEmoji: '🦞',
    specialty: '伊勢海老、真珠', specialMove: '伊勢エビ鉄拳',
    note: '伊勢神宮と海の幸の聖地', color: Color(0xFF00838F)),
  '滋賀県': PrefectureInfo(
    name: '滋賀県', englishName: 'SHIGA', stampEmoji: '🐟',
    specialty: 'ふなずし、琵琶湖', specialMove: '琵琶湖大波砲',
    note: '琵琶湖と日本最古の発酵食品', color: Color(0xFF37474F)),
  '京都府': PrefectureInfo(
    name: '京都府', englishName: 'KYOTO', stampEmoji: '⛩️',
    specialty: '京料理、舞妓', specialMove: '舞妓の舞い',
    note: '千年の都・和の文化の中心', color: Color(0xFF6A1B9A)),
  '大阪府': PrefectureInfo(
    name: '大阪府', englishName: 'OSAKA', stampEmoji: '🐙',
    specialty: 'たこ焼き、串カツ', specialMove: 'たこ焼きボール',
    note: '食いだおれの街・天下の台所', color: Color(0xFFE65100)),
  '兵庫県': PrefectureInfo(
    name: '兵庫県', englishName: 'HYOGO', stampEmoji: '🥩',
    specialty: '神戸牛、明石タコ', specialMove: '神戸ビーフ斬り',
    note: '神戸・姫路城と世界最高の牛肉', color: Color(0xFFC62828)),
  '奈良県': PrefectureInfo(
    name: '奈良県', englishName: 'NARA', stampEmoji: '🦌',
    specialty: '柿の葉寿司、鹿', specialMove: '鹿せんべい大砲',
    note: '大仏と鹿が暮らす古都', color: Color(0xFF33691E)),
  '和歌山県': PrefectureInfo(
    name: '和歌山県', englishName: 'WAKAYAMA', stampEmoji: '🍊',
    specialty: 'みかん、梅干し', specialMove: '梅干し酸攻撃',
    note: '熊野古道と紀州みかんの里', color: Color(0xFFE65100)),
  // 中国
  '鳥取県': PrefectureInfo(
    name: '鳥取県', englishName: 'TOTTORI', stampEmoji: '🏜️',
    specialty: '松葉ガニ、砂丘', specialMove: '砂丘砂嵐',
    note: '砂丘と日本一小さな県の誇り', color: Color(0xFFF57F17)),
  '島根県': PrefectureInfo(
    name: '島根県', englishName: 'SHIMANE', stampEmoji: '⛩️',
    specialty: '出雲そば、のどぐろ', specialMove: '出雲縁結び縛り',
    note: '出雲大社と縁結びの聖地', color: Color(0xFF4527A0)),
  '岡山県': PrefectureInfo(
    name: '岡山県', englishName: 'OKAYAMA', stampEmoji: '🍑',
    specialty: '白桃、マスカット', specialMove: '桃太郎鬼退治',
    note: '晴れの国・桃太郎の故郷', color: Color(0xFFFF6F00)),
  '広島県': PrefectureInfo(
    name: '広島県', englishName: 'HIROSHIMA', stampEmoji: '🦪',
    specialty: '牡蠣、お好み焼き', specialMove: '牡蠣シャワー',
    note: '平和の街と広島カキの名産', color: Color(0xFF283593)),
  '山口県': PrefectureInfo(
    name: '山口県', englishName: 'YAMAGUCHI', stampEmoji: '🐡',
    specialty: 'ふぐ、夏みかん', specialMove: 'ふぐ毒針',
    note: '下関とふぐ料理の本場', color: Color(0xFF006064)),
  // 四国
  '徳島県': PrefectureInfo(
    name: '徳島県', englishName: 'TOKUSHIMA', stampEmoji: '💃',
    specialty: '阿波踊り、鳴門金時', specialMove: '阿波踊り乱舞',
    note: '鳴門の渦潮と阿波踊りの里', color: Color(0xFFAD1457)),
  '香川県': PrefectureInfo(
    name: '香川県', englishName: 'KAGAWA', stampEmoji: '🍜',
    specialty: '讃岐うどん、オリーブ', specialMove: 'うどん締め',
    note: 'うどん県！讃岐うどんの聖地', color: Color(0xFF00695C)),
  '愛媛県': PrefectureInfo(
    name: '愛媛県', englishName: 'EHIME', stampEmoji: '🍊',
    specialty: 'みかん、今治タオル', specialMove: 'みかん砲',
    note: 'みきゃんの国・道後温泉', color: Color(0xFFE65100)),
  '高知県': PrefectureInfo(
    name: '高知県', englishName: 'KOCHI', stampEmoji: '🐟',
    specialty: '鰹のたたき、文旦', specialMove: '鰹のたたき連撃',
    note: '坂本龍馬の故郷・土佐の一本釣り', color: Color(0xFF1565C0)),
  // 九州・沖縄
  '福岡県': PrefectureInfo(
    name: '福岡県', englishName: 'FUKUOKA', stampEmoji: '🍜',
    specialty: '博多ラーメン、明太子', specialMove: '明太子爆弾',
    note: '九州の玄関口・屋台文化の街', color: Color(0xFFC62828)),
  '佐賀県': PrefectureInfo(
    name: '佐賀県', englishName: 'SAGA', stampEmoji: '🏺',
    specialty: '有田焼、呼子のイカ', specialMove: '有田焼ロケット',
    note: '伝統磁器と名護屋城の里', color: Color(0xFF4A148C)),
  '長崎県': PrefectureInfo(
    name: '長崎県', englishName: 'NAGASAKI', stampEmoji: '🏮',
    specialty: 'ちゃんぽん、カステラ', specialMove: 'チャンポン旋風',
    note: '出島・ハウステンボスと異国情緒', color: Color(0xFF0277BD)),
  '熊本県': PrefectureInfo(
    name: '熊本県', englishName: 'KUMAMOTO', stampEmoji: '🐻',
    specialty: '馬刺し、阿蘇', specialMove: 'くまモン体当たり',
    note: 'くまモンの故郷・阿蘇の大地', color: Color(0xFF2E7D32)),
  '大分県': PrefectureInfo(
    name: '大分県', englishName: 'OITA', stampEmoji: '♨️',
    specialty: '関アジ関サバ、温泉', specialMove: '温泉蒸気噴射',
    note: '温泉大国・別府地獄めぐり', color: Color(0xFFBF360C)),
  '宮崎県': PrefectureInfo(
    name: '宮崎県', englishName: 'MIYAZAKI', stampEmoji: '🥭',
    specialty: 'マンゴー、地鶏', specialMove: 'チキン南蛮フライ',
    note: '日南海岸と南国フルーツの里', color: Color(0xFF558B2F)),
  '鹿児島県': PrefectureInfo(
    name: '鹿児島県', englishName: 'KAGOSHIMA', stampEmoji: '🌋',
    specialty: '黒豚、芋焼酎', specialMove: '桜島溶岩弾',
    note: '桜島と黒豚・芋焼酎の故郷', color: Color(0xFF37474F)),
  '沖縄県': PrefectureInfo(
    name: '沖縄県', englishName: 'OKINAWA', stampEmoji: '🌺',
    specialty: 'ゴーヤー、琉球料理', specialMove: '琉球空手正拳突き',
    note: '青い海・首里城・琉球文化', color: Color(0xFF00838F)),
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
