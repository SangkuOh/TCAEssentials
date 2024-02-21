//
//  ContactDetailFeature.swift
//  TCAEssentials
//
//  Created by sangku on 2/21/24.
//

import ComposableArchitecture

@Reducer
struct ContacDetailFeature {
  @ObservableState
  struct State: Equatable {
    let contact: Contact
  }
  enum Action {
    
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      }
    }
  }
}
