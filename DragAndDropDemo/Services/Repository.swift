//
//  Repository.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 31.08.2021.
//

import Combine
import Foundation

final class Repository<T: Decodable> {
  private let endpoint: URL

  init(endpoint: URL) {
    self.endpoint = endpoint
  }

  public func fetch() -> AnyPublisher<T, Error> {
    return URLSession.shared
      .dataTaskPublisher(for: endpoint)
      .tryMap() { element -> Data in
        guard let httpResponse = element.response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
        return element.data
      }
      .decode(type: T.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }
}
