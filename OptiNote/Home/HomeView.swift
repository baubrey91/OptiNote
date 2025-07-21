import SwiftUI
import OptiNoteShared

enum Tab: Hashable {
    case importImageView
    case googleDriveListView
}

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        Group {
            switch self.viewModel.state {
            case .error(let error):
                VStack {
                    ErrorView(errorDescription: error.localizedDescription)
                    Button(Styler.errorTryAgain) {
                        self.viewModel.state = .loggedIn
                    }
                    .buttonStyle(BlueButton())
                }
            case .loading:
                CustomSpinner()
                    .onAppear {
                        self.viewModel.validateUser()
                    }
            case .loggedIn:
                NavigationStack {
                    TabView(selection: $viewModel.selectedTab) {
                        ImportImageView(deepLinkedImage: self.$viewModel.deepLinkedImage)
                            .tabItem {
                                Label(
                                    Styler.importText,
                                    systemImage: Styler.importImage
                                )
                            }
                            .tag(Tab.importImageView)
                        GoogleDriveListView()
                            .tabItem {
                                Label(Styler.fileText, systemImage: Styler.fileImage)
                            }
                            .tag(Tab.googleDriveListView)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                self.viewModel.showAlert = true
                            }) {
                                Image(systemName: Styler.signOutImage)
                            }
                        }
                    }
                }
                .onOpenURL { url in
                    self.viewModel.fetchDeepLinkedImage()
                    if url.absoluteString.contains("googledrive") {
                        self.viewModel.selectedTab = .googleDriveListView
                    }
                }
                
            case .loggedOut:
                Button(action: self.viewModel.googleSignIn) {
                    HStack {
                        Image(systemName: Styler.signInImage)
                        Text(Styler.signInText)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Styler.backgroundColor)
                    .cornerRadius(Styler.cornerRadius)
                }
            }
        }
        .alert(
            Styler.logOutConfirmationText,
            isPresented: self.$viewModel.showAlert,
            actions: {
                Button(role: .destructive) {
                    self.viewModel.googleSignOut()
                } label: {
                    Text(Styler.logOutText)
                }
            },
            message: {}
        )

    }
}

private enum Styler {
    
    // Error Screen
    static let errorTryAgain = "Try again"
    
    static let signOutImage = "door.right.hand.open"
    
    // Import Image
    static let importText = "Import Image"
    static let importImage = "document.viewfinder.fill"
    
    //Files Drive
    static let fileText = "Files View"
    static let fileImage = "folder.fill"
    
    //Previous Notes
    static let signInText = "Sign in with Google"
    static let signInImage = "globe"
    
    //Log out
    static let logOutText = "Log Out"
    static let logOutConfirmationText = "Are you sure you want to log out of Google?"
    
    
    static let backgroundColor = Color(red: 66/255, green: 133/255, blue: 244/255)
    static let cornerRadius: CGFloat = 8
}

