//
//  DeployDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.03.2021.
//

import SwiftUI

struct DeployDetails: View {
    @State private var deployLoadingState: LoadingState<Deploy> = .loading
    
    var deploy: Deploy
    
    private func getDeploy() {
        print("getDeploy")
        
        Endpoint.api.fetch(.deploy(siteId: deploy.siteId, deploy: deploy.id)) { (result: Result<Deploy, ApiError>) in
            switch result {
            case let .success(value):
                deployLoadingState = .success(value)
            case let .failure(error):
                deployLoadingState = .failure(error)
                print(error)
            }
        }
    }
    
    var body: some View {
        LoadingView(loadingState: $deployLoadingState, load: getDeploy) { deploy in
            Form {
                if let summary = deploy.summary, !summary.messages.isEmpty {
                    Section(header: Text("section_header_summary_deploy")) {
                        ForEach(summary.messages, id: \.self, content: SummaryItems.init)
                    }
                }
                Section(header: Text("section_header_info_deploy")) {
                    Group {
                        FormItems(title: "Build id", value: deploy.buildId)
                        FormItems(title: "Name", value: deploy.name)
                        FormItems(title: "State", value: deploy.state.rawValue)
                        if let errorMessage = deploy.errorMessage {
                            FormItems(title: "Error message", value: errorMessage)
                        }
                        Link(destination: deploy.url) {
                            FormItems(title: "URL", value: "\(deploy.url)")
                        }
                        Link(destination: deploy.deployUrl) {
                            FormItems(title: "Deploy URL", value: "\(deploy.deployUrl)")
                        }
                        FormItems(title: "Branch", value: deploy.branch)
                        if let title = deploy.title {
                            FormItems(title: "Title", value: title)
                        }
                        if let commitUrl = deploy.commitUrl, let commitRef = deploy.commitRef {
                            Link(destination: commitUrl) {
                                FormItems(title: "Commit", value: commitRef)
                            }
                        }
                    }
                    Group {
                        if let committer = deploy.committer {
                            FormItems(title: "Committer", value: committer)
                        }
                        FormItems(title: "Context", value: deploy.context)
                        if let framework = deploy.framework {
                            FormItems(title: "Framework", value: framework)
                        }
                    }
                }
                if deploy.state == .ready, deploy.publishedAt == nil {
                    Button(action: {}) {
                        Label("Publish deploy", systemImage: "checkmark.icloud")
                    }
                }
                Section(header: Text("Retry deploy")) {
                    Button(action: {}) {
                        Label("Deploy site", systemImage: "icloud.and.arrow.up")
                    }
                    Button(action: {}) {
                        Label("Clear cache and deploy site", systemImage: "arrow.clockwise.icloud")
                    }
                }
                if let logAccessAttributes = deploy.logAccessAttributes {
                    NavigationLink(destination: LogView(logAccessAttributes: logAccessAttributes)) {
                        Label("section_navigation_link_log", systemImage: "rectangle.and.text.magnifyingglass")
                    }
                }
            }
        }
        .navigationTitle(deploy.branch + "@" + (deploy.commitRef ?? "").prefix(7))
    }
}
