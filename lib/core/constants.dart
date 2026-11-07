import 'package:flutter/material.dart';
import '../models/hero_model.dart';

enum HokLane {
  clash('Clash Lane', '对抗路', Icons.shield_outlined, Color(0xFFE67E22)),
  jungle('Jungle', '打野', Icons.flash_on_outlined, Color(0xFF9B59B6)),
  mid('Mid Lane', '中路', Icons.auto_fix_high_outlined, Color(0xFF3498DB)),
  farm('Farm Lane', '发育路', Icons.gps_fixed_outlined, Color(0xFFE74C3C)),
  roam('Roamer', '游走', Icons.volunteer_activism_outlined, Color(0xFF2ECC71));

  final String displayName;
  final String chineseName;
  final IconData icon;
  final Color accentColor;

  const HokLane(this.displayName, this.chineseName, this.icon, this.accentColor);
}

class AppConstants {
  static const String appTitle = 'HOK Power Lane & Hero Calculator';
  static const String appSubtitle = 'Kalkulator Power Lane & Target 段位 Honor of Kings';

  // Daftar Hero Resmi Honor of Kings per Role/Lane
  static const List<HokHero> allHeroes = [
    // Clash Lane
    HokHero(id: 'allain', name: 'Allain', lane: HokLane.clash, defaultPower: 3500),
    HokHero(id: 'arthur', name: 'Arthur', lane: HokLane.clash, defaultPower: 4000),
    HokHero(id: 'biron', name: 'Biron', lane: HokLane.clash, defaultPower: 3600),
    HokHero(id: 'charlotte', name: 'Charlotte', lane: HokLane.clash, defaultPower: 4200),
    HokHero(id: 'dun', name: 'Dun', lane: HokLane.clash, defaultPower: 3800),
    HokHero(id: 'fuzi', name: 'Fuzi', lane: HokLane.clash, defaultPower: 4100),
    HokHero(id: 'guan_yu', name: 'Guan Yu', lane: HokLane.clash, defaultPower: 4500),
    HokHero(id: 'kaizer', name: 'Kaizer', lane: HokLane.clash, defaultPower: 4200),
    HokHero(id: 'lian_po', name: 'Lian Po', lane: HokLane.clash, defaultPower: 3500),
    HokHero(id: 'lu_bu', name: 'Lu Bu', lane: HokLane.clash, defaultPower: 4400),
    HokHero(id: 'mayene', name: 'Mayene', lane: HokLane.clash, defaultPower: 4300),
    HokHero(id: 'meng_tian', name: 'Meng Tian', lane: HokLane.clash, defaultPower: 4000),
    HokHero(id: 'mulan', name: 'Mulan', lane: HokLane.clash, defaultPower: 4600),
    HokHero(id: 'sun_ce', name: 'Sun Ce', lane: HokLane.clash, defaultPower: 4100),
    HokHero(id: 'dharma', name: 'Dharma', lane: HokLane.clash, defaultPower: 3900),
    HokHero(id: 'li_xin', name: 'Li Xin', lane: HokLane.clash, defaultPower: 4200),
    HokHero(id: 'wuyan', name: 'Wuyan', lane: HokLane.clash, defaultPower: 3400),
    HokHero(id: 'yang_jian', name: 'Yang Jian', lane: HokLane.clash, defaultPower: 3700),

    // Jungle
    HokHero(id: 'butterfly', name: 'Butterfly', lane: HokLane.jungle, defaultPower: 4200),
    HokHero(id: 'dian_wei', name: 'Dian Wei', lane: HokLane.jungle, defaultPower: 3900),
    HokHero(id: 'han_xin', name: 'Han Xin', lane: HokLane.jungle, defaultPower: 4600),
    HokHero(id: 'jing', name: 'Jing', lane: HokLane.jungle, defaultPower: 4800),
    HokHero(id: 'lam', name: 'Lam', lane: HokLane.jungle, defaultPower: 4700),
    HokHero(id: 'li_bai', name: 'Li Bai', lane: HokLane.jungle, defaultPower: 4500),
    HokHero(id: 'liu_bei', name: 'Liu Bei', lane: HokLane.jungle, defaultPower: 4000),
    HokHero(id: 'luna', name: 'Luna', lane: HokLane.jungle, defaultPower: 5000),
    HokHero(id: 'musashi', name: 'Musashi', lane: HokLane.jungle, defaultPower: 4300),
    HokHero(id: 'nakoruru', name: 'Nakoruru', lane: HokLane.jungle, defaultPower: 4400),
    HokHero(id: 'pei_qinhu', name: 'Pei Qinhu', lane: HokLane.jungle, defaultPower: 4500),
    HokHero(id: 'lanling', name: 'Prince of Lanling', lane: HokLane.jungle, defaultPower: 4200),
    HokHero(id: 'wukong', name: 'Wukong', lane: HokLane.jungle, defaultPower: 4600),
    HokHero(id: 'zilong', name: 'Zilong', lane: HokLane.jungle, defaultPower: 4100),
    HokHero(id: 'sima_yi', name: 'Sima Yi', lane: HokLane.jungle, defaultPower: 4300),

    // Mid Lane
    HokHero(id: 'angela', name: 'Angela', lane: HokLane.mid, defaultPower: 4000),
    HokHero(id: 'daji', name: 'Daji', lane: HokLane.mid, defaultPower: 3800),
    HokHero(id: 'diaochan', name: 'Diaochan', lane: HokLane.mid, defaultPower: 4800),
    HokHero(id: 'dr_bian', name: 'Dr Bian', lane: HokLane.mid, defaultPower: 3700),
    HokHero(id: 'gan_mo', name: 'Gan & Mo', lane: HokLane.mid, defaultPower: 4500),
    HokHero(id: 'heino', name: 'Heino', lane: HokLane.mid, defaultPower: 4200),
    HokHero(id: 'lady_zhen', name: 'Lady Zhen', lane: HokLane.mid, defaultPower: 3900),
    HokHero(id: 'mai', name: 'Mai Shiranui', lane: HokLane.mid, defaultPower: 4700),
    HokHero(id: 'milady', name: 'Milady', lane: HokLane.mid, defaultPower: 3800),
    HokHero(id: 'mozi', name: 'Mozi', lane: HokLane.mid, defaultPower: 3600),
    HokHero(id: 'nuwa', name: 'Nuwa', lane: HokLane.mid, defaultPower: 4300),
    HokHero(id: 'frost', name: 'Princess Frost', lane: HokLane.mid, defaultPower: 4100),
    HokHero(id: 'shangguan', name: 'Shangguan', lane: HokLane.mid, defaultPower: 4900),
    HokHero(id: 'xiao_qiao', name: 'Xiao Qiao', lane: HokLane.mid, defaultPower: 4200),
    HokHero(id: 'yuhuan', name: 'Yang Yuhuan', lane: HokLane.mid, defaultPower: 4400),
    HokHero(id: 'zhou_yu', name: 'Zhou Yu', lane: HokLane.mid, defaultPower: 3900),
    HokHero(id: 'kongming', name: 'Kongming', lane: HokLane.mid, defaultPower: 4400),

    // Farm Lane
    HokHero(id: 'alessio', name: 'Alessio', lane: HokLane.farm, defaultPower: 4100),
    HokHero(id: 'arli', name: 'Arli', lane: HokLane.farm, defaultPower: 4800),
    HokHero(id: 'consort_yu', name: 'Consort Yu', lane: HokLane.farm, defaultPower: 4300),
    HokHero(id: 'di_renjie', name: 'Di Renjie', lane: HokLane.farm, defaultPower: 4200),
    HokHero(id: 'erin', name: 'Erin', lane: HokLane.farm, defaultPower: 3900),
    HokHero(id: 'fang', name: 'Fang', lane: HokLane.farm, defaultPower: 4000),
    HokHero(id: 'garo', name: 'Garo', lane: HokLane.farm, defaultPower: 4500),
    HokHero(id: 'hou_yi', name: 'Hou Yi', lane: HokLane.farm, defaultPower: 4200),
    HokHero(id: 'huang_zhong', name: 'Huang Zhong', lane: HokLane.farm, defaultPower: 4000),
    HokHero(id: 'lady_sun', name: 'Lady Sun', lane: HokLane.farm, defaultPower: 4600),
    HokHero(id: 'luban', name: 'Luban No.7', lane: HokLane.farm, defaultPower: 4400),
    HokHero(id: 'marco_polo', name: 'Marco Polo', lane: HokLane.farm, defaultPower: 4700),
    HokHero(id: 'shouyue', name: 'Shouyue', lane: HokLane.farm, defaultPower: 4500),

    // Roamer
    HokHero(id: 'da_qiao', name: 'Da Qiao', lane: HokLane.roam, defaultPower: 4600),
    HokHero(id: 'dolia', name: 'Dolia', lane: HokLane.roam, defaultPower: 4500),
    HokHero(id: 'donghuang', name: 'Donghuang', lane: HokLane.roam, defaultPower: 4100),
    HokHero(id: 'guiguzi', name: 'Guiguzi', lane: HokLane.roam, defaultPower: 4300),
    HokHero(id: 'kui', name: 'Kui', lane: HokLane.roam, defaultPower: 4000),
    HokHero(id: 'liu_shan', name: 'Liu Shan', lane: HokLane.roam, defaultPower: 3900),
    HokHero(id: 'ming', name: 'Ming', lane: HokLane.roam, defaultPower: 3800),
    HokHero(id: 'sun_bin', name: 'Sun Bin', lane: HokLane.roam, defaultPower: 4200),
    HokHero(id: 'taiyi', name: 'Taiyi Zhenren', lane: HokLane.roam, defaultPower: 4400),
    HokHero(id: 'yaria', name: 'Yaria', lane: HokLane.roam, defaultPower: 4200),
    HokHero(id: 'zhang_fei', name: 'Zhang Fei', lane: HokLane.roam, defaultPower: 4300),
    HokHero(id: 'zhuangzi', name: 'Zhuangzi', lane: HokLane.roam, defaultPower: 3900),
  ];
}

