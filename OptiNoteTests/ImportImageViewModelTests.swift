import XCTest
@testable import OptiNote

final class ImportImageViewModelTests: XCTestCase {
    var viewModel: ImportImageViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ImportImageViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertEqual(viewModel.text, "")
        XCTAssertFalse(viewModel.isSendingData)
        XCTAssertNotNil(viewModel.images)
    }

    func testGetCurrentFileReturnsNoFileSelectedWhenNil() {
        XCTAssertEqual(viewModel.getCurrentFile(), "No File Selected")
    }

    // Add more tests for drawGesture, cropImage, extractTextFromImage, sendToGoogle, etc. as needed.
} 