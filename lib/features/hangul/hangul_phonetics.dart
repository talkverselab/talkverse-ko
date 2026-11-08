/// 한글 자모 발음 자료 — 일본어앱 kana_phonetics 와 같은 짜임(2026-11-08, 공통 프롬프터 §5-3).
/// 비교 대상 = 학습자 언어(영어). 설명은 콘텐츠라 번역하지 않는다(CLAUDE.md §5).
/// 조음 위치 그림·모음표 = assets/images/ipa/ 임시 그림(출시 전 Grok 그림으로 교체, 사용자 지시 2026-11-08 — 출처 표기 없음).
class Jamo {
  final String ch; // 자모
  final String name; // 이름(기역…)
  final String rr; // 개정 로마자(초성/종성 다르면 g/k)
  final String ipa; // [k ~ g]
  final String place; // 조음 위치·방식
  final String eng; // 영어와 비교
  final String sample; // 소리 낼 음절(가·아·각)
  final String kind; // plain|aspirated|tense|vowel|compound|batchim
  const Jamo(this.ch, this.name, this.rr, this.ipa, this.place, this.eng, this.sample, this.kind);
}

const consonants = <Jamo>[
  Jamo('ㄱ', '기역', 'g / k', 'k ~ ɡ', 'Velar stop — back of the tongue touches the soft palate.', 'Between English g and k. Unaspirated: like the k in "skin", voiced to g between vowels (아기 = agi).', '가', 'plain'),
  Jamo('ㄴ', '니은', 'n', 'n', 'Alveolar nasal — tongue tip on the ridge behind the upper teeth.', 'Same as English n.', '나', 'plain'),
  Jamo('ㄷ', '디귿', 'd / t', 't ~ d', 'Alveolar stop — tongue tip on the gum ridge.', 'Between d and t, like the t in "stop". Becomes d between vowels.', '다', 'plain'),
  Jamo('ㄹ', '리을', 'r / l', 'ɾ ~ l', 'Alveolar flap between vowels, lateral l at the end of a syllable.', 'Between vowels a quick tap like the tt in American "butter"; at the end like l in "ball" (with the tongue tip up).', '라', 'plain'),
  Jamo('ㅁ', '미음', 'm', 'm', 'Bilabial nasal — lips closed, air through the nose.', 'Same as English m.', '마', 'plain'),
  Jamo('ㅂ', '비읍', 'b / p', 'p ~ b', 'Bilabial stop — both lips.', 'Between b and p, like the p in "spin". Becomes b between vowels.', '바', 'plain'),
  Jamo('ㅅ', '시옷', 's', 's ~ ɕ', 'Alveolar fricative; before ㅣ/ㅑ/ㅕ/ㅛ/ㅠ it becomes "sh"-like [ɕ].', 'A soft, slightly breathy s. 시 sounds close to English "she".', '사', 'plain'),
  Jamo('ㅇ', '이응', '— / ng', '∅ / ŋ', 'Silent at the start of a syllable; velar nasal at the end.', 'At the start it is a placeholder (아 = a). At the end like ng in "sing".', '아', 'plain'),
  Jamo('ㅈ', '지읒', 'j', 't͡ɕ ~ d͡ʑ', 'Alveolo-palatal affricate — tongue blade near the hard palate.', 'Between j in "jam" and ch in "chip", without a puff of air.', '자', 'plain'),
  Jamo('ㅎ', '히읗', 'h', 'h', 'Glottal fricative — breath from the throat.', 'Like English h; often very weak between vowels.', '하', 'plain'),
  Jamo('ㅋ', '키읔', 'k', 'kʰ', 'Velar stop, strongly aspirated.', 'Like k in "kite" with a clear puff of air.', '카', 'aspirated'),
  Jamo('ㅌ', '티읕', 't', 'tʰ', 'Alveolar stop, strongly aspirated.', 'Like t in "top" with a strong puff.', '타', 'aspirated'),
  Jamo('ㅍ', '피읖', 'p', 'pʰ', 'Bilabial stop, strongly aspirated.', 'Like p in "pin" with a strong puff.', '파', 'aspirated'),
  Jamo('ㅊ', '치읓', 'ch', 't͡ɕʰ', 'Alveolo-palatal affricate, aspirated.', 'Like ch in "cheese" with a puff of air.', '차', 'aspirated'),
  Jamo('ㄲ', '쌍기역', 'kk', 'k͈', 'Velar stop, tense — throat tightened, no puff.', 'No English equivalent: a tight k like in "sky", said with tense throat and a sharp start.', '까', 'tense'),
  Jamo('ㄸ', '쌍디귿', 'tt', 't͈', 'Alveolar stop, tense.', 'A tight t like in "stay", with a tense throat.', '따', 'tense'),
  Jamo('ㅃ', '쌍비읍', 'pp', 'p͈', 'Bilabial stop, tense.', 'A tight p like in "spy", with a tense throat.', '빠', 'tense'),
  Jamo('ㅆ', '쌍시옷', 'ss', 's͈', 'Alveolar fricative, tense.', 'A hard, hissing s as in "sea" said firmly.', '싸', 'tense'),
  Jamo('ㅉ', '쌍지읒', 'jj', 't͡ɕ͈', 'Alveolo-palatal affricate, tense.', 'A tight "j/ch" with no puff, like the "ts" in "pizza" moved back.', '짜', 'tense'),
];

