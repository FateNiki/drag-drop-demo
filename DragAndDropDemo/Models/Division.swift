//
//  Division.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 31.08.2021.
//

import Foundation

struct Division: Decodable, Hashable {
  let id : UInt
  let name: String
  let nameShort: String

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
