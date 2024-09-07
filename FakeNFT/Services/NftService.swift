import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void

protocol NftServiceProtocol {
    func loadNft(id: String, completion: @escaping NftCompletion)
}

final class NftService: NftServiceProtocol {

    private let networkClient: NetworkClient
    private let storage: NftStorageProtocol

    init(networkClient: NetworkClient, storage: NftStorageProtocol) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
