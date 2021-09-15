//
//  Team.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 31.08.2021.
//

import Foundation

struct Team: Codable, Identifiable, Equatable {
  static func == (lhs: Team, rhs: Team) -> Bool {
    lhs.id == rhs.id
  }

  let id: UInt
  let name: String
  let abbreviation: String
  var division: Division
  let venue: Venue

  struct Venue: Codable {
    let name: String
  }
}
