# detectable_text_field

Text widgets with detection feature. You can detect hashtags, at sign, or anything you want.

This is refinement of [hastagable](https://pub.dev/packages/hashtagable)

## Usage

#### As TextField

```dart
    DetectableTextField(
      detectionRegExp: hashTagRegExp,
      detectedStyle: TextStyle(
        fontSize: 20,
        color: Colors.blue,
      ),
      basicStyle: TextStyle(
        fontSize: 20,
      ),
    )
```
`detectionRegExp` decides the text to detect. `detectedStyle` is the textStyle for detected text. basicStyle is the textStyle for not detected text.

Other arguments are basically same as material TextField.

#### As ReadOnlyText

If you want to use detection feature in the text only to display, `DetectableText` will help you.

```dart
    DetectableText(
      text: "#HashTag and @AtSign",
      detectionRegExp: hashTagAtSignRegExp,
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

#### Sample RegExp

The widgets and methods in this package is expected to be used with RegExp. You can pick regExp from examples set in the package.

| sample regExp | detection target |
| --- | --- |
| `hashTagRegExp` | Words start with hashtag |
| `atSignRegExp`| Words start with at sign |
| `hashTagAtSignRegExp`| Words start with hashtag or at sign |

- The detection rules are almost same as twitter.
   1. It needs space before `#` or `@`.
   2. It stops detection if there's emoji or symbol.

- The examples currently support six languages: English, Japanese, Korean, Spanish, Arabic, and Thai.

#### Customize with useful functions

- Check if there are detections

```dart
   print(isDetected("Hello #World", hashTagRegExp));
   // true

   print(isDetected("Hello World", hasgTagRegExp));
   // false

```
- Extract detections from text

```dart
   final List<String> detections = extractDetections("#Hello World #Flutter Dart #Thank you", hashTagRegExp);
   // ["#Hello", "#Flutter", "#Thank"]

```
