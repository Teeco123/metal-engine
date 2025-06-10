import Foundation
import MetalEngine
import Utils

@main
struct BareDemo {
    @MainActor
    static var engine: MetalEngine?

    static func main() {
        Logger.info("Bare demo started")
        engine = MetalEngine()
        engine?.startRenderingLoop()
        RunLoop.main.run()
    }
}
