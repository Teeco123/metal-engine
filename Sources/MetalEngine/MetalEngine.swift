import AppKit
import Foundation
import Metal
import QuartzCore

class DisplayLinkDelegate: CAMetalDisplayLinkDelegate {
    func metalDisplayLink(_ link: CAMetalDisplayLink, needsUpdate update: CAMetalDisplayLink.Update) {
        MetalEngine.shared.update?()
        MetalEngine.shared.draw(drawable: update.drawable)
    }

}

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Window.shared.initialize()
        Logger.info("applicationDidFinishLaunching finished")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        MetalEngine.shared.stop()

    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}

public class MetalEngine: @unchecked Sendable {
    public static let shared = MetalEngine()
    public var update: (() -> Void)?
    var app: NSApplication?
    var appDelegate: AppDelegate?

    var displayLink: CAMetalDisplayLink?
    var displayLinkDelegate: CAMetalDisplayLinkDelegate?

    public init() {}

    @MainActor
    public func initialize() {
        Logger.info("MetalEngine starting up...")

        appDelegate = AppDelegate()
        app = NSApplication.shared
        guard let app = app else {
            Logger.error("NSApplication not initialized")
            exit(1)
        }

        app.delegate = appDelegate
        app.setActivationPolicy(.regular)
        app.activate(ignoringOtherApps: true)
        app.run()
    }

    func stop() {
        guard let displayLink = displayLink else {
            Logger.error("Display link not available for stopping")
            exit(1)
        }
        displayLink.invalidate()
        displayLink.remove(from: .main, forMode: .default)
        Logger.info("MetalEngine stopped")
    }

    func draw(drawable: CAMetalDrawable) {
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
