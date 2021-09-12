//
//  TeamsUseCase.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 11.09.2021.
//

import Foundation
import Combine

final class TeamsUseCase {
  private let teamsService = TeamsService()
  private let empty: [Group] = []

  public func getGroup() -> AnyPublisher<[Group], Never> {
    teamsService.fetch()
      .map { teams -> [Division: [Team]] in
        var groups: [Division: [Team]] = [:]
        for team in teams {
          groups[team.division] = groups[team.division] ?? []
          groups[team.division]?.append(team)
        }
        return groups
      }
      .map { groupedTeams -> [Group] in
        var groups = [Group]()
        for (division, teams) in groupedTeams {
          groups.append(Group(division: division, teams: teams))
        }
        return groups
      }
      .replaceError(with: empty)
      .eraseToAnyPublisher()
  }
}
