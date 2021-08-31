//
//  ViewController.swift
//  DragAndDropDemo
//
//  Created by Aleksey Nikitin on 30.08.2021.
//

import Combine
import UIKit

class ViewController: UIViewController {
  var cancellable: AnyCancellable?

  override func viewDidLoad() {
    super.viewDidLoad()
    let teams = TeamsService()
      .fetch()
      .map { teams in teams.map { $0.id } }

    let division = DivisionService()
      .fetch()
      .map { divisions in divisions.map { $0.id } }

    cancellable = Publishers.CombineLatest(teams, division)
      .sink(receiveCompletion: {
        print($0)
      }, receiveValue: { teams, divisions in
        print(teams, divisions)
      })

    // Do any additional setup after loading the view.
  }
}


