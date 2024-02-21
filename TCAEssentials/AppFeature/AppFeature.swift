//
//  AppFeature.swift
//  TCAEssentials
//
//  Created by sangku on 2/20/24.
//

import ComposableArchitecture

@Reducer
struct AppFeature {
  @ObservableState
  struct State: Equatable {
    var tab1: CounterFeature.State = .init()
    var tab2: CounterFeature.State = .init()
  }
  enum Action {
    case tab1(CounterFeature.Action)
    case tab2(CounterFeature.Action)
  }
  var body: some ReducerOf<Self> {
    Scope(state: \.tab1, action: \.tab1) {
      CounterFeature()
    }
    Scope(state: \.tab2, action: \.tab2) {
      CounterFeature()
    }
    Reduce { state, action in
      return .none
    }
    ._printChanges()
  }
}
