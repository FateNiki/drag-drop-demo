//
//  Group.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 12.09.2021.
//

import Foundation

struct Group: Identifiable {
  var id: String { "division_\(division.id)" }

  let division: Division
  var teams: [Team]
}
