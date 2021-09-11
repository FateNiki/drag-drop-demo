//
//  TeamView.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 12.09.2021.
//

import SwiftUI

struct TeamView: View {
  let team: Team
  var body: some View {
    HStack(alignment: .center, spacing: 8) {
      ZStack {
        Circle()
          .fill(Color.white)
          .padding(8)
        Image(team.abbreviation)
          .resizable()
          .padding(18)
          .scaledToFit()
      }
      .frame(width: 80, height: 80, alignment: .leading)

      VStack(alignment: .leading) {
        Text(team.name)
        Text(team.venue.name)
      }

      Spacer(minLength: 8)
    }
  }
}

struct TeamView_Previews: PreviewProvider {
  static var previews: some View {
    TeamView(
      team: Team(
        id: 1,
        name: "New Yourk Rangers",
        abbreviation: "NYR",
        division: Division(id: 0, name: "", nameShort: ""),
        venue: Team.Venue(name: "Madison Square Garden")
      )
    )
    .previewLayout(.sizeThatFits)
//    .preferredColorScheme(.dark)
  }
}
