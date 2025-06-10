import Cocoa
import Foundation
import Metal
import QuartzCore
import Utils

public final class MetalLayer: @unchecked Sendable {
    static let shared = MetalLayer()
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
        let layer = CAMetalLayer()
        layer.device = Device.device
        layer.pixelFormat = .bgra8Unorm
        layer.framebufferOnly = true
        layer.contentsScale = 2.0
        layer.drawableSize = CGSize(width: 100, height: 100)
        layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        SLayer = layer
        Logger.success("Created metal layer")

        DispatchQueue.main.async {
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 100, height: 100),
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
