import AppKit
import Foundation
import Metal
import QuartzCore

@MainActor
public class MetalEngine {
    var displayLink: CADisplayLink?
    public var update: (() -> Void)?

    public init() {}

    public func initialize() {
        Logger.info("MetalEngine starting up...")
        Window.shared.initialize()
        let screen = NSScreen.main!
        let app = NSApplication.shared
        displayLink = screen.displayLink(target: self, selector: #selector(frameTick))
        guard let displayLink = displayLink else {
            Logger.error("Failed to create display link")
            exit(1)
        }
        displayLink.add(to: .main, forMode: .default)

        app.setActivationPolicy(.regular)
        app.activate(ignoringOtherApps: true)
        app.run()

        Logger.success("MetalEngine initialized successfully")
    }

    @objc func frameTick() {
        update?()
        draw()
    }

    func stop() {
        guard let displayLink = displayLink else {
            Logger.error("Display link not available for stopping")
            exit(1)
        }
        displayLink.invalidate()
        Logger.info("MetalEngine stopped")
    }

    func draw() {
        guard let drawable = Window.shared.layer.nextDrawable() else {
            Logger.warning("No drawable available, skipping frame")
            exit(1)
        }

        let windowColor = Window.shared.windowColor
        guard let red = windowColor.red,
              let green = windowColor.green,
              let blue = windowColor.blue
        else {
            Logger.error("Window color must be set")
            exit(1)
        }

        let passDescriptor = MTLRenderPassDescriptor()
        passDescriptor.colorAttachments[0].texture = drawable.texture
        passDescriptor.colorAttachments[0].loadAction = .clear
        passDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(red, green, blue, 1.0)
        passDescriptor.colorAttachments[0].storeAction = .store

        let commandBuffer = Device.shared.commandBuffer

        let renderCommandEncoder = Device.renderCommandEncoder(commandBuffer, passDescriptor)

        renderCommandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
