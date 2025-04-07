import SwiftUI

public struct BlueButton: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .font(.headline)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: AppDesign.cornerRadius)
                .fill(AppDesign.primaryColor)
        )
        .shadow(radius: AppDesign.shadowRadius)
    }
}
