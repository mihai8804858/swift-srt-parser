
# SRTParser

Swift package to parse SubRip Text (SRT) subtitles.

[![CI](https://github.com/mihai8804858/swift-srt-parser/actions/workflows/ci.yml/badge.svg)](https://github.com/mihai8804858/swift-srt-parser/actions/workflows/ci.yml)


## Installation

You can add `swift-srt-parser` to an Xcode project by adding it to your project as a package.

> https://github.com/mihai8804858/swift-srt-parser

If you want to use `swift-srt-parser` in a [SwiftPM](https://swift.org/package-manager/) project, it's as
simple as adding it to your `Package.swift`:

``` swift
dependencies: [
  .package(url: "https://github.com/mihai8804858/swift-srt-parser", from: "1.0.0")
]
```

And then adding the product to any target that needs access to the library:

```swift
.product(name: "SRTParser", package: "swift-srt-parser"),
```

## Quick Start

* Create an instance of `SRTParser`:
```swift
private let parser = SRTParser()
```
* Get the SRT contents:
```swift
let contents = ...
```
* Parse the contents into a structured model:
```swift
let srt = try parser.parse(contents)
```
* Print an `SRT` model back into raw contents:
```swift
let contents = try parser.print(srt)
```

## Example

### Parsing

```swift
let contents = """
1
00:02:17,440 --> 00:02:20,375
{\an8}Senator, we're making
our <b>final</b> approach into {u}Coruscant{/u}.

2
00:02:20,476 --> 00:02:22,501 X1:201 X2:516 Y1:397 Y2:423
{b}Very good, {i}Lieutenant{/i}{/b}.
"""

dump(try SRTParser().parse(contents))
```

```
▿ SRTParser.SRT
  ▿ cues: 6 elements
    ▿ SRTParser.SRT.Cue
      - counter: 1
      ▿ metadata: SRTParser.SRT.CueMetadata
        ▿ timing: SRTParser.SRT.Timing
          ▿ start: SRTParser.SRT.Time
            - hours: 0
            - minutes: 2
            - seconds: 17
            - milliseconds: 440
          ▿ end: SRTParser.SRT.Time
            - hours: 0
            - minutes: 2
            - seconds: 20
            - milliseconds: 375
        - coordinates: nil
        ▿ position: Optional(SRTParser.SRT.Position.topCenter)
          - some: SRTParser.SRT.Position.topCenter
      ▿ text: SRTParser.SRT.StyledText
        ▿ components: 5 elements
          ▿ SRTParser.SRT.StyledText.Component.plain
            ▿ plain: (1 element)
              - text: "Senator, we\'re making\nour "
          ▿ SRTParser.SRT.StyledText.Component.bold
            ▿ bold: (1 element)
              ▿ children: 1 element
                ▿ SRTParser.SRT.StyledText.Component.plain
                  ▿ plain: (1 element)
                    - text: "final"
          ▿ SRTParser.SRT.StyledText.Component.plain
            ▿ plain: (1 element)
              - text: " approach into "
          ▿ SRTParser.SRT.StyledText.Component.underline
            ▿ underline: (1 element)
              ▿ children: 1 element
                ▿ SRTParser.SRT.StyledText.Component.plain
                  ▿ plain: (1 element)
                    - text: "Coruscant"
          ▿ SRTParser.SRT.StyledText.Component.plain
            ▿ plain: (1 element)
              - text: "."
    ▿ SRTParser.SRT.Cue
      - counter: 2
      ▿ metadata: SRTParser.SRT.CueMetadata
        ▿ timing: SRTParser.SRT.Timing
          ▿ start: SRTParser.SRT.Time
            - hours: 0
            - minutes: 2
            - seconds: 20
            - milliseconds: 476
          ▿ end: SRTParser.SRT.Time
            - hours: 0
            - minutes: 2
            - seconds: 22
            - milliseconds: 501
        ▿ coordinates: Optional(SRTParser.SRT.Coordinates(x1: 201, x2: 516, y1: 397, y2: 423))
          ▿ some: SRTParser.SRT.Coordinates
            - x1: 201
            - x2: 516
            - y1: 397
            - y2: 423
        - position: nil
      ▿ text: SRTParser.SRT.StyledText
        ▿ components: 2 elements
          ▿ SRTParser.SRT.StyledText.Component.bold
            ▿ bold: (1 element)
              ▿ children: 2 elements
                ▿ SRTParser.SRT.StyledText.Component.plain
                  ▿ plain: (1 element)
                    - text: "Very good, "
                ▿ SRTParser.SRT.StyledText.Component.italic
                  ▿ italic: (1 element)
                    ▿ children: 1 element
                      ▿ SRTParser.SRT.StyledText.Component.plain
                        ▿ plain: (1 element)
                          - text: "Lieutenant"
          ▿ SRTParser.SRT.StyledText.Component.plain
            ▿ plain: (1 element)
              - text: "."
```

### Printing

```swift
let srt = SRT(cues: [
  SRT.Cue(
    counter: 1,
    metadata: SRT.CueMetadata(
      timing: SRT.Timing(
        start: SRT.Time(hours: 0, minutes: 2, seconds: 17, milliseconds: 440),
        end: SRT.Time(hours: 0, minutes: 2, seconds: 20, milliseconds: 375)
      ),
      coordinates: SRT.Coordinates(x1: 201, x2: 516, y1: 397, y2: 423),
      position: nil
    ),
    text: SRT.StyledText(components: [
      .plain(text: "Senator, we're making\nour "),
      .bold(children: [.plain(text: "final")]),
      .plain(text: " approach into "),
      .underline(children: [.plain(text: "Coruscant")]),
      .plain(text: ".")
    ])
  ),
  SRT.Cue(
    counter: 2,
    metadata: SRT.CueMetadata(
      timing: SRT.Timing(
        start: SRT.Time(hours: 0, minutes: 2, seconds: 20, milliseconds: 476),
        end: SRT.Time(hours: 0, minutes: 2, seconds: 22, milliseconds: 501)
      ),
      coordinates: nil,
      position: .bottomCenter
    ),
    text: SRT.StyledText(components: [
      .bold(children: [
        .plain(text: "Very good, "),
        .italic(children: [.plain(text: "Lieutenant")])
      ]),
      .plain(text: ".")
    ])
  )
])

print(try SRTParser().print(srt))
```

```
1
00:02:17,440 --> 00:02:20,375 X1:201 X2:516 Y1:397 Y2:423
Senator, we're making
our <b>final</b> approach into <u>Coruscant</u>.

2
00:02:20,476 --> 00:02:22,501
{\an2}<b>Very good, <i>Lieutenant</i></b>.
```

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
