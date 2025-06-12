import Foundation
import Metal
import QuartzCore

/// Manages the Metal rendering loop and coordinates drawing operations on the main actor.
///
/// `MetalEngine` initializes the window, sets up a render timer to drive a
/// 60 FPS rendering loop, and performs basic drawing using Metal command buffers.
///
/// This class ensures that all rendering happens on the main actor, making it
/// safe to interact with UI elements and Metal resources tied to the main thread.
@MainActor
public class MetalEngine {

    /// Timer used to drive the rendering loop at approximately 60 frames per second.
    var renderTimer: Timer?

    /// Initializes a new `MetalEngine` instance and sets up the rendering environment.
    ///
    /// Logs the startup process and initializes the shared application window.
    public init() {
        Logger.info("MetalEngine starting up...")
        Window.shared.initialize()
    }

    /// Starts the rendering loop, scheduling a timer to call `draw()` at 60 FPS.
    ///
    /// The drawing is dispatched asynchronously to the main actor.
    public func startRenderingLoop() {
        renderTimer = Timer.scheduledTimer(
            withTimeInterval: 1.0 / 60.0, repeats: true
        ) { [weak self] _ in
            guard let self = self else { return }

            Task { @MainActor in
                self.draw()
            }
        }
    }

    /// Stops the rendering loop by invalidating and removing the timer.
    public func stopRenderingLoop() {
        renderTimer?.invalidate()
        renderTimer = nil
    }

    /// Performs a single frame rendering operation.
    ///
    /// Sets up a render pass descriptor with a clear color, creates a command buffer,
    /// encodes rendering commands, presents the drawable, and commits the command buffer.
    func draw() {
        let passDescriptor = MTLRenderPassDescriptor()
        passDescriptor.colorAttachments[0].texture = Window.shared.drawable.texture
        passDescriptor.colorAttachments[0].loadAction = .clear
        passDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 0.75, 0.8, 1.0)
        passDescriptor.colorAttachments[0].storeAction = .store

        guard let commandBuffer = Device.shared.commandQueue.makeCommandBuffer() else { return }
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: passDescriptor)
        else { return }

        renderEncoder.endEncoding()
        commandBuffer.present(Window.shared.drawable)
        commandBuffer.commit()
    }
}
