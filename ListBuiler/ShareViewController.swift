import UIKit
import SwiftUI

final class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        isModalInPresentation = true
        
        if let itemProviders = (extensionContext?.inputItems as? [NSExtensionItem])?.first?.attachments {
            
            let hostingController = UIHostingController(rootView: ShareView(itemProviders: itemProviders, extensionContext: extensionContext))
            hostingController.view.frame = view.frame
            view.addSubview(hostingController.view)
        }
    }
}
