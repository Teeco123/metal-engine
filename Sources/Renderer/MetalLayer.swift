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
public final class MetalLayer: @unchecked Sendable {
    static let shared = MetalLayer()
    public static var size = Size()
    var SLayer: CAMetalLayer
    var SWindow: NSWindow?

    var SDrawable: CAMetalDrawable {
        guard let drawable = SLayer.nextDrawable() else {
            Logger.error("Failed to create drawable for metal layer")
            exit(1)
        }
        return drawable
    }
    private init() {
        guard let width = Self.size.width, let height = Self.size.height else {
            Logger.error("Window width and height must be set")
            exit(1)
        }
        Logger.info("Window width: \(width) height: \(height)")

        let layer = CAMetalLayer()
        layer.device = Device.device
        layer.pixelFormat = .bgra8Unorm
        layer.framebufferOnly = true
        layer.contentsScale = 2.0
        layer.drawableSize = CGSize(width: width, height: height)
        layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        SLayer = layer
        Logger.success("Created metal layer")

        DispatchQueue.main.async {
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: width, height: height),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false,
                )
            window.makeKeyAndOrderFront(nil)
            window.contentView?.wantsLayer = true
            window.contentView?.layer?.addSublayer(layer)
            self.SWindow = window
            Logger.success("Created NSWindow")
        }
    }

    public static var layer: CAMetalLayer { shared.SLayer }
    public static var drawable: CAMetalDrawable { shared.SDrawable }
    public static var window: NSWindow? { shared.SWindow }
}
