import SwiftUI

public struct ErrorView: View {
    
    let errorDescription: String
    
    public init(errorDescription: String) {
        self.errorDescription = errorDescription
    }
    
    public var body: some View {
        Image(systemName: "exclamationmark.triangle")
            .font(.system(size: 50))
            .foregroundColor(.orange)
        
        Text("Something went wrong")
            .font(.title2)
            .fontWeight(.semibold)
        
        Text(errorDescription)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
    }
}
