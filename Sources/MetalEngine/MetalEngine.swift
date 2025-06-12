import Foundation
import Metal
import QuartzCore
import Renderer
import Utils

@MainActor
public class MetalEngine {
    var renderTimer: Timer?
    var device: MTLDevice
    var commandQueue: MTLCommandQueue
    var layer: CAMetalLayer

    public init() {
        Logger.info("MetalEngine starting up...")
        device = Device.device
        commandQueue = Device.commandQueue
        MetalLayer.size = Size(1000, 1000)
        layer = MetalLayer.layer
    }

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

    public func stopRenderingLoop() {
        renderTimer?.invalidate()
        renderTimer = nil
    }

    func draw() {
        let drawable = MetalLayer.drawable

        let passDescriptor = MTLRenderPassDescriptor()
        passDescriptor.colorAttachments[0].texture = drawable.texture
        passDescriptor.colorAttachments[0].loadAction = .clear
        passDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 0.75, 0.8, 1.0)
        passDescriptor.colorAttachments[0].storeAction = .store

        guard let commandBuffer = self.commandQueue.makeCommandBuffer(),
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: passDescriptor)
        else { return }

        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
