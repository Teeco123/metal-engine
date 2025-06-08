import Foundation
import Logger
import Metal

guard let device = MTLCreateSystemDefaultDevice() else {
    Logger.error("Failed to get the system's default Metal device.")
    exit(1)
}

Logger.success("Metal device created successfully: \(device.name)")
