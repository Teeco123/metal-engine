import Cocoa
import Foundation
import Metal
import QuartzCore

/// A singleton class that manages the application window and its Metal rendering layer.
///
/// This class is marked `@MainActor` to ensure all UI operations are performed on the main thread.
@MainActor
public final class Window: @unchecked Sendable {
    /// The shared singleton instance of `Window`.
    public static let shared = Window()

    /// The logical size of the window.
    public var size: Size
    public var windowColor: WindowColor
    public var title: String?

    /// The Metal layer used for rendering.
    public var layer: CAMetalLayer

    /// The underlying Cocoa window.
    public var window: NSWindow

    /// The current drawable from the Metal layer.
    ///
    /// - Important: If no drawable is available, the app will terminate with a fatal error.
    public var drawable: CAMetalDrawable {
        guard let drawable = layer.nextDrawable() else {
            Logger.error("Failed to create drawable for metal layer")
            exit(1)
        }
        return drawable
    }

    /// Initializes the `Window` singleton with default properties.
    ///
    /// This initializer is private to enforce the singleton pattern.
    private init() {
        size = Size()
        windowColor = WindowColor()
        title = nil
        layer = CAMetalLayer()
        window = NSWindow()
    }

    /// Initializes and displays the window with the configured size and Metal layer.
    ///
    /// - Note: This method must be called after setting a valid `size`.
    ///
    /// - Warning: If `size.width` or `size.height` is `nil`, the app will terminate.
    public func initialize() {
        guard let width = size.width, let height = size.height else {
            Logger.error("Window width and height must be set")
            exit(1)
        }
        Logger.info("Window width: \(width) height: \(height)")

        guard let title = title else {
            Logger.error("Window title must be set")
            exit(1)
        }
        Logger.info("Window title: \(title)")

        layer.device = Device.shared.device
        layer.pixelFormat = .bgra8Unorm
        layer.framebufferOnly = true
        layer.contentsScale = 2.0
        layer.drawableSize = CGSize(width: width, height: height)
        layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        Logger.success("Created metal layer")

        Task { @MainActor in
            window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: width, height: height),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )
            window.makeKeyAndOrderFront(nil)
            window.contentView?.wantsLayer = true
            window.contentView?.layer?.addSublayer(layer)
            window.title = title
            Logger.success("Created NSWindow")
        }
    }
}
