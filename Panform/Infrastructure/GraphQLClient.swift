//
//  GraphQLClient.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/05/04.
//

import Apollo
import Foundation

final class GraphQLClient {
    
    static let shared = GraphQLClient()
    
    let apollo = {
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let client = URLSessionClient()
        let provider = DefaultInterceptorProvider(client: client, store: store)
        let url = URL(string: "https://panform-db.hasura.app/v1/graphql")!
        let token = ""
        let transport = RequestChainNetworkTransport(
            interceptorProvider: provider,
            endpointURL: url,
            additionalHeaders: ["x-hasura-admin-secret": "\(token)"]
        )
        return ApolloClient(networkTransport: transport, store: store)
    }()
    
    private init() {}
}
