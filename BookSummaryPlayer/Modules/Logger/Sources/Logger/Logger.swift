import Foundation

public class Log {
    
    public static func debug(_ message: @autoclosure () -> String, _ file: String = #file, _ line: UInt32 = #line) {
        #if DEBUG
        let message = message()
        print(format("🐛 [DEBUG]", message, file, line))
        #endif
    }
    
    public static func info(_ message: @autoclosure () -> String, _ file: String = #file, _ line: UInt32 = #line) {
        let message = message()
        let line = format("ℹ️ [INFO]", message, file, line)
        print(line)
    }

    public static func error(_ message: @autoclosure () -> String, _ file: String = #file, _ line: UInt32 = #line) {
        let message = message()
        let line = format("🔥 [ERROR]", message, file, line)
        print(line)
    }
    
    public static func error(_ error: Error) {
        print("🔥 [ERROR] \(error.localizedDescription)")
    }
    
    private static func format(_ symbol: String, _ message: String, _ file: String, _ line: UInt32) -> String {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        return "\(symbol) [\(fileName):\(line)] \(message)"
    }
}
