import Foundation
import Metal
import Utils

public final class Device: @unchecked Sendable {
    public static let shared = Device()
    var SDevice: MTLDevice
    var SCommandQueue: MTLCommandQueue

    private init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            Logger.error("Failed to create metal device")
            exit(1)
        }
        SDevice = device
        Logger.success("Created metal device: \(device.name)")

        guard let commandQueue = device.makeCommandQueue() else {
            Logger.error("Failed to create command queue")
            exit(1)
        }
        SCommandQueue = commandQueue
        Logger.success("Created command queue for device: \(device.name)")
    }

    public static var device: MTLDevice { shared.SDevice }
    public static var commandQueue: MTLCommandQueue { shared.SCommandQueue }
}
