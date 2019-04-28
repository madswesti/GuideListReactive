import RxSwift
import RxCocoa

final class GuideViewModel {
	
	private let service: Service
	
	let name: String
	
	let startDateText: String
	
	let endDateText: String
	
	let iconURL: URL
	
	lazy var imageData: Driver<Data?> = {
		return self.service
			.requestImageData(for: self.iconURL)
			.asDriver(onErrorJustReturn: nil)
	}()
	
	init(guide: Guide, service: Service) {
		self.service = service
		self.name = guide.name
		self.startDateText = "Start date: \(DateFormatter.guideDateFormatter.string(from: guide.startDate))"
		self.endDateText = "End date: \(DateFormatter.guideDateFormatter.string(from: guide.endDate))"
		self.iconURL = guide.iconURL
	}
}

private extension DateFormatter {
	/// A localized `DateFormatter` for displaying dates for guides.
	static let guideDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dMMMyyyy", options: 0, locale: Locale.current)
		return formatter
	}()
}
