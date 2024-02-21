//
//  TCAEssentialsApp.swift
//  TCAEssentials
//
//  Created by sangku on 2/20/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCAEssentialsApp: App {
  @State var store: Store = .init(initialState: ContactsFeature.State()) {
    ContactsFeature()
      ._printChanges()
  }
  
  var body: some Scene {
    WindowGroup {
      ContactsView(store: store)
    }
  }
}
