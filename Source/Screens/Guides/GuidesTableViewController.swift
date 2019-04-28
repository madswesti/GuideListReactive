import UIKit
import RxSwift
import RxCocoa

class GuidesTableViewController: UITableViewController {
	
	private let disposeBag = DisposeBag()
	
	let viewModel: GuideListViewModel
	
	init(viewModel: GuideListViewModel) {
		self.viewModel = viewModel
		super.init(style: .plain)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		self.tableView = UITableView(frame: .zero, style: .plain)
		self.tableView.tableFooterView = UIView()
		self.tableView.register(GuideTableViewCell.self, forCellReuseIdentifier: GuideTableViewCell.reuseIdentifier)
		self.title = viewModel.title
		self.refreshControl = UIRefreshControl()
		self.refreshControl?.attributedTitle = NSAttributedString(string: self.viewModel.loadingTitle)
		self.refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.bindViewModel()
		self.viewModel.refresh()
	}
	
	@objc private func refresh(_ sender: Any?) {
		self.viewModel.refresh()
	}
}

private extension GuidesTableViewController {
	func bindViewModel() {
		self.viewModel.guideViewModels.drive(self.tableView.rx.items(cellIdentifier: GuideTableViewCell.reuseIdentifier, cellType: GuideTableViewCell.self)) { (row, viewModel, cell) in
			cell.viewModel = viewModel
			}.disposed(by: self.disposeBag)
		
		guard let refreshControl = self.refreshControl else { return }
		self.viewModel.isLoading
			.drive(refreshControl.rx.isRefreshing)
			.disposed(by: self.disposeBag)
	}
}
