import Foundation
import Metal

/// A singleton wrapper around the system's default Metal device and its command queue.
///
/// This class provides a shared instance to access the Metal device (`MTLDevice`) and
/// command queue (`MTLCommandQueue`) used for issuing GPU commands. It handles initialization
/// and will terminate the application with an error message if Metal cannot be set up.
///
/// The class is marked `@unchecked Sendable` since Metal objects are not inherently thread-safe,
/// but the usage here assumes safe access patterns.
public final class Device: @unchecked Sendable {

    /// The shared singleton instance of the `Device` class.
    public static let shared = Device()

    /// The system's default Metal device.
    public var device: MTLDevice

    /// The command queue associated with the Metal device, used to schedule command buffers.
    public var commandQueue: MTLCommandQueue

    /// Initializes the Metal device and command queue.
    ///
    /// If the system does not support Metal or fails to create the necessary objects,
    /// the method logs an error and terminates the application.
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
