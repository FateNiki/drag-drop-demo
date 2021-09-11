//
//  TeamsListSwiftUI.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 12.09.2021.
//

import SwiftUI

struct TeamsListSwiftUI: View {
  var body: some View {
    let columns: [GridItem] = [
      GridItem(.flexible(minimum: 0, maximum: .infinity))
    ]
    ScrollView {
      LazyVGrid(columns: columns) {
        ForEach((0...79), id: \.self) {
          let codepoint = $0 + 0x1f600
          let codepointString = String(format: "%02X", codepoint)
          Text("\(codepointString)")
        }
      }
    }
  }
}

struct TeamsListSwiftUI_Previews: PreviewProvider {
  static var previews: some View {
    TeamsListSwiftUI()
  }
}
