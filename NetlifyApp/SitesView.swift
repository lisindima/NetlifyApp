//
//  SitesView.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import SwiftUI
import Kingfisher

struct SitesView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    @State private var presentProfile: Bool = false
    
    private func showProfile() {
        presentProfile = true
    }
    
    var body: some View {
        NavigationView {
            LoadingView(
                loadingState: $sessionStore.sitesLoadingState,
                title: "dd",
                subTitle: "eee",
                load: sessionStore.listSites
            ) { sites in
                List {
                    ForEach(sites, id: \.id) { site in
                        SiteItems(site: site)
                    }
                }
            }
            .navigationTitle("Sites")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: showProfile) {
                        if let avatarUrl = sessionStore.user?.avatarUrl {
                            KFImage(avatarUrl)
                                .resizable()
                                .placeholder { ProgressView() }
                                .frame(width: 35, height: 35)
                                .mask(Circle())
                        }
                    }
                }
            }
        }
        .onAppear(perform: sessionStore.getCurrentUser)
        .sheet(isPresented: $presentProfile) {
            ProfileView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SitesView()
    }
}
