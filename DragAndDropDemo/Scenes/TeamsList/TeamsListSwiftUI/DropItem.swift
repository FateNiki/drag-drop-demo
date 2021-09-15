//
//  DropItem.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 15.09.2021.
//

import Foundation

class DropItem: NSObject, NSItemProviderWriting, Codable {
  static let identifier = "ru.udm.dragAndDrop.Item"
  static var writableTypeIdentifiersForItemProvider: [String] {
    [identifier]
  }

  let division: Division
  let team: Team

  init(
    division: Division,
    team: Team
  ) {
    self.division = division
    self.team = team
  }

  func loadData(
    withTypeIdentifier typeIdentifier: String,
    forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void
  ) -> Progress? {
    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      completionHandler(try encoder.encode(self), nil)
    } catch {
      completionHandler(nil, error)
    }

    return nil
  }
}
