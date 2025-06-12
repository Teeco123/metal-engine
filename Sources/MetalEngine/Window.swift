import Cocoa
import Foundation
import Metal
import QuartzCore

/// A 2D size object that stores optional width and height values.
public struct Size {
    /// The width component of the size.
    public var width: CGFloat?

    /// The height component of the size.
    public var height: CGFloat?

    /// Initializes a `Size` with the given width and height.
    ///
    /// - Parameters:
    ///   - width: The width value.
    ///   - height: The height value.
    public init(_ width: CGFloat, _ height: CGFloat) {
        self.width = width
        self.height = height
    }

    /// Initializes a `Size` with no values set.
    public init() {
        self.width = nil
        self.height = nil
    }
}

/// A singleton class that manages the application window and its Metal rendering layer.
///
/// This class is marked `@MainActor` to ensure all UI operations are performed on the main thread.
@MainActor
public final class Window: @unchecked Sendable {
    /// The shared singleton instance of `Window`.
    public static let shared = Window()

    /// The logical size of the window.
    public var size: Size

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
            Logger.success("Created NSWindow")
        }
    }
}
