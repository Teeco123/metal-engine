import Foundation

/// Represents the level of a log message, determining its severity and display color.
public enum LogLevel: String {
    /// Informational messages.
    case info = "INFO"
    /// Warnings that do not stop the execution but might need attention.
    case warning = "WARNING"
    /// Errors indicating failure or critical issues.
    case error = "ERROR"
    /// Success messages indicating completed operations.
    case success = "SUCCESS"
    /// Debug or print-level messages for development.
    case print = "DEBUG"

    /// The ANSI escape color code associated with each log level for terminal output.
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

/// A simple logger utility that outputs colored and timestamped log messages to the console.
///
/// The logger supports different log levels such as info, warning, error, success, and debug (print).
/// Each message is prefixed with a timestamp and a color-coded level tag.
public struct Logger {

    /// Logs a message with the given log level, including a timestamp and color coding.
    /// - Parameters:
    ///   - message: The message to log.
    ///   - level: The level/severity of the log message.
    private static func log(_ message: String, level: LogLevel) {
        let timestamp = Logger.timestamp()
        let resetColor = "\u{001B}[0;0m"
        let coloredLevel = "\(level.colorCode)\(level.rawValue)\(resetColor)"

        Swift.print("[\(timestamp)] \(coloredLevel) → \(message)")
    }

    /// Generates the current timestamp string in "HH:mm:ss" format.
    /// - Returns: A string representing the current time.
    private static func timestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }

    // MARK: - Public Methods

    /// Logs an informational message.
    /// - Parameter message: The info message to log.
    public static func info(_ message: String) {
        log(message, level: .info)
    }

    /// Logs a warning message.
    /// - Parameter message: The warning message to log.
    public static func warning(_ message: String) {
        log(message, level: .warning)
    }

    /// Logs an error message.
    /// - Parameter message: The error message to log.
    public static func error(_ message: String) {
        log(message, level: .error)
    }

    /// Logs a success message.
    /// - Parameter message: The success message to log.
    public static func success(_ message: String) {
        log(message, level: .success)
    }

    /// Logs a debug or general print message.
    /// - Parameter message: The debug message to log.
    public static func print(_ message: String) {
        log(message, level: .print)
    }
}
