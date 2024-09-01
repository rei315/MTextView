import UIKit
import SwiftUI
import MTextView

enum Section: Int {
    case items
}

struct Item: Hashable {
    let id: UUID = UUID()
    let attributedString: NSAttributedString
}

final class ViewController: UITableViewController {
  lazy var dataSource = UITableViewDiffableDataSource<Section, Item>(
    tableView: tableView,
    cellProvider: { [unowned self] (tableView, indexPath, item) in
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
      cell.update(text: item.attributedString)
      return cell
    }
  )
  
  var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(TextCell.self, forCellReuseIdentifier: "TextCell")
    _ = dataSource
    updateDataSource()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  private func updateDataSource() {
    snapshot.deleteAllItems()
    snapshot.appendSections([.items])
    snapshot.appendItems((0..<10).map({ _ in
      return Item(attributedString: .init(string: "hello"))
    }), toSection: .items)
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

private class TextCell: UITableViewCell {
  private let textView: MTextView = .init(frame: .zero)
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    contentView.addSubview(textView)
    textView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: contentView.topAnchor),
      textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
      textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
    ])
  }
  
  func update(text: NSAttributedString) {
    textView.attributedText = text
  }
}
