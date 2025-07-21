import SwiftUI
import OptiNoteShared


struct GoogleDriveListView: View {
    
    @StateObject private var viewModel = GoogleDriveListViewModel()

    let folderId: String?

    init(folderId: String? = nil) {
        self.folderId = folderId
    }
    
    var body: some View {
        
        switch self.viewModel.state {
        case .error(let error):
            VStack {
                ErrorView(errorDescription: error)
                
                Button(Styler.tryAgain) {
                    self.viewModel.state = .loading
                }
                .padding()
                .buttonStyle(BlueButton())
            }
        case .loading:
            CustomSpinner()
            //            ProgressView()
                .onAppear {
                    self.viewModel.fetchFiles(for: self.folderId)
                }
        case .loaded:
            NavigationStack {
                List(self.viewModel.filteredFiles) { file in
                    if file.isFolder {
                        NavigationLink(file.name) {
                            GoogleDriveListView(folderId: file.id)
                        }
                    } else {
                        Button(file.name) {
                            self.viewModel.setSelectedFile(file: file)
                        }
                        .alert(
                            Styler.fileChanged,
                            isPresented: $viewModel.isPresented,
                            actions: {},
                            message: {
                                Text(self.viewModel.selectedFileText)
                            }
                        )
                    }
                }
                .searchable(
                    text: $viewModel.searchText,
                    prompt: Styler.search
                )
            }
        }
    }
}

private enum Styler {
    static let fileChanged = "Current File Changed"
    static let search = "Search Drive"
    static let tryAgain = "Try Again"
}