const vowels = <Jamo>[
  Jamo('ㅏ', '아', 'a', 'a', 'Open central vowel, mouth wide open.', 'Like a in "father".', '아', 'vowel'),
  Jamo('ㅑ', '야', 'ya', 'ja', 'y-glide + ㅏ.', 'Like "ya" in "yacht".', '야', 'vowel'),
  Jamo('ㅓ', '어', 'eo', 'ʌ', 'Open-mid back unrounded vowel.', 'Like u in "cup" but with the jaw a little lower and further back.', '어', 'vowel'),
  Jamo('ㅕ', '여', 'yeo', 'jʌ', 'y-glide + ㅓ.', 'Like "yu" in "yummy".', '여', 'vowel'),
  Jamo('ㅗ', '오', 'o', 'o', 'Close-mid back rounded vowel, lips rounded.', 'Like o in "go" but pure — do not glide to u.', '오', 'vowel'),
  Jamo('ㅛ', '요', 'yo', 'jo', 'y-glide + ㅗ.', 'Like "yo" in "yoga" (pure o).', '요', 'vowel'),
  Jamo('ㅜ', '우', 'u', 'u', 'Close back rounded vowel.', 'Like oo in "food".', '우', 'vowel'),
  Jamo('ㅠ', '유', 'yu', 'ju', 'y-glide + ㅜ.', 'Like "you".', '유', 'vowel'),
  Jamo('ㅡ', '으', 'eu', 'ɯ', 'Close back unrounded vowel — lips spread, tongue high and back.', 'No English equivalent: say oo in "food" but with lips spread flat, like a grimace.', '으', 'vowel'),
  Jamo('ㅣ', '이', 'i', 'i', 'Close front unrounded vowel.', 'Like ee in "see" (short).', '이', 'vowel'),
  Jamo('ㅐ', '애', 'ae', 'ɛ', 'Open-mid front vowel. Most speakers merge it with ㅔ.', 'Like e in "bed".', '애', 'compound'),
  Jamo('ㅒ', '얘', 'yae', 'jɛ', 'y-glide + ㅐ.', 'Like "ye" in "yes".', '얘', 'compound'),
  Jamo('ㅔ', '에', 'e', 'e', 'Close-mid front vowel — in everyday speech the same as ㅐ.', 'Like e in "bed" / "met".', '에', 'compound'),
  Jamo('ㅖ', '예', 'ye', 'je', 'y-glide + ㅔ.', 'Like "ye" in "yet".', '예', 'compound'),
  Jamo('ㅘ', '와', 'wa', 'wa', 'w-glide + ㅏ.', 'Like "wa" in "wander".', '와', 'compound'),
  Jamo('ㅙ', '왜', 'wae', 'wɛ', 'w-glide + ㅐ.', 'Like "we" in "wet".', '왜', 'compound'),
  Jamo('ㅚ', '외', 'oe', 'we', 'Originally a front rounded vowel; today pronounced like ㅞ.', 'Like "we" in "wet".', '외', 'compound'),
  Jamo('ㅝ', '워', 'wo', 'wʌ', 'w-glide + ㅓ.', 'Like "wo" in "won".', '워', 'compound'),
  Jamo('ㅞ', '웨', 'we', 'we', 'w-glide + ㅔ.', 'Like "we" in "wet".', '웨', 'compound'),
  Jamo('ㅟ', '위', 'wi', 'wi', 'w-glide + ㅣ.', 'Like "wee".', '위', 'compound'),
  Jamo('ㅢ', '의', 'ui', 'ɰi', 'ㅡ gliding to ㅣ; often just ㅣ in speech.', 'Say ㅡ (flat-lip oo) quickly sliding into ee.', '의', 'compound'),
];

/// 받침 7대표음 — 받침은 끝에서 터뜨리지 않는다(미파).
const batchim = <Jamo>[
  Jamo('ㄱ', 'ㄱ ㅋ ㄲ', 'k', 'k̚', 'Velar stop, not released — tongue stays on the soft palate.', 'Like the k in "back" without letting the air out.', '각', 'batchim'),
  Jamo('ㄴ', 'ㄴ', 'n', 'n', 'Alveolar nasal.', 'Like n in "can".', '간', 'batchim'),
  Jamo('ㄷ', 'ㄷ ㅌ ㅅ ㅆ ㅈ ㅊ ㅎ', 't', 't̚', 'Alveolar stop, not released. Seven letters end in this one sound.', 'Like t in "cat" held without release.', '갇', 'batchim'),
  Jamo('ㄹ', 'ㄹ', 'l', 'l', 'Lateral — tongue tip stays on the gum ridge.', 'Like l in "ball" with the tongue tip up.', '갈', 'batchim'),
  Jamo('ㅁ', 'ㅁ', 'm', 'm', 'Bilabial nasal.', 'Like m in "jam".', '감', 'batchim'),
  Jamo('ㅂ', 'ㅂ ㅍ', 'p', 'p̚', 'Bilabial stop, not released — lips stay closed.', 'Like p in "cup" with closed lips at the end.', '갑', 'batchim'),
  Jamo('ㅇ', 'ㅇ', 'ng', 'ŋ', 'Velar nasal.', 'Like ng in "sing".', '강', 'batchim'),
];

