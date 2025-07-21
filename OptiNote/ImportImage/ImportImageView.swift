import SwiftUI
import PhotosUI
import OptiNoteShared

#Preview {
    ImportImageView(deepLinkedImage: .constant(nil))
}

struct ImportImageView: View {
    
    @StateObject var viewModel = ImportImageViewModel()
    @Binding var deepLinkedImage: UIImage?
    
    init(deepLinkedImage: Binding<UIImage?>) {
        self._deepLinkedImage = deepLinkedImage
    }

    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                Color.gray
                if let uiImage = viewModel.images.first,
                   let cgImage = uiImage.cgImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(
                            width: viewModel.screenWidth,
                            height: viewModel.screenWidth * Styler.screenHeightMultiplier
                        )
                        .onAppear {
                            Task {
                                await viewModel.extractTextFromImage(from: cgImage)
                            }
                        }
                }
                if let path = viewModel.path {
                    path.stroke(style: Styler.strokeStyle)
                }
            }
            .popover(isPresented: $viewModel.showingPopover) {
                processedTextPopover
            }
        }
        .alert(isPresented: $viewModel.showingAlert) {
            return .init(title: Text(viewModel.alertType?.alertText ?? Styler.unknownError))
        }
        .gesture(viewModel.drawGesture())
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                PhotosPicker(
                    selection: $viewModel.selectedItems,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Image(systemName: Styler.photoImageName)
                            .imageScale(.large)
                    }
            }
        }
        .onChange(of: deepLinkedImage) { _, newImage in
            if let newImage = newImage,
            let cgImage = newImage.cgImage {
                viewModel.images = [newImage]
                Task {
                    await viewModel.extractTextFromImage(from: cgImage)
                }
            }
        }
    }
    
    var processedTextPopover: some View {
        VStack {
            
            Label(
                self.viewModel.getCurrentFile(),
                systemImage: AppProperties.docImage)
                .font(.headline)
                .foregroundColor(.blue)
            TextField(
                Styler.noTextFound,
                text: $viewModel.text,
                axis: .vertical
            )
            .textFieldStyle(.roundedBorder)
            .padding(Styler.borderPadding)
            .modifier(Border())
            .onChange(of: viewModel.text) { _, newValue in
                // Add character limit
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
                
                Button(Styler.backText) {
                    self.viewModel.showingPopover = false
                }
                .buttonStyle(BlueButton())
                
                Spacer()
                
                Button(Styler.sendToGoogleText) {
                    self.viewModel.sendToGoogle(text: viewModel.text)
                }
                .buttonStyle(BlueButton())
                
                Spacer()
            }
            if self.viewModel.isSendingData {
                CustomSpinner()
            }
            if let errorText = self.viewModel.errorText {
                ErrorView(errorDescription: errorText)
            }
        }
        .padding(.horizontal, Styler.sidePadding)

    }
}

private enum Styler {
    static let screenHeightMultiplier: CGFloat = 1.5
    static let borderPadding: CGFloat = 2
    static let sidePadding: CGFloat = 8
    static let strokeStyle = StrokeStyle(lineWidth: 4, dash: [5])
    static let photoImageName = "photo"
    static let noTextFound = "No Text Found"
    static let backText = "Back"
    static let sendToGoogleText = "Send To Google"
    static let unknownError = "Unknown Error"
}
