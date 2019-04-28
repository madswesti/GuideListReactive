import Foundation

struct Endpoint<Decoding> {
	
	typealias Parameter = (key: String, value: String)
	
	/// The endpoint path.
	let path: String
	
	/// The HTTP request method for the endpoint.
	let httpMethod: HTTPMethod
	
	/// The parameters of the http requests query string.
	let parameters: [Parameter]?
	
	/// Closure parsing the response data.
	var decode: (Data) throws -> Decoding
}

// MARK: - JSON decoding

extension Endpoint where Decoding: Decodable {
	
	init(path: String, parameters: [Endpoint.Parameter]? = nil, httpMethod: HTTPMethod) {
		self.path = path
		self.parameters = parameters
		self.httpMethod = httpMethod
		self.decode = { try JSONDecoder().decode(Decoding.self, from: $0) }
	}
}
