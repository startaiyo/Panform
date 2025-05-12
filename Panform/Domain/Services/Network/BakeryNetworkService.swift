//
//  BakeryNetworkService.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/05/07.
//

import FirebaseStorage
import Foundation

protocol BakeryNetworkServiceProtocol {
    func fetchBakeries() -> [BakeryPostDraft]
    func insertBakery(_ bakery: BakeryModel)
    func deleteBakery(_ bakeryID: BakeryID)
    func updateBakery(_ bakery: BakeryModel)
    func uploadImages(_ bakery: BakeryPostDraft,
                      completion: @escaping ([URL]) -> Void)
}

final class BakeryNetworkService {
    private let storageService: Storage

    init(storageService: Storage = Storage.storage()) {
        self.storageService = storageService
    }
}

// MARK: - BakeryNetworkServiceProtocol
extension BakeryNetworkService: BakeryNetworkServiceProtocol {
    func fetchBakeries() -> [BakeryPostDraft] {
        return []
    }

    func insertBakery(_ bakery: BakeryModel) {}

    func deleteBakery(_ bakeryID: BakeryID) {}

    func updateBakery(_ bakery: BakeryModel) {}

    func uploadImages(_ bakery: BakeryPostDraft,
                      completion: @escaping ([URL]) -> Void) {
        let storage = Storage.storage()
        let group = DispatchGroup()
        var urls: [URL] = []
        for image in bakery.draftImages {
            group.enter()
            let imageRef = storage.reference().child("bread_photos/\(image.id).jpg")

            imageRef.putData(image.imageData, metadata: nil) { metadata, error in
                guard error == nil else {
                    print("Failed to upload image: \(error!)")
                    group.leave()
                    return
                }

                imageRef.downloadURL { url, error in
                    if let url {
                        urls.append(url)
                    } else {
                        print("Failed to get download URL: \(error!)")
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            completion(urls)
        }
    }
}
