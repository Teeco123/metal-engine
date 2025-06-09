import Foundation

public enum LogLevel: String {
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    case success = "SUCCESS"
    case print = "DEBUG"

    public var colorCode: String {
        switch self {
        case .info: return "\u{001B}[0;34m"  // Blue
        case .warning: return "\u{001B}[0;33m"  // Yellow
        case .error: return "\u{001B}[0;31m"  // Red
        case .success: return "\u{001B}[0;32m"  // Green
        case .print: return "\u{001B}[0;36m"  // Cyan
        }
    }
}

public struct Logger {
    private static func log(_ message: String, level: LogLevel) {
        let timestamp = Logger.timestamp()
        let resetColor = "\u{001B}[0;0m"
        let coloredLevel = "\(level.colorCode)\(level.rawValue)\(resetColor)"

        Swift.print("[\(timestamp)] \(coloredLevel) → \(message)")
    }

    private static func timestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }

    // MARK: - Public Methods
    public static func info(_ message: String) {
        log(message, level: .info)
    }

    public static func warning(_ message: String) {
        log(message, level: .warning)
    }

    public static func error(_ message: String) {
        log(message, level: .error)
    }

    public static func success(_ message: String) {
        log(message, level: .success)
    }

    public static func print(_ message: String) {
        log(message, level: .print)
    }
}
