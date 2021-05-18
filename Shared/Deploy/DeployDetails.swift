//
//  DeployDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.03.2021.
//

import SwiftUI

struct DeployDetails: View {
    @State private var deployLoadingState: LoadingState<Deploy> = .loading(.placeholder)
    
    let deployId: String
    
    var body: some View {
        LoadingView(
            loadingState: $deployLoadingState,
            failure: { error in
                FailureView(error.localizedDescription, action: getDeploy)
            }
        ) { deploy in
            List {
                if case .ready = deploy.state {
                    Section(header: Text("section_header_summary_deploy")) {
                        if let summary = deploy.summary {
                            ForEach(summary.messages, id: \.self, content: SummaryItems.init)
                        }
                    }
                }
                Section(header: Text("section_header_status_deploy")) {
                    StateView(deploy: deploy)
                }
                Section(header: Text("section_header_info_deploy")) {
                    if let createdAt = deploy.createdAt {
                        FormItems("Deploy created", value: createdAt.siteDate)
                    }
                    if let updatedAt = deploy.updatedAt {
                        FormItems("Deploy updated", value: updatedAt.siteDate)
                    }
                    FormItems("Site name", value: deploy.name)
                    if let deployTime = deploy.deployTime {
                        FormItems("Deploy time", value: deployTime.convertedDeployTime(.full))
                    }
                    if let errorMessage = deploy.errorMessage {
                        FormItems("Error message", value: errorMessage)
                    }
                    if let framework = deploy.framework {
                        FormItems("Framework", value: framework)
                    }
                    Link("button_open_deploy_url", destination: deploy.deployUrl)
                }
                generateCommitInformation(deploy: deploy)
                Section {
                    NavigationLink(destination: LogView(logAccessAttributes: deploy.logAccessAttributes)) {
                        Label("section_navigation_link_log", systemImage: "rectangle.and.text.magnifyingglass")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationTitle(deployId)
        .onAppear(perform: getDeploy)
        .userActivity("com.darkfox.netliphy.deploy", element: deployId) { id, activity in
            activity.addUserInfoEntries(
                from: [
                    "url": URL(string: "netliphy://open?deployId=\(id)")!,
                ]
            )
        }
    }
    
    @ViewBuilder
    private func generateCommitInformation(deploy: Deploy) -> some View {
        if !deploy.manualDeploy {
            Section(header: Text("Commit information")) {
                if let branch = deploy.branch {
                    FormItems("Branch", value: branch)
                }
                if let title = deploy.title {
                    FormItems("Title", value: title)
                }
                if let committer = deploy.committer {
                    FormItems("Committer", value: committer)
                }
                if let commitUrl = deploy.commitUrl, let commitRef = deploy.commitRef {
                    Link("button_title_view_commit \(String(commitRef.prefix(7)))", destination: commitUrl)
                }
            }
        }
    }
    
    private func getDeploy() {
        Endpoint.api.fetch(.deploy(deployId: deployId)) { (result: Result<Deploy, ApiError>) in
            switch result {
            case let .success(value):
                deployLoadingState = .success(value)
            case let .failure(error):
                deployLoadingState = .failure(error)
                print(error)
            }
        }
    }
}
