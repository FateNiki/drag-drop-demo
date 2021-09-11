//
//  TeamsUseCase.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 11.09.2021.
//

import Foundation
import Combine

final class TeamsUseCase {
  private let teamsService = TeamsService()
  private let empty: [Team] = []

  public func getTeams() -> AnyPublisher<[Team], Never> {
    teamsService.fetch()
      .replaceError(with: empty)
      .eraseToAnyPublisher()
  }
}
