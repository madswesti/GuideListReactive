import UIKit
import RxSwift

final class GuideTableViewCell: UITableViewCell {
	
	private var disposeBag = DisposeBag()
	
	static let reuseIdentifier = "GuideTableViewCellReuseIdentifier"
	
	private let icon: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFit
		view.image = #imageLiteral(resourceName: "Image")
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let nameLabel: UILabel = {
		let view = UILabel()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.font = UIFont.boldSystemFont(ofSize: 18)
		view.numberOfLines = 0
		view.lineBreakMode = .byWordWrapping
		return view
	}()
	
	private let startDateLabel: UILabel = {
		let view = UILabel()
		view.translatesAutoresizingMaskIntoConstraints = true
		return view
	}()
	
	private let endDateLabel: UILabel = {
		let view = UILabel()
		view.translatesAutoresizingMaskIntoConstraints = true
		return view
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.configure()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		self.nameLabel.text = nil
		self.endDateLabel.text = nil
		self.startDateLabel.text = nil
		self.icon.image = #imageLiteral(resourceName: "Image")
		self.disposeBag = DisposeBag()
	}
	
	var viewModel: GuideViewModel? {
		didSet {
			guard let viewModel = self.viewModel else { return }
			self.nameLabel.text = viewModel.name
			self.startDateLabel.text = viewModel.startDateText
			self.endDateLabel.text = viewModel.endDateText
			
			viewModel.imageData.drive(onNext: { [weak self] (data) in
				guard let data = data else {
					return
				}
				self?.icon.image = UIImage(data: data)
			}).disposed(by: disposeBag)
		}
	}
}

private extension GuideTableViewCell {
	func configure() {
		
		self.selectionStyle = .none
		
		// Configure subviews
		let textVerticalStackView = UIStackView(
			arrangedSubviews: [self.nameLabel, self.startDateLabel, self.endDateLabel, StrectableView()]
		)
		textVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
		textVerticalStackView.axis = .vertical
		textVerticalStackView.spacing = 4
		
		let iconVerticalStackView = UIStackView(arrangedSubviews: [self.icon, StrectableView()])
		iconVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
		iconVerticalStackView.axis = .vertical
		
		let horizontalStackView = UIStackView(arrangedSubviews: [iconVerticalStackView, textVerticalStackView])
		horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
		horizontalStackView.spacing = 8
		
		self.contentView.addSubview(horizontalStackView)
		
		// Configue constraints
		let guide = self.contentView.layoutMarginsGuide
		NSLayoutConstraint.activate([
			self.icon.heightAnchor.constraint(equalToConstant: 70),
			self.icon.widthAnchor.constraint(equalTo: self.icon.heightAnchor, multiplier: 1.2),
			
			horizontalStackView.topAnchor.constraint(equalTo: guide.topAnchor),
			horizontalStackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
			horizontalStackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
			horizontalStackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
		])
	}
}


private class StrectableView: UIView {
	init() {
		super.init(frame: .zero)
		self.setContentHuggingPriority(.defaultLow, for: .vertical)
		self.setContentHuggingPriority(.defaultLow, for: .horizontal)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
