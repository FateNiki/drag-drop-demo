//
//  TeamsViewModel.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 12.09.2021.
//

import Combine
import Foundation

final class TeamsViewModel: ObservableObject {
  private let useCase: TeamsUseCase
  private var cancellations: Array<AnyCancellable> = []

  @Published var groups: [Group] = []

  init(
    useCase: TeamsUseCase
  ) {
    self.useCase = useCase
  }

  func loadData() {
    useCase.getGroup()
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { groups in
        self.groups = groups
      })
      .store(in: &cancellations)
  }
}
