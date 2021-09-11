//
//  ViewController.swift
//  DragAndDropDemo
//
//  Created by Aleksey Nikitin on 30.08.2021.
//

import Combine
import UIKit
import SwiftUI

final class MainViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var toUIKitButton: UIButton!
  @IBOutlet weak var toSwiftUIButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    toUIKitButton.addTarget(self, action: #selector(toUIKit), for: .touchUpInside)
    toSwiftUIButton.addTarget(self, action: #selector(toSwiftUI), for: .touchUpInside)
  }
}

private extension MainViewController {
  @objc
  func toUIKit() {
    let uiKitController = TeamsListUIKitViewController()
    navigationController?.pushViewController(uiKitController, animated: true)
  }

  @objc
  func toSwiftUI() {
    let swiftView = TeamsListSwiftUI()
    let hostConntroller = UIHostingController(rootView: swiftView)
    navigationController?.pushViewController(hostConntroller, animated: true)
  }
}


