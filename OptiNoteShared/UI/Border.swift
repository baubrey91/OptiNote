import SwiftUI

public struct Border: ViewModifier {
    public init() {}

    public func body(content: Content) -> some View {
        content
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: AppProperties.cornerRadius)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
}
