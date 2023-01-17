//
//  FatClient.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/17.
//

import ComposableArchitecture
import Foundation

struct FactClient {
    var fetch: @Sendable (Int) async throws -> String
}

extension DependencyValues {
    var factClient: FactClient {
        get { self[FactClient.self] }
        set { self[FactClient.self] = newValue }
    }
}

extension FactClient: DependencyKey {
    static let liveValue = Self { number in
        try await Task.sleep(nanoseconds: NSEC_PER_SEC)
        let (data, _) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(number)/trivia")!)
        return String(decoding: data, as: UTF8.self)
    }
}
