//
//  ContactDetailView.swift
//  TCAEssentials
//
//  Created by sangku on 2/21/24.
//

import SwiftUI
import ComposableArchitecture

struct ContactDetailView: View {
  let store: StoreOf<ContacDetailFeature>
  
  var body: some View {
    Form {
      
    }
    .navigationTitle(store.contact.name)
  }
}

#Preview {
  NavigationStack {
    ContactDetailView(
      store: .init(
      initialState: ContacDetailFeature.State(
        contact: .init(id: .init(), name: "Blob Jr."))) {
          ContacDetailFeature()
        }
    )
  }
}
