import XCTest
@testable import GuideList

class GuideTests: XCTestCase {
	func testDecode() throws {
		try self.decodeModel { (guide: Guide) in
			
			let expectedName = "Belmont MBA in Spain"
			let expectedStartDate = Date(from: "Mar 05, 2016")
			let expectedEndDate = Date(from: "Mar 12, 2016")
			let expectedURL = URL(string: "https://s3.amazonaws.com/media.guidebook.com/service/ywKpKflYaNeIWted6aV10yyUc1PTu9klk4V7SoTn/logo.png")
			
			XCTAssertEqual(guide.name, expectedName)
			XCTAssertEqual(guide.startDate, expectedStartDate)
			XCTAssertEqual(guide.endDate, expectedEndDate)
			XCTAssertEqual(guide.iconURL, expectedURL)
		}
	}
}

private extension Date {
	init?(from dateString: String) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM dd, yyyy"
		guard let date = dateFormatter.date(from: dateString) else { return nil }
		self = date
	}
}
