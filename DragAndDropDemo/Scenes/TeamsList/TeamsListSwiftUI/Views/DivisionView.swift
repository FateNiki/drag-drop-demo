//
//  DivisionView.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 12.09.2021.
//

import SwiftUI

struct DivisionView: View {
  let division: Division

  var body: some View {
    HStack {
      Text(division.name)
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
      Spacer()
      Image(division.nameShort.uppercased())
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 64, height: 64, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
  }
}

struct DivisionView_Previews: PreviewProvider {
  static var previews: some View {
    DivisionView(division:
      Division(
        id: 1,
        name: "Pacific",
        nameShort: "PAC"
      )
    )
    .previewLayout(
      .sizeThatFits
    )
  }
}