/// 모음표 비교 좌표 (x 0=전설 → 1=후설, y 0=고 → 1=저) — 한국어 모음 1개 vs 영어 이웃 모음.
class VowelPoint {
  final double x, y;
  final String ipa, label;
  const VowelPoint(this.x, this.y, this.ipa, this.label);
}

class VowelChartData {
  final VowelPoint ko;
  final List<VowelPoint> eng;
  final String note;
  const VowelChartData(this.ko, this.eng, this.note);
}

const vowelCharts = <String, VowelChartData>{
  'ㅏ': VowelChartData(VowelPoint(0.5, 1.0, 'a', 'ㅏ'), [VowelPoint(0.97, 0.97, 'ɑ', 'father'), VowelPoint(0.1, 0.82, 'æ', 'cat')], 'ㅏ sits low in the middle — between "father" and "cat".'),
  'ㅓ': VowelChartData(VowelPoint(0.9, 0.62, 'ʌ', 'ㅓ'), [VowelPoint(0.72, 0.6, 'ʌ', 'cup'), VowelPoint(1.0, 0.58, 'ɔː', 'thought')], 'ㅓ is further back than the u in "cup", with lips unrounded (not "thought").'),
  'ㅗ': VowelChartData(VowelPoint(1.0, 0.35, 'o', 'ㅗ'), [VowelPoint(1.0, 0.33, 'oʊ', 'go'), VowelPoint(1.0, 0.58, 'ɔː', 'thought')], 'ㅗ is the start of "go" without the glide to u — keep lips rounded and still.'),
  'ㅜ': VowelChartData(VowelPoint(1.0, 0.02, 'u', 'ㅜ'), [VowelPoint(1.0, 0.0, 'uː', 'food'), VowelPoint(0.84, 0.18, 'ʊ', 'book')], 'ㅜ ≈ "food", shorter.'),
  'ㅡ': VowelChartData(VowelPoint(0.85, 0.05, 'ɯ', 'ㅡ'), [VowelPoint(1.0, 0.0, 'uː', 'food'), VowelPoint(0.84, 0.18, 'ʊ', 'book')], 'ㅡ is in the same place as "food" but with lips spread, not rounded.'),
  'ㅣ': VowelChartData(VowelPoint(0.02, 0.02, 'i', 'ㅣ'), [VowelPoint(0.0, 0.0, 'iː', 'see'), VowelPoint(0.16, 0.16, 'ɪ', 'sit')], 'ㅣ ≈ "see", short; higher than "sit".'),
  'ㅐ': VowelChartData(VowelPoint(0.1, 0.5, 'ɛ', 'ㅐ'), [VowelPoint(0.1, 0.5, 'ɛ', 'bed'), VowelPoint(0.1, 0.82, 'æ', 'cat')], 'ㅐ ≈ "bed" — not as low as "cat".'),
  'ㅔ': VowelChartData(VowelPoint(0.08, 0.42, 'e', 'ㅔ'), [VowelPoint(0.1, 0.5, 'ɛ', 'bed'), VowelPoint(0.05, 0.33, 'e', 'gate')], 'ㅔ ≈ "bed"; in Seoul speech ㅐ and ㅔ sound the same.'),
};

const romanPlainSyllable = {'ㄱ': 'g', 'ㄴ': 'n', 'ㄷ': 'd', 'ㄹ': 'r', 'ㅁ': 'm', 'ㅂ': 'b', 'ㅅ': 's', 'ㅇ': '', 'ㅈ': 'j', 'ㅎ': 'h', 'ㅋ': 'k', 'ㅌ': 't', 'ㅍ': 'p', 'ㅊ': 'ch'};
const romanVowel = {'ㅏ': 'a', 'ㅑ': 'ya', 'ㅓ': 'eo', 'ㅕ': 'yeo', 'ㅗ': 'o', 'ㅛ': 'yo', 'ㅜ': 'u', 'ㅠ': 'yu', 'ㅡ': 'eu', 'ㅣ': 'i'};

/// 초성 + 중성 → 음절(유니코드 조합).
String compose(String cho, String jung) {
  const choList = 'ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ';
  const jungList = 'ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ';
  final c = choList.indexOf(cho), j = jungList.indexOf(jung);
  if (c < 0 || j < 0) return '';
  return String.fromCharCode(0xAC00 + (c * 21 + j) * 28);
}
