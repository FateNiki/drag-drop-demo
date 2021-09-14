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

  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    false
  }
}

// MARK: - UITableViewDragDelegate

extension TeamsListUIKitViewController: UITableViewDragDelegate {
  func tableView(
    _ tableView: UITableView,
    itemsForBeginning session: UIDragSession,
    at indexPath: IndexPath
  ) -> [UIDragItem] {
    let item = UIDragItem(itemProvider: NSItemProvider())
    item.localObject = indexPath
    return [item]
  }
}

// MARK: - UITableViewDragDelegate

extension TeamsListUIKitViewController: UITableViewDropDelegate {

  func tableView(
    _ tableView: UITableView,
    dropSessionDidUpdate session: UIDropSession,
    withDestinationIndexPath destinationIndexPath: IndexPath?
  ) -> UITableViewDropProposal {
    let toIndexPath: IndexPath

    if let indexPath = destinationIndexPath {
      toIndexPath = indexPath
    } else {
      let section = tableView.numberOfSections - 1
      let row = tableView.numberOfRows(inSection: section)
      toIndexPath = IndexPath(row: row, section: section)
    }

    guard
      let item = session.items.first,
      let fromIndexPath = item.localObject as? IndexPath
    else {
      return UITableViewDropProposal(operation: .forbidden)
    }

    if fromIndexPath.section == toIndexPath.section {
      return .init(operation: .move, intent: .automatic)
    }
    return UITableViewDropProposal(operation: .copy, intent: .insertIntoDestinationIndexPath)
  }


  func tableView(
    _ tableView: UITableView,
    moveRowAt sourceIndexPath: IndexPath,
    to destinationIndexPath: IndexPath
  ) {
      move(from: sourceIndexPath, to: destinationIndexPath)
  }

  func tableView(
    _ tableView: UITableView,
    performDropWith coordinator: UITableViewDropCoordinator
  ) {
    let destinationIndexPath: IndexPath

    if let indexPath = coordinator.destinationIndexPath {
      destinationIndexPath = indexPath
    } else {
      let section = tableView.numberOfSections - 1
      let row = tableView.numberOfRows(inSection: section)
      destinationIndexPath = IndexPath(row: row, section: section)
    }

    guard
      let item = coordinator.session.items.first,
      let sourceIndexPath = item.localObject as? IndexPath
    else {
      return
    }

    switch coordinator.proposal.operation {
      case .copy:
        interact(from: sourceIndexPath, to: destinationIndexPath)

      case .move:
        move(from: sourceIndexPath, to: destinationIndexPath)

      default:
        break
    }
  }
}
