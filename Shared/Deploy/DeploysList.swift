//
//  DeploysList.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 10.03.2021.
//

import SwiftUI

struct DeploysList: View {
    @State private var deploysLoadingState: LoadingState<[Deploy]> = .loading(Array(repeating: .placeholder, count: 10))
    
    let siteId: String
    
    private func listSiteDeploys() {
        Endpoint.api.fetch(.deploys(siteId: siteId)) { (result: Result<[Deploy], ApiError>) in
            switch result {
            case let .success(value):
                deploysLoadingState = .success(value)
            case let .failure(error):
                deploysLoadingState = .failure(error)
            }
        }
    }
    
    var body: some View {
        LoadingView(
            loadingState: $deploysLoadingState,
            failure: { error in
                FailureView(error.localizedDescription, action: listSiteDeploys)
            }
        ) { deploys in
            List {
                ForEach(deploys, id: \.id, content: DeployItems.init)
            }
            .listStyle(InsetGroupedListStyle())
        }
        .onAppear(perform: listSiteDeploys)
        .navigationTitle("navigation_title_deploys")
    }
}
