//
//  CounterFeatureTest.swift
//  TCAEssentialsTests
//
//  Created by sangku on 2/20/24.
//

@testable import TCAEssentials
import ComposableArchitecture
import XCTest

@MainActor
final class CounterFeatureTests: XCTestCase {
  func testCounter() async {
    let clock = TestClock()
    let store = TestStore(initialState: CounterFeature.State()) {
      CounterFeature()
    } withDependencies: {
      $0.continuousClock = clock
    }

    await store.send(.incrementButtonTapped) {
      $0.count = 1
    }
    await clock.advance(by: .seconds(1))
    await store.send(.timerTick) {
      $0.count = 2
    }
    await store.send(.decrementButtonTapped) {
      $0.count = 1
    }
  }
  
  
  
  func testNumberFact() async {
    func numberFactFetch(number: Int) -> String {
      "\(number) is a good number."
    }
    let store = TestStore(initialState: CounterFeature.State()) {
      CounterFeature()
    } withDependencies: {
      $0.numberFact.fetch = { numberFactFetch(number: $0)}
    }
    await store.send(.factButtonTapped) {
      $0.isLoading = true
    }
    await store.receive(\.factResponse, timeout: .seconds(1)) {
      $0.fact = numberFactFetch(number: 0)
      $0.isLoading = false
    }
  }
}
