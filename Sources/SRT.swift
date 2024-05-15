import Foundation

public struct SRT: Hashable {
    public let cues: [Cue]

    public init(cues: [Cue]) {
        self.cues = cues
    }
}

extension SRT {
    public struct Cue: Hashable {
        public let counter: Int
        public let metadata: CueMetadata
        public let text: String

        public init(counter: Int, metadata: CueMetadata, text: String) {
            self.counter = counter
            self.metadata = metadata
            self.text = text
        }
    }

    public struct CueMetadata: Hashable {
        public let timing: Timing
        public let position: Position?

        public init(timing: Timing, position: Position?) {
            self.timing = timing
            self.position = position
        }
    }

    public struct Timing: Hashable {
        public let start: Time
        public let end: Time

        public init(start: Time, end: Time) {
            self.start = start
            self.end = end
        }
    }

    public struct Time: Hashable {
        public let hours: Int
        public let minutes: Int
        public let seconds: Int
        public let milliseconds: Int

        public var interval: TimeInterval {
            let sec = TimeInterval(seconds)
            let min = TimeInterval(minutes * 60)
            let hr = TimeInterval(hours * 3600)
            let ms = TimeInterval(milliseconds) / 1000

            return hr + min + sec + ms
        }

        public init(hours: Int, minutes: Int, seconds: Int, milliseconds: Int) {
            self.hours = hours
            self.minutes = minutes
            self.seconds = seconds
            self.milliseconds = milliseconds
        }
    }

    public struct Position: Hashable {
        public let x1: Int
        public let x2: Int
        public let y1: Int
        public let y2: Int

        public init(x1: Int, x2: Int, y1: Int, y2: Int) {
            self.x1 = x1
            self.x2 = x2
            self.y1 = y1
            self.y2 = y2
        }
    }

    public enum Color: Hashable {
        public struct RGB: Hashable {
            public let red: UInt8
            public let green: UInt8
            public let blue: UInt8

            public init(red: UInt8, green: UInt8, blue: UInt8) {
                self.red = red
                self.green = green
                self.blue = blue
            }
        }

        case named(String)
        case rgb(RGB)
    }
}
