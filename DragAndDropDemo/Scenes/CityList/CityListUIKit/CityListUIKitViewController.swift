//
//  CityListUIKitViewController.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 31.08.2021.
//

import UIKit

final class CityListUIKitViewController: UIViewController {
  private let tableView = UITableView()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    configure()
    setupTable()
    setupNavigation()
    setupConstraints()
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
  }

  func setupConstraints() {
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}

// MARK: - Private methods

extension CityListUIKitViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    10
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    UITableViewCell()
  }
}

