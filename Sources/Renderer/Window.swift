import Cocoa
import Foundation
import Metal
import QuartzCore
import Utils

public struct Size {
    public var width: CGFloat?
    public var height: CGFloat?

    public init(_ width: CGFloat, _ height: CGFloat) {
        self.width = width
        self.height = height
    }
    public init() {
        self.width = nil
        self.height = nil
    }
}

@MainActor
public final class Window: @unchecked Sendable {
    public static let shared = Window()
    public var size = Size()
    public var layer: CAMetalLayer = CAMetalLayer()
    public var window: NSWindow = NSWindow()

    public var drawable: CAMetalDrawable {
        guard let drawable = layer.nextDrawable() else {
            Logger.error("Failed to create drawable for metal layer")
            exit(1)
        }
        return drawable
    }

    public func initialize() {
        guard let width = size.width, let height = size.height else {
            Logger.error("Window width and height must be set")
            exit(1)
        }
        Logger.info("Window width: \(width) height: \(height)")

        layer.device = Device.device
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
                defer: false,
                )
            window.makeKeyAndOrderFront(nil)
            window.contentView?.wantsLayer = true
            window.contentView?.layer?.addSublayer(layer)
            Logger.success("Created NSWindow")
        }
    }
    private init() {}
}
