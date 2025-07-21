import XCTest
@testable import OptiNoteShared

final class MockNetworkManager: NetworkManagerType {
    var sendDataCalled = false
    var getDataCalled = false

    func sendData(endpoint: Endpoint, accessToken: String) async throws {
        sendDataCalled = true
    }

    func getData<T>(endpoint: Endpoint, accessToken: String) async throws -> T where T : Decodable {
        getDataCalled = true
        // Return a dummy value if needed
        return "" as! T
    }
}

final class NetworkManagerTests: XCTestCase {
    var mockNetwork: MockNetworkManager!

    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkManager()
    }

    override func tearDown() {
        mockNetwork = nil
        super.tearDown()
    }

    func testSendDataIsCalled() async throws {
        try await mockNetwork.sendData(endpoint: .fetchFiles(folderId: nil), accessToken: "token")
        XCTAssertTrue(mockNetwork.sendDataCalled)
    }

    func testGetDataIsCalled() async throws {
        _ = try await mockNetwork.getData(endpoint: .fetchFiles(folderId: nil), accessToken: "token") as String
        XCTAssertTrue(mockNetwork.getDataCalled)
    }
} 