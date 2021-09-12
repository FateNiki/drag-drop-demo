//
//  TeamsListSwiftUI.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 12.09.2021.
//

import SwiftUI

struct TeamsListSwiftUI: View {
  @ObservedObject var viewModel: TeamsViewModel

  var body: some View {
    ScrollView {
      LazyVStack(spacing: 0) {
        ForEach(viewModel.groups) { group in
          Section(header: DivisionView(division: group.division)) {
            Divider()
              .background(Color.gray)
            ForEach(group.teams) { team in
              TeamView(team: team)
              Divider()
                .background(Color.gray)
                .padding(.leading, 16)
            }
          }
        }
      }
    }
    .onAppear(perform: {
      viewModel.loadData()
    })
    .navigationTitle("SwiftUI")
    .navigationBarTitle("SwiftUI", displayMode: .inline)
  }
}

struct TeamsListSwiftUI_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      TeamsListSwiftUI(
        viewModel: TeamsViewModel(
          useCase: TeamsUseCase()
        )
      )
    }
  }
}
