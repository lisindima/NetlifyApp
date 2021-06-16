//
//  ContentView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 11.03.2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    @State private var sheetItem: SheetItem?
    
    var body: some View {
        if sessionStore.accessToken.isEmpty {
            LoginView()
        } else {
            ChoiseNavigation()
                .sheet(item: $sheetItem) { item in
                    NavigationView {
                        DeployDetails(deployId: item.id)
                            .toolbar {
                                Button("close_button") {
                                    sheetItem = nil
                                }
                            }
                    }
                    .navigationViewStyle(.stack)
                }
                .onOpenURL(perform: presentDeploy)
                .task {
                    await sessionStore.getCurrentUser()
                }
                .onContinueUserActivity("com.darkfox.netliphy.deploy") { userActivity in
                    if let url = userActivity.userInfo?["url"] as? URL {
                        presentDeploy(url)
                    }
                }
        }
    }
    
    private func presentDeploy(_ url: URL) {
        guard let id = url["deployId"] else { return }
        sheetItem = SheetItem(id: id)
    }
}

struct SheetItem: Identifiable {
    let id: String
}