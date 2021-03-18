//
//  SiteDetails.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import Kingfisher
import SwiftUI

struct SiteDetails: View {
    @State private var deploysLoadingState: LoadingState<[Deploy]> = .loading
    
    var site: Site
    
    private func listSiteDeploys() {
        print("listSiteDeploys")
        
        Endpoint.api.fetch(.deploys(siteId: site.id, items: 5)) { (result: Result<[Deploy], ApiError>) in
            switch result {
            case let .success(value):
                if value.isEmpty {
                    deploysLoadingState = .empty
                } else {
                    deploysLoadingState = .success(value)
                }
            case let .failure(error):
                deploysLoadingState = .failure(error)
            }
        }
    }
    
    private func deleteSite() {
        Endpoint.api.fetch(.sites(siteId: site.id), httpMethod: .delete) { (result: Result<Message, ApiError>) in
            switch result {
            case let .success(value):
                print(value)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    var header: some View {
        HStack {
            Text("section_header_builds")
            Spacer()
            if case let .success(value) = deploysLoadingState, value.count >= 5 {
                NavigationLink(destination: DeploysList(site: site)) {
                    Text("section_header_button_builds")
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    var body: some View {
        Form {
            HStack {
                Spacer()
                KFImage(site.screenshotUrl)
                    .resizable()
                    .loadImmediately()
                    .cornerRadius(8)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 225)
                Spacer()
            }
            Section(header: Text("section_header_about_site")) {
                Label(site.createdAt.siteDate, systemImage: "clock.arrow.circlepath")
                Label(site.updatedAt.siteDate, systemImage: "clock.arrow.2.circlepath")
                Label(site.accountName, systemImage: "person.2.fill")
                Label(site.accountType, systemImage: "dollarsign.circle.fill")
                Link(destination: site.adminUrl) {
                    Label("button_admin_panel", systemImage: "wrench.and.screwdriver.fill")
                }
            }
            Section(header: Text("section_header_build_settings")) {
                Label(site.buildSettings.repoBranch, systemImage: "arrow.triangle.branch")
                Link(destination: site.buildSettings.repoUrl) {
                    Label(site.buildSettings.repoPath, systemImage: "tray.2.fill")
                }
                Label(site.buildImage, systemImage: "pc")
                Label(site.buildSettings.cmd, systemImage: "terminal.fill")
                Label(site.buildSettings.dir, systemImage: "folder.fill")
            }
            Section(header: header) {
                LoadingView(
                    loadingState: $deploysLoadingState,
                    load: listSiteDeploys
                ) { deploys in
                    List {
                        ForEach(deploys, id: \.id) { deploy in
                            DeployItems(deploy: deploy)
                        }
                    }
                }
            }
            Section {
                Button(action: deleteSite) {
                    Label("button_delete_site", systemImage: "trash.fill")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle(site.name)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Link(destination: site.url) {
                    Label("button_open_site", systemImage: "safari.fill")
                }
            }
        }
    }
}
