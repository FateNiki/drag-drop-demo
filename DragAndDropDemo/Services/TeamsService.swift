//
//  TeamsService.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 31.08.2021.
//

import Combine
import Foundation

private struct TeamsResponce: Decodable {
  let teams: [Team]
}

final class TeamsService {
  private let repo = Repository<TeamsResponce>(endpoint: Constants.teamEndpoint)

  func fetch() -> AnyPublisher<[Team], Error> {
    return repo.fetch()
      .map { $0.teams }
      .eraseToAnyPublisher()
  }
}
