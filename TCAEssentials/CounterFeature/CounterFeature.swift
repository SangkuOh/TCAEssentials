//
//  CounterFeature.swift
//  TCAEssentials
//
//  Created by sangku on 2/20/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CounterFeature {
  @ObservableState
  struct State: Equatable {
    var count = 0
    var fact: String?
    var isLoading = false
    var isTimerRunning = false
  }
  
  enum Action {
    case decrementButtonTapped
    case incrementButtonTapped
    case factButtonTapped
    case factResponse(String)
    case toggleTimerButtonTapped
    case timerTick
    case cancelButtonTapped
  }
  
  enum CancelID {
    case timer
    case fetch
  }
  
  @Dependency(\.continuousClock) var clock
  @Dependency(\.numberFact) var numberFact
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .decrementButtonTapped:
        state.count -= 1
        state.fact = nil
        return .none
        
      case .incrementButtonTapped:
        state.count += 1
        state.fact = nil
        return .none
        
      case .cancelButtonTapped:
        state.isLoading = false
        return .cancel(id: CancelID.fetch)
        
      case .factButtonTapped:
        state.fact = nil
        state.isLoading = true
        
        return .run { [count = state.count] send in
          try await Task.sleep(for: .seconds(3))
          let fact = try await numberFact.fetch(count)
          await send(
            .factResponse(fact),
            animation: .default
          )
        }
        .cancellable(id: CancelID.fetch)
        
      case let .factResponse(fact):
        state.fact = fact
        state.isLoading = false
        return .none
        
      case .toggleTimerButtonTapped:
        state.isTimerRunning.toggle()
        if state.isTimerRunning {
          return .run { send in
            for await _ in clock.timer(interval: .seconds(1)) {
              await send(.timerTick)
            }
          }
          .cancellable(id: CancelID.timer)
        } else {
          return .cancel(id: CancelID.timer)
        }
        
      case .timerTick:
        state.count += 1
        state.fact = nil
        return .none
      }
    }
  }
}
