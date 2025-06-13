import AppKit
import Foundation
import Metal
import QuartzCore

/// A class that manages the Metal rendering loop and coordinates drawing operations on the main actor.
///
/// `MetalEngine` sets up a CADisplayLink to maintain a 60 FPS render loop, initializes
/// the Metal window, and performs basic drawing with command buffers. All rendering occurs
/// on the main actor, ensuring thread safety with UI elements and Metal resources.
@MainActor
public class MetalEngine {

    /// A link to the display's refresh rate used to drive the rendering loop.
    var displayLink: CADisplayLink?

    /// Creates and initializes a new instance of `MetalEngine`.
    ///
    /// This method sets up the Metal environment by initializing the shared application window,
    /// attaching the rendering loop to the screen's display link, and starting the 60 FPS timer.
    ///
    /// - Important: This method must be called on the main actor.
    public init() {
        Logger.info("MetalEngine starting up...")
        Window.shared.initialize()
        let screen = NSScreen.main!
        displayLink = screen.displayLink(target: self, selector: #selector(frameTick))
        guard let displayLink = displayLink else {
            Logger.error("Failed to create display link")
            exit(1)
        }
        displayLink.add(to: .main, forMode: .default)
        Logger.success("MetalEngine initialized successfully")
    }

    /// Callback invoked on every vertical sync tick.
    ///
    /// This function is automatically triggered by the CADisplayLink and serves as the
    /// entry point for frame rendering logic.
    @objc public func frameTick() {
        draw()
    }

    /// Stops the rendering loop.
    ///
    /// Invalidates the display link and stops the frame updates.
    ///
    /// - Important: If the display link is not set, this function logs an error and exits.
    func stop() {
        guard let displayLink = displayLink else {
            Logger.error("Display link not available for stopping")
            exit(1)
        }
        displayLink.invalidate()
        Logger.info("MetalEngine stopped")
    }

    /// Renders a single frame using Metal.
    ///
    /// This method sets up a render pass with a pink clear color, creates a command buffer,
    /// encodes an empty rendering pass, presents the drawable, and commits the command buffer.
    ///
    /// - Important: This method assumes the existence of a valid `Window.shared.drawable` and
    ///   `Device.shared.commandQueue`. It includes better error handling and synchronization.
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

        guard let commandBuffer = Device.shared.commandQueue.makeCommandBuffer() else {
            Logger.error("Failed to create command buffer")
            exit(1)
        }

        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: passDescriptor)
        else {
            Logger.error("Failed to create render encoder")
            exit(1)
        }

        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
