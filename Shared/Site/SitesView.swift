//
//  SitesView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import SwiftUI

struct SitesView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    @State private var showProfileView: Bool = false
    
    var body: some View {
        LoadingView(
            loadingState: $sessionStore.sitesLoadingState,
            title: "title_empty_site_list",
            subTitle: "subTitle_empty_site_list",
            load: sessionStore.listSites
        ) { sites in
            List {
                ForEach(sites, id: \.id, content: SiteItems.init)
            }
        }
        .navigationTitle("navigation_title_sites")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: { showProfileView = true }) {
                    Label("navigation_title_profile", systemImage: "person.crop.circle.fill")
                }
            }
        }
        .sheet(isPresented: $showProfileView) {
            NavigationView {
                ProfileView()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(action: { showProfileView = false }) {
                                Label("button_close", systemImage: "xmark")
                            }
                        }
                    }
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
