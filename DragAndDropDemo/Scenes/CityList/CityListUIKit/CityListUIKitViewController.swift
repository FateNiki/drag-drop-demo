//
//  CityListUIKitViewController.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 31.08.2021.
//

import UIKit
import Combine

private struct Group {
  let division: Division
  let teams: [Team]
}

final class CityListUIKitViewController: UIViewController {
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

private extension CityListUIKitViewController {
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
    let loading = useCase.getTeams().share()
    loading
      .map { teams -> [Division: [Team]] in
        var groups: [Division: [Team]] = [:]
        for team in teams {
          groups[team.division] = groups[team.division] ?? []
          groups[team.division]?.append(team)
        }
        return groups
      }
      .map {
        var groups = [Group]()
        for (division, teams) in $0 {
          groups.append(Group(division: division, teams: teams))
        }
        return groups
      }
      .assign(to: \CityListUIKitViewController.groups, on: self)
      .store(in: &cancellable)

    loading
      .receive(on: DispatchQueue.main)
      .sink { [tableView] _ in
        tableView.reloadData()
      }
      .store(in: &cancellable)
  }
}

// MARK: - Private methods

extension CityListUIKitViewController: UITableViewDataSource {
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
        subtitle: team.name,
        imageName: team.name
      )
    )
    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    groups[section].division.name
  }
}
