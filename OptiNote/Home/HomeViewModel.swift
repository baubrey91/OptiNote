import SwiftUI
import GoogleSignIn
import AuthenticationServices
import OptiNoteShared

enum HomeState {
    case loading
    case loggedIn
    case loggedOut
    case error(of: Error)
}

final class HomeViewModel: NSObject, ObservableObject {
    
    @Published var state: HomeState = .loading
    @Published var selectedTab: Tab
    @Published var deepLinkedImage: UIImage? = nil
    
    private let additionalScopes = ["https://www.googleapis.com/auth/drive"]
    
    init(selectedTab: Tab = .importImageView) {
        _selectedTab = Published(initialValue: selectedTab)
    }
    
    private var isLoggedIn: Bool {
        GIDSignIn.sharedInstance.currentUser != nil
    }
    
    func validateUser() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let user = user {
                self.state = .loggedIn
                self.saveTokenData(user: user)
            } else {
                self.state = .loggedOut
            }
        }
    }
    
    func googleSignIn() {
        
        let clientID = "Add your client ID here"
        let config = GIDConfiguration(clientID: clientID)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController,
            hint: nil,
            additionalScopes: self.additionalScopes
        ) { result, error in
            if let error = error {
                self.state = .error(of: error)
                return
            }
            if let user = result?.user {
                self.saveTokenData(user: user)
                self.state = .loggedIn
            }
        }
    }
        
    func googleSignOut() {
        GIDSignIn.sharedInstance.signOut()
        self.state = .loggedOut
    }
    
    func fetchDeepLinkedImage() {
        self.deepLinkedImage = PersistenceManager.shared.getImage()
    }
}

// MARK: - Private
private extension HomeViewModel {
    func saveTokenData(user: GIDGoogleUser) {
        PersistenceManager.shared.setAccessToken(
            accessToken: user.accessToken.tokenString,
            expirationDate: user.accessToken.expirationDate
        )
    }
}
