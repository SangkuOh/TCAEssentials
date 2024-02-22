//
//  ContactDetailView.swift
//  TCAEssentials
//
//  Created by sangku on 2/21/24.
//

import SwiftUI
import ComposableArchitecture

struct ContactDetailView: View {
  @Bindable var store: StoreOf<ContactDetailFeature>
  
  var body: some View {
    Form {
      Button("Delete") {
        store.send(.deleteButtonTapped)
      }
    }
    .navigationTitle(store.contact.name)
    .alert($store.scope(state: \.alert, action: \.alert))
  }
}

#Preview {
  NavigationStack {
    ContactDetailView(
      store: .init(
      initialState: ContactDetailFeature.State(
        contact: .init(id: .init(), name: "Blob Jr."))) {
          ContactDetailFeature()
        }
    )
  }
}
