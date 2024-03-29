//
//  AddContactView.swift
//  TCAEssentials
//
//  Created by sangku on 2/20/24.
//

import ComposableArchitecture
import SwiftUI

struct AddContactView: View {
  @Bindable var store: StoreOf<AddContactFeature>
  @FocusState var focusedField: AddContactFeature.State.Field?
  
  var body: some View {
    Form {
      TextField("Name", text: $store.contact.name)
        .focused($focusedField, equals: .name)
      Button("Save") {
        store.send(.saveButtonTapped)
      }
    }
    .bind($store.focusedField, to: $focusedField)
    .toolbar {
      Button("Cancel") {
        store.send(.cancelButtonTapped)
      }
    }
  }
}

#Preview {
  NavigationStack {
    AddContactView(
      store: Store(initialState: AddContactFeature.State(contact: .init(id: .init(), name: "John"))) {
        AddContactFeature()
      }
    )
  }
}
