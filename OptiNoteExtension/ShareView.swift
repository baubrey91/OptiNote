import SwiftUI
import OptiNoteShared

struct ShareView: View {
    
    @StateObject var viewModel: ShareViewModel
    
    var body: some View {
        switch self.viewModel.state {
        case .error(let error):
            ErrorView(errorDescription: error.localizedDescription)
            Button(action: {
                self.viewModel.closeShareView()
            }, label: {
                Text(Styler.dismissText)
            })
        case .loading:
            ProgressView()
                .onAppear {
                    Task {
                        guard let image = await self.viewModel.getImage() else { return }
                        await MainActor.run {
                            self.viewModel.verifySessionAndFile(image: image)
                        }
                        //                //Should this be on background thread?
                        await self.viewModel.extractTextFromImage(from: image)
                    }
                }
        case .loadedWithNoResult:
            Text(Styler.noResults)
        default:
                VStack {
         
                    Text(Styler.textFound)
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    TextField(
                        Styler.noTextFound,
                        text: $viewModel.text,
                        axis: .vertical
                    )
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .modifier(Border())
                    .onChange(of: viewModel.text) { _, newValue in
                        if newValue.count > AppProperties.characterLimit {
                            viewModel.text = String(newValue.prefix(AppProperties.characterLimit))
                        }
                    }
                    HStack {
                        Spacer()
                        Text("\(viewModel.text.count)/\(AppProperties.characterLimit)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button(Styler.dismissText) {
                            self.viewModel.closeShareView()
                        }
                        .buttonStyle(BlueButton())
                        
                        Spacer()
                        
                        Button(Styler.sendToGoogleText) {
                            Task {
                                await self.viewModel.sendToGoogle(text: viewModel.text)
                            }                        }
                        .buttonStyle(BlueButton())
                        
                        Spacer()
                    }
                    HStack {
                        Image(systemName: Styler.docImageName)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(Styler.selectedFilesText)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(viewModel.currentFile?.name ?? Styler.noFileText)
                                .font(.body)
                        }
                        
                        Spacer()
                        
                        Picker(Styler.fileText, selection: $viewModel.currentFile) {
                            ForEach(viewModel.previousFiles, id: \.self) { file in
                                HStack {
                                    Image(systemName: Styler.docImageName)
                                    Text(file.name)
                                }
                                .tag(file)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(AppProperties.cornerRadius)
                    if self.viewModel.isSendingData {
                        CustomSpinner()
                    }
                }

                .padding()
                .alert(isPresented: $viewModel.showingAlert) {
                    guard let alertType = self.viewModel.alertType else {
                        return Alert(title: Text(Styler.unknownErrorText))
                    }
                   return Alert(
                        title: Text(alertType.alertText),
                        dismissButton: .default(Text(Styler.goToAppText)) {
                            self.viewModel.openParentApp(with: alertType.deepLinkUrl)
                        }
                    )
                }
        }
    }
}

private enum Styler {
    
    static let dismissText = "Dismiss"
    
    static let noResults = "No results"
    
    static let textFound = "This is the text we found"
    static let noTextFound = "No text found"
    static let sendToGoogleText = "Send to Google"
    
    static let unknownErrorText = "Unknown Error"
    static let goToAppText = "Go to App"
    
    static let previousFiles = "Previous Files:"
    
    // Picker
    static let selectedFilesText = "Selected File"
    static let fileText = "File"
    static let noFileText = "No File Selected"
    static let docImageName = "doc.text"
    
}
