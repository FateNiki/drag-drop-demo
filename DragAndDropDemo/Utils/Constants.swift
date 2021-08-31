//
//  Constants.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 31.08.2021.
//

import Foundation

enum Constants {
  static let teamEndpoint: URL = URL(string: "https://statsapi.web.nhl.com/api/v1/teams")!
  static let divisionEndpoint: URL = URL(string: "https://statsapi.web.nhl.com/api/v1/divisions")!
  static let teamLogoEndpoint: URL = URL(string: "https://www-league.nhlstatic.com/images/logos/teams-current-primary-light")!
}
