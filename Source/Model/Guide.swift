import Foundation

struct Guide: Decodable {
	let name: String
	let startDate: Date
	let endDate: Date
	let iconURL: URL
	
	private enum CodingKeys: String, CodingKey {
		case name
		case startDate
		case endDate
		case iconURL = "icon"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.name = try container.decode(String.self, forKey: .name)
		self.startDate = try container.decode(Date.self, forKey: .startDate, using: .default)
		self.endDate = try container.decode(Date.self, forKey: .endDate, using: .default)
		self.iconURL = try container.decode(URL.self, forKey: .iconURL)
	}
}

// MARK: - Conveninience extensions

private extension KeyedDecodingContainer {
	/// Decodes to a Date for a given key using a formatter - expects the json field to be a string.
	func decode(_ type: Date.Type, forKey key: KeyedDecodingContainer.Key, using formatter: DateFormatter) throws -> Date {
		let dateString = try self.decode(String.self, forKey: key)
		if let date = formatter.date(from: dateString) {
			return date
		} else {
			throw DecodingError.dataCorruptedError(
				forKey: key,
				in: self,
				debugDescription: "Date string does not match format expected by formatter."
			)
		}
	}
}

private extension DateFormatter {
	/// Default date formatter for backend.
	static var `default`: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM dd, yyyy"
		return formatter
	}
}
