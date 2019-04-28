import Foundation

public enum HTTPMethod {
	case delete
	case get
	case head
	case option
	case patch(Data?)
	case post(Data?)
	case put(Data?)
	
	/// Http method value
	var value: String {
		switch self {
		case .delete: return  "DELETE"
		case .get: return "GET"
		case .head: return "HEAD"
		case .option: return "OPTION"
		case .patch: return "PATCH"
		case .post: return "POST"
		case .put: return "PUT"
		}
	}
}
