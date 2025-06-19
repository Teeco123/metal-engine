import AppKit
import Foundation
import Metal
import QuartzCore

private final class ViewController: NSViewController {
    override func viewDidLoad() {
        let engine = MetalEngine.shared
        engine.displayLinkDelegate = DisplayLinkDelegate()
        engine.displayLink = CAMetalDisplayLink(metalLayer: Window.shared.layer)
        engine.displayLink?.delegate = engine.displayLinkDelegate
        engine.displayLink?.add(to: .main, forMode: .default)
    }

}

private final class WindowDelegate: NSObject, NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
    }

    func windowWillResize(
        _ sender: NSWindow,
        to frameSize: NSSize
    ) -> NSSize {
        return sender.frame.size
    }
}

public final class Window: @unchecked Sendable {
    public static let shared = Window()
    private let delegate = WindowDelegate()
    private var viewController: ViewController?

    public var size: Size = Size()
    public var windowColor: WindowColor = WindowColor()
    public var title: String?
    var layer: CAMetalLayer = CAMetalLayer()
    var window: NSWindow?
    var drawable: CAMetalDrawable {
        guard let drawable = layer.nextDrawable() else {
            Logger.error("Failed to create drawable for metal layer")
            exit(1)
        }
        return drawable
    }

    @MainActor
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
        layer.displaySyncEnabled = true
        layer.drawableSize = CGSize(width: width, height: height)
        layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        Logger.success("Created metal layer")

        viewController = ViewController()
        guard let viewController = viewController else {
            Logger.error("View controller not initialized")
            exit(1)
        }
        viewController.view.wantsLayer = true
        viewController.view.layer?.addSublayer(layer)
        viewController.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        Logger.success("Created view controller")

        window = NSWindow(contentViewController: viewController)
        guard let window = window else {
            Logger.error("Window not initialized")
            exit(1)
        }
        window.delegate = delegate
        window.makeKeyAndOrderFront(nil)
        window.title = title
        Logger.success("Created window")
    }
}
