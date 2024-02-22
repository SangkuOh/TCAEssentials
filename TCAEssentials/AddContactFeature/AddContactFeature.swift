//
//  AddContactFeature.swift
//  TCAEssentials
//
//  Created by sangku on 2/20/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AddContactFeature {
  @ObservableState
  struct State: Equatable {
    var contact: Contact
  }
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case cancelButtonTapped
    case saveButtonTapped
    case delegate(Delegate)
    
    @CasePathable
    enum Delegate: Equatable {
      case cancel
      case saveContact(Contact)
    }
  }
  @Dependency(\.dismiss) var dismiss
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .cancelButtonTapped:
        return .run { _ in await dismiss() }
        
      case .saveButtonTapped:
        return .run { [Contact = state.contact] send in
          await send(.delegate(.saveContact(Contact)))
          await dismiss()
        }
        
      case .delegate:
        return .none
      }
    }
  }
}
