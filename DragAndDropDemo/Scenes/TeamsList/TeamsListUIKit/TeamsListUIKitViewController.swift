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
}
