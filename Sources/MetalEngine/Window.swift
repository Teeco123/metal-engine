import AppKit
import Foundation
import Metal
import QuartzCore

private final class WindowDelegate: NSObject, NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        NSApplication.shared.terminate(nil)
    }
}

@MainActor
public final class Window {
    public static let shared = Window()
    private let delegate = WindowDelegate()

    public var size: Size = Size()
    public var windowColor: WindowColor = WindowColor()
    public var title: String?
    var layer: CAMetalLayer = CAMetalLayer()
    var window: NSWindow = NSWindow()
    var drawable: CAMetalDrawable {
        guard let drawable = layer.nextDrawable() else {
            Logger.error("Failed to create drawable for metal layer")
            exit(1)
        }
        return drawable
    }

    func initialize() {
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

        Task {
            window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: width, height: height),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )
            window.delegate = delegate
            window.makeKeyAndOrderFront(nil)
            window.contentView?.wantsLayer = true
            window.contentView?.layer?.addSublayer(layer)
            window.title = title
            Logger.success("Created NSWindow")
        }
    }
}
