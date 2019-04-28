import RxSwift
import RxCocoa

final class GuideListViewModel {
	
	private let disposeBag = DisposeBag()
	
	private let service: Service
	
	private var loadingState = BehaviorRelay<Bool>(value: false)
	
	private var guides = BehaviorRelay<[Guide]>(value: [])
	
	let title = "Guides"
	
	let loadingTitle = "Loading guides…"
	
	lazy var guideViewModels: Driver<[GuideViewModel]> = {
		return self.guides
			.map { $0.map { GuideViewModel(guide: $0, service: self.service) } }
			.asDriver(onErrorJustReturn: [])
	}()
	
	lazy var isLoading: Driver<Bool> = {
		return self.loadingState.asDriver(onErrorJustReturn: false).distinctUntilChanged()
	}()
	
	init(service: Service) {
		self.service = service
	}
	
	func refresh() {
		self.service.clearImageCache()
		
		self.loadingState.accept(true)
		self.service.requestGuides().subscribe(onNext: { [weak self] (guides) in
			self?.loadingState.accept(false)
			self?.guides.accept(guides)
			}, onError: { [weak self] (error) in
				self?.loadingState.accept(false)
				self?.guides.accept([])
		}).disposed(by: self.disposeBag)
	}
}
