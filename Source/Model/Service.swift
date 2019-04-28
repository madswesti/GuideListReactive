import RxSwift
import RxCocoa

class Service {
	
	private let imageCache = NSCache<NSString, NSData>()
	
	private let networkClient: NetworkClient
	
	init(networkClient: NetworkClient) {
		self.networkClient = networkClient
	}
	
	func requestGuides() -> Observable<[Guide]> {
		// Internal struct matching the object returned by the endpoint
		struct Response: Decodable {
			let data: [Guide]
		}

		return Observable.create { [weak self] observer -> Disposable in
			self?.networkClient.request(Endpoint<Response>(path: "upcomingGuides", httpMethod: .get)) {
				switch $0 {
				case .success(let response):
					observer.onNext(response.data)
					observer.onCompleted()
				case .failure(let error):
					observer.onError(error)
					observer.onCompleted()
				}
			}
			return Disposables.create()
		}.retry(2)
	}
	
	/// Request an image resource, if present in cache no request is send.
	func requestImageData(for url: URL) -> Observable<Data?> {
		return Observable.create { [weak self] observer -> Disposable in
			let cacheKey = NSString(string: url.absoluteString)
			if let data = self?.imageCache.object(forKey: cacheKey) as Data? {
				observer.onNext(data)
				observer.onCompleted()
			} else {
				URLSession.shared.dataTask(with: url) { (data, response, error) in
					if let error = error {
						observer.onError(error)
						return
					}
					if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 400 {
						observer.onError(Error.imageDataNotFound)
						return
					}
					guard let data = data else {
						observer.onError(Error.imageDataNotFound)
						return
					}
					// store in cache
					self?.imageCache.setObject(data as NSData, forKey: cacheKey)
					observer.onNext(data)
					observer.onCompleted()
					return
					}.resume()
			}
			return Disposables.create()
		}.retry(2)
	}
	
	func clearImageCache() {
		self.imageCache.removeAllObjects()
	}
}

// MARK: Error

extension Service {
	enum Error: Swift.Error {
		case imageDataNotFound
		
		var localizedDescription: String {
			switch self {
			case .imageDataNotFound: return NSLocalizedString("No image data", comment: "Service error message")
			}
		}
	}
}
