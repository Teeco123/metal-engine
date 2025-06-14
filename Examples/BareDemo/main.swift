import Foundation
import MetalEngine

@main
struct BareDemo {
    @MainActor
    static var engine: MetalEngine = MetalEngine()

    static func main() {
        Logger.info("Bare demo started")
        Window.shared.size = Size(1000, 1000)
        Window.shared.windowColor = WindowColor(0, 0, 0)
        Window.shared.title = "Bare demo"

        engine.update = {
            Logger.info("dupa")
        }
        engine.initialize()

    }
}
