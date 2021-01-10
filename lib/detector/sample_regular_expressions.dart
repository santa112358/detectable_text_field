/// Sample Regular expressions to set the argument detectionRegExp
///
/// Supports English, Japanese, Korean, Spanish, Arabic, and Thai

const _symbols = '·・ー_';

const _numbers = '0-9０-９';

const _englishLetters = 'a-zA-Zａ-ｚＡ-Ｚ';

const _japaneseLetters = 'ぁ-んァ-ン一-龠';

const _koreanLetters = '\u1100-\u11FF\uAC00-\uD7A3';

const _spanishLetters = 'áàãâéêíóôõúüçÁÀÃÂÉÊÍÓÔÕÚÜÇ';

const _arabicLetters = '\u0621-\u064A';

const _thaiLetters = '\u0E00-\u0E7F';

const detectionContentLetters = _symbols +
    _numbers +
    _englishLetters +
    _japaneseLetters +
    _koreanLetters +
    _spanishLetters +
    _arabicLetters +
    _thaiLetters;

const urlRegexContent = "((http|https)://)(www.)?" +
    "[a-zA-Z0-9@:%._\\+~#?&//=]" +
    "{2,256}\\.[a-z]" +
    "{2,6}\\b([-a-zA-Z0-9@:%" +
    "._\\+~#?&//=]*)";

/// Regular expression to extract hashtag
///
/// Supports English, Japanese, Korean, Spanish, Arabic, and Thai
final hashTagRegExp = RegExp(
  "(?!\\n)(?:^|\\s)(#([$detectionContentLetters]+))",
  multiLine: true,
);

final atSignRegExp = RegExp(
  "(?!\\n)(?:^|\\s)([@]([$detectionContentLetters]+))",
  multiLine: true,
);

final urlRegex = RegExp(
  urlRegexContent,
  multiLine: true,
);

/// Regular expression when you select decorateAtSign
final hashTagAtSignRegExp = RegExp(
  "(?!\\n)(?:^|\\s)([#@]([$detectionContentLetters]+))",
  multiLine: true,
);

final hashTagAtSignUrlRegExp = RegExp(
  "(?!\\n)(?:^|\\s)([#@]([$detectionContentLetters]+))|$urlRegexContent",
  multiLine: true,
);
