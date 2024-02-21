//
//  ContactsView.swift
//  TCAEssentials
//
//  Created by sangku on 2/20/24.
//

import ComposableArchitecture
import SwiftUI

struct ContactsView: View {
  @Bindable var store: StoreOf<ContactsFeature>
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(store.contacts) { contact in
          HStack {
            Text(contact.name)
            Spacer()
            Button {
              store.send(.deleteButtonTapped(id: contact.id))
            } label: {
              Image(systemName: "trash")
                .foregroundColor(.red)
            }
          }
        }
      }
      .navigationTitle("Contacts")
      .toolbar {
        ToolbarItem {
          Button {
            store.send(.addButtonTapped)
          } label: {
            Image(systemName: "plus")
          }
        }
      }
    }
    .sheet(
      item: $store.scope(state: \.destination?.addContact, action: \.destination.addContact)
    ) { addContactStore in
      NavigationStack {
        AddContactView(store: addContactStore)
      }
    }
    .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
  }
}

#Preview {
  ContactsView(
    store: Store(
      initialState: ContactsFeature.State(
        contacts: [
          Contact(id: UUID(), name: "Blob"),
          Contact(id: UUID(), name: "Blob Jr"),
          Contact(id: UUID(), name: "Blob Sr"),
        ]
      )
    ) {
      ContactsFeature()
    }
  )
}

