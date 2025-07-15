import SwiftUI

public struct CustomSpinner: View {
    
    @State private var degree: Int = 270
    @State private var spinnerLength = 0.6
    
    public init() {}

    public var body: some View {
        Circle()
            .trim(from: 0.0,to: spinnerLength)
            .stroke(
                LinearGradient(
                    colors: [.green,.blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                style: StrokeStyle(
                    lineWidth: 8.0,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            .animation(
                Animation.easeIn(duration: 1.5).repeatForever(autoreverses: true),
                value: spinnerLength
            )
            .frame(width: 60, height: 60)
            .rotationEffect(Angle(degrees: Double(degree)))
            .animation(
                Animation.linear(duration: 1).repeatForever(autoreverses: false),
                value: degree
            )
            .onAppear{
                degree = 270 + 360
                spinnerLength = 0
            }
    }
}
