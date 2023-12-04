# detectable_text_field

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-11-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

[![pub package](https://img.shields.io/pub/v/detectable_text_field.svg)](https://pub.dev/packages/detectable_text_field) <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>

Text widgets with detection features. You can detect hashtags, at sign, url, or anything you want.
Helps you develop Twitter like app.

Refinement of [hashtagable](https://pub.dev/packages/hashtagable).

![final](https://user-images.githubusercontent.com/43510799/104180838-2385fd80-5451-11eb-8506-1640b4ea829f.gif)

## Usage

### DetectableTextField

```dart
    DetectableTextField(
      detectionRegExp: detectionRegExp(),
      detectedStyle: TextStyle(
        fontSize: 20,
        color: Colors.blue,
      ),
    )
```

- `detectionRegExp` decides the text to detect.
- `detectedStyle` is the textStyle for detected text.

### DetectableTextEditingController

DetectableTextEditingController allows you to listen to the `typingDetection`. Ideal for features
like live hashtag or mention detection.

```dart

    final controller = DetectableTextEditingController(
      regExp: detectionRegExp(),
    );
    
    @override
    void initState() {
      super.initState();
      controller.addListener(() {
        setState(() {});
      });
    }
    
    @override
    Widget build(BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Typing detection: ${controller.typingDetection}',
          ),
          DetectableTextField(
            controller: controller,
          ),
        ],
      );
    }
```

`DetectableTextEditingController` extends `TextEditingController`, so you can use it
with `TextField`, `TextFormField` or any other widgets that accept `TextEditingController`.

If you use flutter_hooks, `useDetectableTextEditingController` is also available.




### DetectableText

If you want to use detection feature in the text only to display, use `DetectableText`.

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

### `detectionRegExp()`

The widgets and methods in this package is expected to be used with RegExp.

The function `detectionRegExp()` returns sample regExp depending on the boolean arguments: `hashtag`
, `atSign`, and `url`.They are all true by default.

If you see
the [API reference](https://pub.dev/documentation/detectable_text_field/latest/detector_sample_regular_expressions/detectionRegExp.html)
, you will see the function just returns the sample regular expressions below. You can use them
directly if you want.

| sample regExp | hashtag | atSign | url |
| --- | --- | --- | ---- |
| `hashTagRegExp` |○|×|×|
| `atSignRegExp`|×|○|×|
| `urlRegExp`|×|×|○|
| `hashTagAtSignRegExp`|○|○|×|
| `hashTagUrlRegExp`|○|×|○|
| `AtSignUrlRegExp`|×|○|○|
| `hashTagAtSignUrlRegExp`|○|○|○|

- The detection rules are almost same as X(formally twitter).
    1. It needs space before `#` or `@`.
    2. It stops `#` and `@` detection if there's emoji or symbol.

<img src ="https://user-images.githubusercontent.com/43510799/93002102-3655f780-f56f-11ea-8193-1753a69e23bc.jpg" width = "265"/>

- The examples currently support six languages: English, Japanese, Korean, Spanish, Arabic, and
  Thai.

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

  final List<String> detections = extractDetections(
    "#Hello World #Flutter Dart #Thank you", 
    hashTagRegExp,
  );
  // ["#Hello", "#Flutter", "#Thank"]

```

If you have any requests or questions, please feel free to ask
on [github](https://github.com/santa112358/detectable_text_field/issues).

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/santa112358"><img src="https://avatars.githubusercontent.com/u/43510799?v=4?s=100" width="100px;" alt="Santa Takahashi"/><br /><sub><b>Santa Takahashi</b></sub></a><br /><a href="https://github.com/santa112358/detectable_text_field/commits?author=santa112358" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.facebook.com/Paresh.07.OCT"><img src="https://avatars.githubusercontent.com/u/10085177?v=4?s=100" width="100px;" alt="Paresh Patil"/><br /><sub><b>Paresh Patil</b></sub></a><br /><a href="https://github.com/santa112358/detectable_text_field/commits?author=Pareshoct7" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/jtmuller5"><img src="https://avatars.githubusercontent.com/u/47997351?v=4?s=100" width="100px;" alt="Joseph Muller"/><br /><sub><b>Joseph Muller</b></sub></a><br /><a href="https://github.com/santa112358/detectable_text_field/commits?author=jtmuller5" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/EsteveAguilera"><img src="https://avatars.githubusercontent.com/u/6932449?v=4?s=100" width="100px;" alt="Esteve Aguilera"/><br /><sub><b>Esteve Aguilera</b></sub></a><br /><a href="https://github.com/santa112358/detectable_text_field/commits?author=EsteveAguilera" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/MATTYGILO"><img src="https://avatars.githubusercontent.com/u/34808802?v=4?s=100" width="100px;" alt="MATTYGILO"/><br /><sub><b>MATTYGILO</b></sub></a><br /><a href="https://github.com/santa112358/detectable_text_field/commits?author=MATTYGILO" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://add00w.github.io"><img src="https://avatars.githubusercontent.com/u/35359329?v=4?s=100" width="100px;" alt="Abdullahi A. Addow"/><br /><sub><b>Abdullahi A. Addow</b></sub></a><br /><a href="https://github.com/santa112358/detectable_text_field/commits?author=Add00w" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/rlee1990"><img src="https://avatars.githubusercontent.com/u/21372502?v=4?s=100" width="100px;" alt="Social Jawn"/><br /><sub><b>Social Jawn</b></sub></a><br /><a href="https://github.com/santa112358/detectable_text_field/commits?author=rlee1990" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/xuxiaowei13"><img src="https://avatars.githubusercontent.com/u/10124443?v=4?s=100" width="100px;" alt="xuxiaowei13"/><br /><sub><b>xuxiaowei13</b></sub></a><br /><a href="https://github.com/santa112358/detectable_text_field/commits?author=xuxiaowei13" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.debuggerx.com"><img src="https://avatars.githubusercontent.com/u/19624835?v=4?s=100" width="100px;" alt="debuggerx01"/><br /><sub><b>debuggerx01</b></sub></a><br /><a href="https://github.com/santa112358/detectable_text_field/commits?author=debuggerx01" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/furukaze-akane"><img src="https://avatars.githubusercontent.com/u/87937371?v=4?s=100" width="100px;" alt="furukaze-akane"/><br /><sub><b>furukaze-akane</b></sub></a><br /><a href="https://github.com/santa112358/detectable_text_field/commits?author=furukaze-akane" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/drown0315"><img src="https://avatars.githubusercontent.com/u/108989782?v=4?s=100" width="100px;" alt="drown0315"/><br /><sub><b>drown0315</b></sub></a><br /><a href="https://github.com/santa112358/detectable_text_field/commits?author=drown0315" title="Code">💻</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors)
specification. Contributions of any kind welcome!