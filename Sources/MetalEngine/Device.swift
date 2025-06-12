import Foundation
import Metal

public final class Device: @unchecked Sendable {
    public static let shared = Device()
    public var device: MTLDevice
    public var commandQueue: MTLCommandQueue

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
