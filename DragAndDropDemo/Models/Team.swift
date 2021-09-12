//
//  Team.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 31.08.2021.
//

import Foundation

struct Team: Decodable, Identifiable {
  let id: UInt
  let name: String
  let abbreviation: String
  var division: Division
  let venue: Venue

  struct Venue: Decodable {
    let name: String
  }
}
