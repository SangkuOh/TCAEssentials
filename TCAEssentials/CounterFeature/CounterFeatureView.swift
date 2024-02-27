//
//  CounterFeatureView.swift
//  TCAEssentials
//
//  Created by sangku on 2/20/24.
//

import ComposableArchitecture
import SwiftUI

struct CounterView: View {
  let store: StoreOf<CounterFeature>
  @State var isLoading = false
  var body: some View {
    List {
      Text("\(store.count)")
        .font(.largeTitle)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
      HStack {
        Button("-") {
          store.send(.decrementButtonTapped)
        }
        .font(.largeTitle)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
        
        Button("+") {
          store.send(.incrementButtonTapped)
        }
        .font(.largeTitle)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
      }
      Button(store.isTimerRunning ? "Stop timer" : "Start timer") {
        store.send(.toggleTimerButtonTapped)
      }
      .font(.largeTitle)
      .padding()
      .background(Color.black.opacity(0.1))
      .cornerRadius(10)
      Button("Fact") {
        store.send(.factButtonTapped)
      }
      .font(.largeTitle)
      .padding()
      .background(.black.opacity(0.1))
      .cornerRadius(10)
      Button("Cancel") {
        store.send(.cancelButtonTapped)
      }
      .buttonStyle(.borderedProminent)
      
      if store.isLoading {
        ProgressView()
      } else if let fact = store.fact {
        Text(fact)
          .font(.largeTitle)
          .multilineTextAlignment(.center)
          .padding()
      }
    }
    .refreshable {
      isLoading = true
      defer { isLoading = false }
      await store.send(.factButtonTapped).finish()
    }
  }
}

#Preview {
  CounterView(store: .init(initialState: CounterFeature.State()) {
    CounterFeature() })
}
