//
//  TeamDropDelegate.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 15.09.2021.
//

import SwiftUI

struct TeamsDropDelegate: DropDelegate {
  let droppedItem: DropItem
  @Binding var draggedItem: DropItem?
  @Binding var items: [Group]

  func dropEntered(info: DropInfo) {
    guard let draggedItem = self.draggedItem else {
      return
    }

    guard
      draggedItem.team != droppedItem.team,
      draggedItem.division.id == droppedItem.division.id,
      let divisionIndex = items.firstIndex(where: { $0.division.id == draggedItem.division.id }),
      let from = items[divisionIndex].teams.firstIndex(of: draggedItem.team),
      let to = items[divisionIndex].teams.firstIndex(of: droppedItem.team)
    else {
      return
    }

    withAnimation(.default) {
      self.items[divisionIndex].teams.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
    }
  }

  func performDrop(info: DropInfo) -> Bool {
    draggedItem = nil
    return true
  }

  func dropUpdated(info: DropInfo) -> DropProposal? {
    return DropProposal(operation: .copy)
  }
}
