//
//  ContactFeature.swift
//  TCAEssentials
//
//  Created by sangku on 2/20/24.
//

import Foundation
import ComposableArchitecture
import SwiftUINavigationCore

@Reducer
struct ContactsFeature {
  @ObservableState
  struct State: Equatable {
    var contacts: IdentifiedArrayOf<Contact> = []
    @Presents var destination: Destination.State?
    var path = StackState<Path.State>()
  }
  enum Action {
    case addButtonTapped
    case deleteButtonTapped(id: Contact.ID)
    case destination(PresentationAction<Destination.Action>)
    case path(StackAction<Path.State, Path.Action>)
    case navigationButtonTapped(contact: Contact)
    enum Alert: Equatable {
      case confirmDeletion(id: Contact.ID)
    }
  }
  @Dependency(\.uuid) var uuid
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        state.destination = .addContact(
          AddContactFeature.State(
            contact: Contact(id: self.uuid(), name: "")
          )
        )
        return .none
        
      case let .destination(.presented(.addContact(.delegate(.saveContact(contact))))):
        state.contacts.append(contact)
        return .none
        
      case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
        state.contacts.remove(id: id)
        return .none
        
      case .destination:
        return .none
        
      case let .deleteButtonTapped(id: id):
        state.destination = .alert(.deleteConfirmation(id: id))
        return .none
        
      case let .navigationButtonTapped(contact):
        state.path.append(.detail(.init(contact: contact)))
        return .none
        
      case let .path(.element(id: id, action: .detail(.delegate(.confirmDeletion)))):
        guard let detailState = state.path[id: id]?.detail else {
          return .none
        }
        state.contacts.remove(id: detailState.contact.id)
        return .none
        
      case .path:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
    .forEach(\.path, action: \.path)
  }
}

extension ContactsFeature {
  @Reducer(state: .equatable)
  enum Destination {
    case addContact(AddContactFeature)
    case alert(AlertState<ContactsFeature.Action.Alert>)
  }
  @Reducer(state: .equatable)
  enum Path {
    case detail(ContactDetailFeature)
  }
}

extension AlertState where Action == ContactsFeature.Action.Alert {
  static func deleteConfirmation(id: UUID) -> Self {
    Self {
      TextState("Are you sure?")
    } actions: {
      ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
        TextState("Delete")
      }
    }
  }
}
