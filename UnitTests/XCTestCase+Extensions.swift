import XCTest

extension XCTestCase {
	/// Convenient way of loading mocked json data. Shamelessly stolen from https://www.youtube.com/watch?v=d71JHYVWD-4
	func decodeModel<Model: Decodable>(_ verificationBlock: (Model) -> Void) throws {
		let bundle = Bundle(for: type(of: self))
		let fileName = String(describing: Model.self)
		guard let url = bundle.url(forResource: fileName, withExtension: "json") else { return }
		
		let data = try Data(contentsOf: url)
		let instance = try JSONDecoder().decode(Model.self, from: data)
		verificationBlock(instance)
	}
}
