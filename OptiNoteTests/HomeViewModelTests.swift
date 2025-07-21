import XCTest
import GoogleSignIn
@testable import OptiNote

final class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!

    override func setUp() {
        super.setUp()
        viewModel = HomeViewModel(selectedTab: .importImageView)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertEqual(viewModel.state, .loading)
        XCTAssertEqual(viewModel.selectedTab, .importImageView)
        XCTAssertNil(viewModel.deepLinkedImage)
    }

    func testTabSelection() {
        viewModel.selectedTab = .googleDriveListView
        XCTAssertEqual(viewModel.selectedTab, .googleDriveListView)
    }

    func testGoogleSignOutSetsLoggedOut() {
        viewModel.state = .loggedIn
        viewModel.googleSignOut()
        XCTAssertEqual(viewModel.state, .loggedOut)
    }

    // Add more tests for validateUser, googleSignIn, fetchDeepLinkedImage, etc. as needed.
} 