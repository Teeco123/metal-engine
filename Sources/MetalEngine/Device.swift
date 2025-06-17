import Foundation
import Metal

final class Device: Sendable {
    public static let shared = Device()

    public let device: MTLDevice
    public let commandQueue: MTLCommandQueue
    public var commandBuffer: MTLCommandBuffer {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            Logger.error("Failed to create command buffer")
            exit(1)
        }
        return commandBuffer
    }
    public static func renderCommandEncoder(
        _ commandBuffer: MTLCommandBuffer, _ passDescriptor: MTLRenderPassDescriptor
    )
    -> MTLRenderCommandEncoder {
        guard
            let commandEncoder = commandBuffer.makeRenderCommandEncoder(
                descriptor: passDescriptor)
        else {
            Logger.error("Failed to create render command encoder")
            exit(1)
        }
        return commandEncoder
    }

    private init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            Logger.error("Failed to create metal device")
            exit(1)
        }
        self.device = device
        Logger.success("Created metal device: \(device.name)")

        guard let commandQueue = device.makeCommandQueue() else {
            Logger.error("Failed to create command queue")
            exit(1)
        }
        self.commandQueue = commandQueue
        Logger.success("Created command queue for device: \(device.name)")
    }
}
