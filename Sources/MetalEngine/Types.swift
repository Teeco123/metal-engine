import Metal

/// A 2D size object that stores optional width and height values.
public struct Size {
    /// The width component of the size.
    public var width: CGFloat?

    /// The height component of the size.
    public var height: CGFloat?

    /// Initializes a `Size` with the given width and height.
    ///
    /// - Parameters:
    ///   - width: The width value.
    ///   - height: The height value.
    public init(_ width: CGFloat, _ height: CGFloat) {
        self.width = width
        self.height = height
    }

    /// Initializes a `Size` with no values set.
    public init() {
        self.width = nil
        self.height = nil
    }
}

public struct WindowColor {
    public var red: Double?
    public var green: Double?
    public var blue: Double?

    public init(_ red: Double, _ green: Double, _ blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    public init() {
        self.red = nil
        self.green = nil
        self.blue = nil
    }
}
