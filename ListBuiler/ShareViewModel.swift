final class ShareViewModel {
    
//    private func updateDoc(accessToken: String) {
//        let documentId = "1QEsqNiA9de5VNfZ9zauN23-daDklB-_kLUGPSRPOa7o"
//        
//        // Define the URL for the API call
//        https://docs.google.com/document/u/0/
//        let urlString = "https://docs.googleapis.com/v1/documents/\(documentId):batchUpdate"
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return
//        }
//        
//        let updateRequest: [String: Any] = [
//            "requests": [
//                [
//                    "insertText": [
//                        "location": [
//                            "index": 1  // Change the index to where you want to insert text
//                        ],
//                        "text": "Hello, this is the new text inserted into the document!"
//                    ]
//                ]
//            ]
//        ]
//        
//        guard let jsonData = try? JSONSerialization.data(withJSONObject: updateRequest, options: []) else {
//            print("Failed to serialize JSON")
//            return
//        }
//        
//        // Create the URLRequest
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        
//        // Set the Authorization header with the Bearer token
//        
//        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
//        
//        // Perform the network request
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error making request: \(error)")
//                return
//            }
//            
//            if let httpResponse = response as? HTTPURLResponse {
//                if httpResponse.statusCode == 200 {
//                    print("Request succeeded")
//                    
//                    // Process the response data (if needed)
//                    if let data = data {
//                        do {
//                            // For example, parse the response as JSON
//                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                                print("Response JSON: \(json)")
//                            }
//                        } catch {
//                            print("Error parsing JSON: \(error)")
//                        }
//                    }
//                } else {
//                    print("Request failed with status code: \(httpResponse.statusCode)")
//                }
//            }
//        }
//        
//        // Start the network request
//        task.resume()
//    }
}
