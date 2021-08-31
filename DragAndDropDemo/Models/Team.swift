//
//  Team.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 31.08.2021.
//

import Foundation

struct Team: Decodable {
  let id: UInt
  let name: String
  var division: Division
}
