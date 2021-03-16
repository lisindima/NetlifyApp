//
//  DeployDetails.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 12.03.2021.
//

import SwiftUI

struct DeployDetails: View {
    @State private var deployLoadingState: LoadingState<Deploy> = .loading
    
    var deploy: Deploy
    
    private func getSummaryDeploy() {
        print("getSummaryDeploy")
        
        deployLoadingState = .success(deploy)
        
        Endpoint.api.fetch(.deploy(siteId: deploy.siteId, deploy: deploy.id)) { (result: Result<Deploy, ApiError>) in
            switch result {
            case let .success(value):
                deployLoadingState = .success(value)
            case let .failure(error):
                deployLoadingState = .failure(error)
            }
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Информация о сборке")) {
                FormItems(title: "Build id", value: deploy.buildId)
                FormItems(title: "State", value: deploy.state.rawValue)
                FormItems(title: "Name", value: deploy.name)
                Link(destination: deploy.url) {
                    FormItems(title: "URL", value: "\(deploy.url)")
                }
                Link(destination: deploy.deployUrl) {
                    FormItems(title: "Deploy URL", value: "\(deploy.deployUrl)")
                }
                if let errorMessage = deploy.errorMessage {
                    FormItems(title: "Error message", value: errorMessage)
                }
                FormItems(title: "Commit ref", value: deploy.commitRef)
                FormItems(title: "Branch", value: deploy.branch)
                Link(destination: deploy.commitUrl) {
                    FormItems(title: "Commit URL", value: "\(deploy.commitUrl)")
                }
                FormItems(title: "Title", value: deploy.title)
            }
            NavigationLink(destination: LogView(logAccessAttributes: deploy.logAccessAttributes)) {
                Label("Логи", systemImage: "rectangle.and.text.magnifyingglass")
            }
        }
        .navigationTitle(deploy.branch + "@" + deploy.commitRef.prefix(7))
    }
}
