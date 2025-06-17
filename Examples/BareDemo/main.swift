import Foundation
import MetalEngine

@main
struct BareDemo {
    @MainActor
    static var engine: MetalEngine = MetalEngine()

    static func main() {
        Logger.info("Bare demo started")
        Window.shared.size = Size(1000, 1000)

        var color: Double = 0
        Window.shared.windowColor = WindowColor(color, color, color)
        Window.shared.title = "Bare demo"

        engine.update = {
            color += 0.001
            Window.shared.windowColor = WindowColor(color, color, color)
        }
        engine.initialize()

    }
}
