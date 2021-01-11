# detectable_text_field

[![pub package](https://img.shields.io/pub/v/detectable_text_field.svg)](https://pub.dev/packages/detectable_text_field) <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>

Text widgets with detection feature. You can detect hashtags, at sign, url, or anything you want.

Refinement of [hashtagable](https://pub.dev/packages/hashtagable).

![final](https://user-images.githubusercontent.com/43510799/104180581-b4a8a480-5450-11eb-9309-65ce3f2e979c.gif)

## Usage

### As TextField

```dart
    DetectableTextField(
      detectionRegExp: detectionRegExp(),
      detectedStyle: TextStyle(
        fontSize: 20,
        color: Colors.blue,
      ),
      basicStyle: TextStyle(
        fontSize: 20,
      ),
    )
```
- `detectionRegExp` decides the text to detect. `detectedStyle` is the textStyle for detected text. basicStyle is the textStyle for not detected text.

- Other arguments are basically same as material TextField.

### As ReadOnlyText

If you want to use detection feature in the text only to display, `DetectableText` will help you.

```dart
    DetectableText(
      text: "#HashTag and @AtSign and https://pub.dev/packages/detectable_text_field",
      detectionRegExp: detectionRegExp(),
      detectedStyle: TextStyle(
        fontSize: 20,
        color: Colors.blue,
      ),
      basicStyle: TextStyle(
        fontSize: 20,
      ),
      onTap: (tappedText){
        print(tappedText);
      },
    )
```

Usage of the arguments like `detectionRegExp` are same as the ones in `DetectableTextField`.

The argument `onTap(String)` is called when user tapped a detected text.

You can add some actions in this callback with the tapped text.

### detectionRegExp()

The widgets and methods in this package is expected to be used with RegExp. The function `detectionRegExp()` returns sample regExp depending om the boolean arguments: `hashtag`, `atSign`, and `url`.
They are all `true` by default. If you do **NOT** want to detect atSign, you need to set the argument like this: `detectionRegExp(atSign:false)`. It is same for other arguments.

If you see the [API reference](https://pub.dev/documentation/detectable_text_field/latest/detector_sample_regular_expressions/detectionRegExp.html), you will see the function just returns the sample regular expressions below. You can use these regExp directly if you want.

| sample regExp | hashtag | atSign | url |
| --- | --- | --- | ---- |
| `hashTagRegExp` |○|×|×|
| `atSignRegExp`|×|○|×|
| `urlRegExp`|×|×|○|
| `hashTagAtSignRegExp`|○|○|×|
| `hashTagUrlRegExp`|○|×|○|
| `AtSignUrlRegExp`|×|○|○|
| `hashTagAtSignUrlRegExp`|○|○|○|


- The detection rules are almost same as twitter.
   1. It needs space before `#` or `@`.
   2. It stops `#` and `@` detection if there's emoji or symbol.


<img src ="https://user-images.githubusercontent.com/43510799/93002102-3655f780-f56f-11ea-8193-1753a69e23bc.jpg" width = "265"/>

- The examples currently support six languages: English, Japanese, Korean, Spanish, Arabic, and Thai.

### Customize with useful functions

- Check if there are detections

```dart
   print(isDetected("Hello #World", hashTagRegExp));
   // true

   print(isDetected("Hello World", hashTagRegExp));
   // false

```
- Extract detections from text

```dart
   final List<String> detections = extractDetections("#Hello World #Flutter Dart #Thank you", hashTagRegExp);
   // ["#Hello", "#Flutter", "#Thank"]

```

If you have any requests or questions, please feel free to ask on [github](https://github.com/santa112358/detectable_text_field/issues).
