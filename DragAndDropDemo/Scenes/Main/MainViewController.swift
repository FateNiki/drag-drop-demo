//
//  ViewController.swift
//  DragAndDropDemo
//
//  Created by Aleksey Nikitin on 30.08.2021.
//

import Combine
import UIKit

final class MainViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var toUIKitButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    toUIKitButton.addTarget(self, action: #selector(toUIKit), for: .touchUpInside)
  }
}

private extension MainViewController {
  @objc
  func toUIKit() {
    let uiKitController = CityListUIKitViewController()
    navigationController?.pushViewController(uiKitController, animated: true)
  }
}


