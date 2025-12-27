import Foundation
import StorageLibrary
import Testing
@testable import VideosLibrary
import YouTubeLibrary

@Suite("VideosViewModel Tests")
@MainActor
struct VideosViewModelTests {

    // MARK: - Initial State Tests

    @Test("Should start with home option")
    func initialOptionIsHome() {
        let storage = Database(models: [VideoDB.self], inMemory: true)
        let sut = VideosViewModel(storage: storage)

        #expect(sut.options == .home)
    }

    @Test("Should start with loading status")
    func initialStatusIsLoading() {
        let storage = Database(models: [VideoDB.self], inMemory: true)
        let sut = VideosViewModel(storage: storage)

        #expect(sut.status == .loading)
    }

    // MARK: - Options Tests

    @Test("Should support search option with text")
    func supportsSearchOption() {
        let storage = Database(models: [VideoDB.self], inMemory: true)
        let sut = VideosViewModel(storage: storage)

        sut.options = .search(text: "Apple Event")

        if case .search(let text) = sut.options {
            #expect(text == "Apple Event")
        } else {
            Issue.record("Expected search option")
        }
    }

    @Test("Should support empty search text")
    func supportsEmptySearchText() {
        let storage = Database(models: [VideoDB.self], inMemory: true)
        let sut = VideosViewModel(storage: storage)

        sut.options = .search(text: "")

        if case .search(let text) = sut.options {
            #expect(text.isEmpty)
        } else {
            Issue.record("Expected search option")
        }
    }

    @Test("Should transition between home and search options")
    func transitionBetweenOptions() {
        let storage = Database(models: [VideoDB.self], inMemory: true)
        let sut = VideosViewModel(storage: storage)

        #expect(sut.options == .home)

        sut.options = .search(text: "iPhone")
        if case .search(let text) = sut.options {
            #expect(text == "iPhone")
        } else {
            Issue.record("Expected search option")
        }

        sut.options = .home
        #expect(sut.options == .home)
    }

    @Test("Options should be equatable")
    func optionsEquatable() {
        #expect(VideosViewModel.Options.home == .home)
        #expect(VideosViewModel.Options.search(text: "test") == .search(text: "test"))
        #expect(VideosViewModel.Options.search(text: "a") != .search(text: "b"))
        #expect(VideosViewModel.Options.home != .search(text: "test"))
    }

    // MARK: - Status Tests

    @Test("Should update status")
    func updateStatus() {
        let storage = Database(models: [VideoDB.self], inMemory: true)
        let sut = VideosViewModel(storage: storage)

        sut.status = .done

        #expect(sut.status == .done)
    }

    @Test("Should support idle status")
    func supportsIdleStatus() {
        let storage = Database(models: [VideoDB.self], inMemory: true)
        let sut = VideosViewModel(storage: storage)

        sut.status = .idle

        #expect(sut.status == .idle)
    }

    @Test("Should support error status with reason")
    func supportsErrorStatus() {
        let storage = Database(models: [VideoDB.self], inMemory: true)
        let sut = VideosViewModel(storage: storage)

        sut.status = .error(reason: "Network error")

        if case .error(let reason) = sut.status {
            #expect(reason == "Network error")
        } else {
            Issue.record("Expected error status")
        }
    }

    // MARK: - Search Text Edge Cases

    @Test("Should handle special characters in search text")
    func specialCharactersInSearch() {
        let storage = Database(models: [VideoDB.self], inMemory: true)
        let sut = VideosViewModel(storage: storage)

        sut.options = .search(text: "iPhone 16 Pro & Apple Watch")

        if case .search(let text) = sut.options {
            #expect(text == "iPhone 16 Pro & Apple Watch")
        } else {
            Issue.record("Expected search option")
        }
    }

    @Test("Should handle unicode characters in search text")
    func unicodeInSearch() {
        let storage = Database(models: [VideoDB.self], inMemory: true)
        let sut = VideosViewModel(storage: storage)

        sut.options = .search(text: "Notícias Apple 🍎")

        if case .search(let text) = sut.options {
            #expect(text == "Notícias Apple 🍎")
        } else {
            Issue.record("Expected search option")
        }
    }

    @Test("Should handle very long search text")
    func longSearchText() {
        let storage = Database(models: [VideoDB.self], inMemory: true)
        let sut = VideosViewModel(storage: storage)

        let longText = String(repeating: "a", count: 1000)
        sut.options = .search(text: longText)

        if case .search(let text) = sut.options {
            #expect(text.count == 1000)
        } else {
            Issue.record("Expected search option")
        }
    }
}
