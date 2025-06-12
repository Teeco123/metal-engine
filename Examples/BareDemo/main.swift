import Foundation
import MetalEngine
import Utils

@main
struct BareDemo {
    @MainActor
    static var engine: MetalEngine?

    static func main() {
        Logger.info("Bare demo started")
        Window.shared.size = Size(1000, 1000)
        engine = MetalEngine()
        engine?.startRenderingLoop()
        RunLoop.main.run()
    }
}
