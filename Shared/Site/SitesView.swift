//
//  SitesView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import SwiftUI
import Kingfisher

struct SitesView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    @State private var showProfileView: Bool = false
    
    @ViewBuilder
    var navigationItems: some View {
        if let avatarUrl = sessionStore.user?.avatarUrl {
            Button(action: { showProfileView = true }) {
                KFImage(avatarUrl)
                    .resizable()
                    .placeholder { ProgressView() }
                    .loadImmediately()
                    .frame(width: 30, height: 30)
                    .mask(Circle())
            }
        }
    }
    
    var body: some View {
        LoadingView(
            loadingState: $sessionStore.sitesLoadingState,
            title: "title_empty_site_list",
            subTitle: "subTitle_empty_site_list",
            load: sessionStore.listSites
        ) { sites in
            List {
                ForEach(sites.sorted { $0.updatedAt > $1.updatedAt }, id: \.id, content: SiteItems.init)
            }
        }
        .navigationTitle("navigation_title_sites")
        .navigationBarItems(trailing: navigationItems)
        .sheet(isPresented: $showProfileView) {
            NavigationView {
                ProfileView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .onAppear(perform: sessionStore.getCurrentUser)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SitesView()
    }
}
