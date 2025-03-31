import SwiftUI
import Vision
import GoogleSignIn

struct ShareView: View {
    var itemProviders: [NSItemProvider]
    var extensionContext: NSExtensionContext?
    var body: some View {
        VStack {
//            if let text = myText {
//                Text(text)
//            }
            
            Button(action: {
                makeNetworkCall()
            }, label: {
                Text("Send to Google")
            })
        }
        .onAppear {
//            getText()
        }
    }
    
    private func makeNetworkCall() {

        let networkManager = NetworkManager(accessToken: "")
        let docId = "1QEsqNiA9de5VNfZ9zauN23-daDklB-_kLUGPSRPOa7o"
        // Move out of Task
        Task {
            try await networkManager.sendData(endpoint: .sendToDocs(docId: docId))
        }
    }
    
    private func getText(image: CGImage? = nil) {
        DispatchQueue.global(qos: .userInteractive).async {
            let item = self.itemProviders.first!
            item.loadDataRepresentation(for: .image) { data, error in
                if let data, let fullImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        extractTextFromImage(fullImage)
                        print(fullImage)
                    }
                }
            }
        }
    }
    
    func extractTextFromImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else {
            return
        }
        
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("Error during OCR: \(error.localizedDescription)")
                return
            }
            
            var recognizedText = ""
            for observation in request.results as! [VNRecognizedTextObservation] {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                recognizedText += topCandidate.string + "\n"
            }
            
//            self.myText = recognizedText
            print(recognizedText)
            // Now send the extracted text to Google Docs (or process it further)
//            self.sendTextToGoogleDocs(recognizedText)
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
        
//        for provider in itemProviders {
//
//        }
//        guard let image = image else { return }
//
//          let request = VNRecognizeTextRequest { request, error in
//              if let error = error {
//                  print("Error during OCR: \(error.localizedDescription)")
//                  return
//              }
//
//              var recognizedText = ""
//              for observation in request.results as! [VNRecognizedTextObservation] {
//                  guard let topCandidate = observation.topCandidates(1).first else { continue }
//                  recognizedText += topCandidate.string + "\n"
//              }
//
//              print(recognizedText)
//          }
//
//          let handler = VNImageRequestHandler(cgImage: image, options: [:])
//          try? handler.perform([request])

}
