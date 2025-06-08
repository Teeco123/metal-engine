import Foundation
import Metal

guard let device = MTLCreateSystemDefaultDevice() else {
  print("Failed to get the system's default Metal device.")
  exit(1)
}

print("Metal device created successfully: \(device.name)")
