//
//  CityListUIKitViewController.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 31.08.2021.
//

import UIKit
import Combine

final class TeamsListUIKitViewController: UIViewController {
  private let tableView = UITableView(frame: .zero, style: .grouped)
  private let useCase = TeamsUseCase()
  private lazy var backdrop: UIView = {
    let backdrop = UIView()
    backdrop.backgroundColor = .systemBlue.withAlphaComponent(0.7)
    backdrop.isHidden = true
    return backdrop
  }()

  private var groups: [Group] = []
  private var cancellable: [AnyCancellable] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    configure()
    setupTable()
    setupNavigation()
    setupConstraints()
    loadingData()
  }
}

// MARK: - Private methods

private extension TeamsListUIKitViewController {
  func setupViews() {
    view.addSubview(tableView)
    tableView.addSubview(backdrop)
  }

  func configure() {
    view.backgroundColor = .systemBackground

    tableView.backgroundColor = .clear
    tableView.translatesAutoresizingMaskIntoConstraints = false
  }

  func setupNavigation() {
    navigationItem.title = "UIKit"
  }

  func setupTable() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(TeamCell.self, forCellReuseIdentifier: "TeamCell")

    tableView.dragDelegate = self
    tableView.dropDelegate = self
    tableView.dragInteractionEnabled = true
//    tableView.setEditing(true, animated: false)
  }

  func setupConstraints() {
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  func loadingData() {
    let loading = useCase.getGroup().share()
    loading
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] newGroups in
        self?.groups = newGroups
        self?.tableView.reloadData()
      })
      .store(in: &cancellable)
  }

  func getTeam(by indexPath: IndexPath) -> Team {
    return groups[indexPath.section].teams[indexPath.row]
  }

  // MARK: - Interaction

  func move(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    tableView.performBatchUpdates({
      tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }) { [weak self] _ in
      guard let self = self else { return }
      let team = self.groups[sourceIndexPath.section].teams.remove(at: sourceIndexPath.row)
      self.groups[destinationIndexPath.section].teams.insert(team, at: destinationIndexPath.row)
    }
  }

  func interact(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let from = getTeam(by: sourceIndexPath)
    let to = getTeam(by: destinationIndexPath)
    let alert = UIAlertController(
      title: "Ineraction",
      message: "\(from.name) vs  \(to.name)",
      preferredStyle: .alert
    )
    alert.addAction(.init(title: "Ok", style: .cancel))
    self.present(alert, animated: true)
  }
}

// MARK: - UITableViewDataSource

extension TeamsListUIKitViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    groups.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groups[section].teams.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell") as? TeamCell
    else {
      return UITableViewCell()
    }

    let team = groups[indexPath.section].teams[indexPath.row]

    cell.render(
      TeamCell.Props(
        title: team.name,
        subtitle: team.venue.name,
        imageName: team.abbreviation
      )
    )
    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    groups[section].division.name
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let division = groups[section].division
    let header = HeaderView()
    header.render(
      props: HeaderView.Props(
        title: division.name,
        imageName: division.nameShort.uppercased()
      )
    )
    return header
  }

//  func tableView(
//    _ tableView: UITableView,
//    moveRowAt sourceIndexPath: IndexPath,
//    to destinationIndexPath: IndexPath
//  ) {
//    move(from: sourceIndexPath, to: destinationIndexPath)
//  }
}

// MARK: - UITableViewDragDelegate

extension TeamsListUIKitViewController: UITableViewDragDelegate {
  func tableView(
    _ tableView: UITableView,
    itemsForBeginning session: UIDragSession,
    at indexPath: IndexPath
  ) -> [UIDragItem] {
    backdrop.isHidden = false

    let item = UIDragItem(itemProvider: NSItemProvider())
    item.localObject = indexPath
    return [item]
  }

  func tableView(
    _ tableView: UITableView,
    dragPreviewParametersForRowAt indexPath: IndexPath
  ) -> UIDragPreviewParameters? {
    guard
      let cell = tableView.cellForRow(at: indexPath)
    else {
      return nil
    }
    let preview = UIDragPreviewParameters()
    preview.visiblePath = UIBezierPath(roundedRect: cell.bounds.insetBy(dx: 5, dy: 5), cornerRadius: 12)
    return preview
  }

}

// MARK: - UITableViewDragDelegate

extension TeamsListUIKitViewController: UITableViewDropDelegate {

  func tableView(
    _ tableView: UITableView,
    dropSessionDidUpdate session: UIDropSession,
    withDestinationIndexPath destinationIndexPath: IndexPath?
  ) -> UITableViewDropProposal {
    guard
      let item = session.items.first,
      let fromIndexPath = item.localObject as? IndexPath,
      let toIndexPath = destinationIndexPath
    else {
      backdrop.frame = .zero
      return UITableViewDropProposal(operation: .forbidden)
    }

    // Backdrop
    
    if let firstCell = tableView.cellForRow(at: toIndexPath) {
      let headerFrame = tableView.rectForHeader(inSection: toIndexPath.section)
      let newFrame = CGRect(
        x: headerFrame.minX,
        y: headerFrame.maxY + (CGFloat(toIndexPath.row) * firstCell.frame.height),
        width: firstCell.frame.width,
        height: firstCell.frame.height
      )

      if backdrop.frame == .zero {
        backdrop.frame = newFrame
      } else {
        UIView.animate(withDuration: 0.15) { [backdrop] in
          backdrop.frame = newFrame
        }
      }
    } else {
      backdrop.frame = .zero
    }

    if fromIndexPath.section == toIndexPath.section {
      return .init(operation: .move, intent: .automatic)
    }
    return UITableViewDropProposal(
      operation: .move,
      intent: .insertIntoDestinationIndexPath
    )
  }

  func tableView(
    _ tableView: UITableView,
    performDropWith coordinator: UITableViewDropCoordinator
  ) {
    guard
      let item = coordinator.session.items.first,
      let sourceIndexPath = item.localObject as? IndexPath,
      let destinationIndexPath = coordinator.destinationIndexPath
    else {
      return
    }

    switch coordinator.proposal.intent {
      case .insertAtDestinationIndexPath:
        move(from: sourceIndexPath, to: destinationIndexPath)
        coordinator.drop(item, toRowAt: destinationIndexPath)

      case .insertIntoDestinationIndexPath:
        interact(from: sourceIndexPath, to: destinationIndexPath)
        coordinator.drop(item, toRowAt: sourceIndexPath)

      default:
        break
    }

    // Backdrop

    backdrop.isHidden = true
    backdrop.frame = .zero
  }
}
