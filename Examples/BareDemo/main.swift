import Foundation
import MetalEngine

@main
@MainActor
struct BareDemo {
    static var engine: MetalEngine = MetalEngine.shared
    static var window: Window = Window.shared

    static func main() {
        Logger.info("Bare demo started")
        window.size = Size(1800, 1169 - 74)

        var color: Double = 0
        window.windowColor = WindowColor(color, color, color)
        window.title = "Bare demo"

        engine.update = {
            color += 0.001
            Window.shared.windowColor = WindowColor(color, color, color)
            Logger.info("update")
        }
        engine.initialize()

    }
}
