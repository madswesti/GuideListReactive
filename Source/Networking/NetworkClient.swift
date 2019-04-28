import Foundation

/// Simple wrapper around `URLSession`. Should be extended with the appropriate headers.
final class NetworkClient {
	
	private let baseURL: URL
	
	private let session: URLSession
	
	init(baseURL: URL, configuration: URLSessionConfiguration = URLSessionConfiguration.default, delegate: URLSessionDelegate? = nil, delegateQueue: OperationQueue? = nil) {
		self.baseURL = baseURL
		self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: delegateQueue)
	}
}

extension NetworkClient {
	
	/// Makes a request to the given `Endpoint`.
	@discardableResult
	func request<ReturnType>(_ endPoint: Endpoint<ReturnType>, completion: @escaping (Result<ReturnType, Swift.Error>) -> Void) -> URLSessionTask {
		guard let urlRequest = endPoint.urlRequest(for: self.baseURL) else {
			fatalError("Unable to create request from endpoint.")
		}
		
		return self.request(urlRequest, completion: { (result) in
			switch result {
			case .success(_, _, let data):
				completion(Result(catching: { () in
					guard let data = data else {
						throw Error.missingData
					}
					return try endPoint.decode(data)
				}))
			case .failure(let error):
				completion(.failure(error))
			}
		})
	}
	
	/// Internal method for calling an `URLRequest`.
	private func request(_ request: URLRequest, completion: @escaping (Result<(URLRequest, URLResponse?, Data?), Swift.Error>) -> Void) -> URLSessionTask {
		let task = self.session.dataTask(with: request, completionHandler: { data, response, error in
			let result = Result(catching: { () -> (URLRequest, URLResponse?, Data?) in
				guard let error = error else { return (request, response, data) }
				throw error
			})
			completion(result)
		})
		task.resume()
		
		return task
	}
}

//MARK: - Errors

extension NetworkClient {
	enum Error: Swift.Error {
		case missingData
		
		var localizedDescription: String {
			switch self {
			case .missingData: return NSLocalizedString("Failed to recieve data", comment: "Network client error message")
			}
		}
	}
}

//MARK: - Convenience extensions

fileprivate extension Endpoint {
	/// Generates a `URLRequest` matching the endpoint.
	func urlRequest(for baseURL: URL) -> URLRequest? {
		guard
			let rawURL = URL(string: self.path, relativeTo: baseURL),
			var components = URLComponents(url: rawURL, resolvingAgainstBaseURL: true)
		else { return nil }
		
		components.queryItems = self.parameters?.compactMap({ URLQueryItem(name: $0.key, value: $0.value) })
		guard let url = components.url?.absoluteURL else { return nil }
		
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.value
		
		switch httpMethod {
		case .patch(let payload), .post(let payload), .put(let payload):
			request.httpBody = payload
		default:
			break
		}
		return request
	}
}

