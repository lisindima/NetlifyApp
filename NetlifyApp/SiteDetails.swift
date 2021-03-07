//
//  SiteDetails.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import SwiftUI
import Kingfisher

struct SiteDetails: View {
    @State private var deploysLoadingState: LoadingState<[Deploy]> = .loading
    
    var site: Site
    
    private func listSiteDeploys() {
        Endpoint.api.fetch(.deploys(siteId: site.id, items: 5)) { (result: Result<[Deploy], ApiError>) in
            switch result {
            case let .success(value):
                if value.isEmpty {
                    deploysLoadingState = .empty
                } else {
                    deploysLoadingState = .success(value)
                }
                print(value)
            case let .failure(error):
                deploysLoadingState = .failure(error)
            }
        }
    }
    
    var header: some View {
        HStack {
            Text("Сборки")
            Spacer()
            NavigationLink(destination: Text("хи-хи")) {
                Text("Еще")
            }
        }
    }
    
    var body: some View {
        Form {
            KFImage(site.screenshotUrl)
                .resizable()
                .cornerRadius(8)
                .aspectRatio(contentMode: .fit)
                .frame(height: 225)
            Section(header: Text("Информация о сайте")) {
                Link(destination: site.adminUrl) {
                    Label("Открыть панель администратора", systemImage: "wrench.and.screwdriver.fill")
                }
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
        }
        .onAppear(perform: listSiteDeploys)
        .navigationTitle(site.customDomain)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Link(destination: site.url) {
                    Label("Открыть сайт", systemImage: "safari")
                }
            }
        }
    }
}
