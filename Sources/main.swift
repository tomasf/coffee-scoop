import SwiftSCAD

Scoop(innerDiameter: 44, volume: 30, handleLength: 70)
    .save(to: "scoop-30.scad")

Scoop(innerDiameter: 38, volume: 20, handleLength: 70)
    .save(to: "scoop-20.scad")



struct Scoop: Shape3D {
    let innerRadius: Double
    let targetVolume: Double
    let handleLength: Double

    init(innerDiameter: Double, volume ml: Double, handleLength: Double) {
        self.innerRadius = innerDiameter / 2
        self.targetVolume = 1000 * ml
        self.handleLength = handleLength
    }

    var body: Geometry3D {
        let innerShape = Circle(radius: innerRadius)
        let coneVolume = innerShape.pyramidVolume(height: innerRadius)
        let baseVolume = targetVolume - coneVolume
        let baseHeight = baseVolume / innerShape.area

        let wallThickness = 1.5
        let outerRadius = innerRadius + wallThickness

        let handleWidth = 12.0
        let handleThickness = 5.0
        let handleSlopeLength = 15.0
        let handleExtent = handleLength + outerRadius

        Arc(range: 0°..<90°, radius: outerRadius)
            .adding {
                Rectangle(x: outerRadius, y: baseHeight)
                    .aligned(at: .maxY)
            }
            .subtracting {
                Polygon([
                    [0, innerRadius],
                    [innerRadius, 0],
                    [innerRadius, -baseHeight],
                    [0, -baseHeight]
                ])
            }
            .extruded()
            .aligned(at: .bottom)
            .adding {
                let handleShape = Rectangle(x: handleExtent, y: handleWidth)
                    .aligned(at: .centerY)
                    .adding {
                        Circle(radius: outerRadius)
                    }
                    .rounded(amount: handleWidth / 2 - 0.01)
                    .subtracting {
                        Circle(radius: innerRadius)
                        Circle(diameter: handleWidth - 2 * wallThickness)
                            .translated(x: handleExtent - handleWidth / 2)
                    }

                handleShape
                    .extruded(height: wallThickness)
                handleShape
                    .subtracting {
                        handleShape.offset(amount: -wallThickness, style: .round)
                    }
                    .extruded(height: baseHeight, convexity: 4)
                    .subtracting {
                        Cylinder(radius: baseHeight - handleThickness, height: outerRadius)
                            .rotated(x: 90°)
                            .resized(x: handleSlopeLength * 2, alignment: .center)
                            .aligned(at: .centerY, .minZ)
                            .adding {
                                Box(x: handleExtent, y: outerRadius, z: outerRadius)
                                    .aligned(at: .centerY)
                            }
                            .aligned(at: .minX, .minZ)
                            .translated(x: outerRadius - 2, z: handleThickness)
                    }
            }
    }
}
