//
//  BakeryStorageService.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/05/03.
//

import SwiftData

protocol BakeryStorageServiceProtocol {
    func fetchBakeryPostDrafts(of placeID: String) -> [BakeryPostDraft]
    func insertBakeryPostDraft(_ bakeryPost: BakeryPostDraft)
    func deleteBakeryPostDraft(_ bakeryPost: BakeryPostDraft)
    func updateBakeryPostDraft()
    func saveBread(_ bread: SavedBread)
    func getSavedBreads() -> [SavedBread]
    func unsaveBread(_ bread: SavedBread)
    func updateSavedBread()
    func resetData(completion: @escaping (Result<Void, Error>) -> Void)
}

final class BakeryStorageService: BakeryStorageServiceProtocol {
    // MARK: Private Properties
    private var container: ModelContainer?
    private var context: ModelContext?
    private let authNetworkService: AuthNetworkServiceProtocol

    init(authNetworkService: AuthNetworkService = AuthNetworkService.shared) {
        self.authNetworkService = authNetworkService
        do {
            let schema = Schema([BakeryPostDraft.self, SavedBread.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: modelConfiguration)
            guard let container else { return }
            context = ModelContext(container)
        } catch {
            print(error)
        }
    }

    func fetchBakeryPostDrafts(of placeID: String) -> [BakeryPostDraft] {
        let postDrafts = (try? context?.fetch(FetchDescriptor<BakeryPostDraft>())) ?? []
        return postDrafts.filter {
            $0.uid == authNetworkService.currentUser?.uid && $0.placeID == placeID
        }
    }

    func insertBakeryPostDraft(_ bakeryPost: BakeryPostDraft) {
        context?.insert(bakeryPost)
        try? context?.save()
    }

    func deleteBakeryPostDraft(_ bakeryPost: BakeryPostDraft) {
        context?.delete(bakeryPost)
        try? context?.save()
    }

    func updateBakeryPostDraft() {
        try? context?.save()
    }

    func saveBread(_ bread: SavedBread) {
        context?.insert(bread)
        try? context?.save()
    }

    func getSavedBreads() -> [SavedBread] {
        let savedBreads = (try? context?.fetch(FetchDescriptor<SavedBread>())) ?? []
        return savedBreads.filter {
            $0.uid == authNetworkService.currentUser?.uid
        }
    }

    func unsaveBread(_ bread: SavedBread) {
        context?.delete(bread)
        try? context?.save()
    }

    func updateSavedBread() {
        try? context?.save()
    }

    func resetData(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let postDrafts = (try? context?.fetch(FetchDescriptor<BakeryPostDraft>()))?.filter {
                $0.uid == authNetworkService.currentUser?.uid
            }
            let savedBreads = (try? context?.fetch(FetchDescriptor<SavedBread>()))?.filter {
                $0.uid == authNetworkService.currentUser?.uid
            }
            postDrafts?.forEach {
                context?.delete($0)
            }
            savedBreads?.forEach {
                context?.delete($0)
            }
            try context?.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
