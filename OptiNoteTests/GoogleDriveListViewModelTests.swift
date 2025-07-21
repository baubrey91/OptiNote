import XCTest
@testable import OptiNote

final class GoogleDriveListViewModelTests: XCTestCase {
    var viewModel: GoogleDriveListViewModel!

    override func setUp() {
        super.setUp()
        viewModel = GoogleDriveListViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertEqual(viewModel.state, .loading)
        XCTAssertEqual(viewModel.filteredFiles.count, 0)
    }

    func testSetSelectedFileUpdatesIsPresented() {
        let file = DriveFile(id: "1", name: "Test", mimeType: "application/vnd.google-apps.document")
        viewModel.setSelectedFile(file: file)
        XCTAssertTrue(viewModel.isPresented)
    }

    // Add more tests for fetchFiles, searchText, etc. as needed.
} 