import Foundation
import Metal

final class Device: Sendable {
    public static let shared = Device()

    public let device: MTLDevice
    public let commandQueue: MTLCommandQueue
    public static func makeCommandBuffer() -> MTLCommandBuffer {
        shared.makeCommandBufferPrivate()
    }
    public static func makeRenderCommandEncoder(
        commandBuffer: MTLCommandBuffer, passDescriptor: MTLRenderPassDescriptor
    )
    -> MTLRenderCommandEncoder {
        shared.makeRenderCommandEncoderPrivate(commandBuffer, passDescriptor)
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

    private func makeCommandBufferPrivate() -> MTLCommandBuffer {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            Logger.error("Failed to create command buffer")
            exit(1)
        }
        return commandBuffer
    }

    private func makeRenderCommandEncoderPrivate(
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

}
