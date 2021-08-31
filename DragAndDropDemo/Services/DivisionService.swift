//
//  DivisionService.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 31.08.2021.
//

import Combine
import Foundation

private struct DivisionResponse: Decodable {
  let divisions: [Division]
}

final class DivisionService {
  private let repo = Repository<DivisionResponse>(endpoint: Constants.divisionEndpoint)

  func fetch() -> AnyPublisher<[Division], Error> {
    return repo.fetch()
      .map { $0.divisions }
      .eraseToAnyPublisher()
  }
}
