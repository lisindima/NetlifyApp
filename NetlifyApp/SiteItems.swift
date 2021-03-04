//
//  SiteItems.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import SwiftUI
import Kingfisher

struct SiteItems: View {
    var site: Site
    
    var body: some View {
        NavigationLink(destination: SiteDetails(site: site)) {
            HStack {
                KFImage(site.screenshotUrl)
                    .placeholder { ProgressView() }
                    .resizable()
                    .frame(width: 96, height: 60)
                    .cornerRadius(5)
                    .padding(.vertical, 8)
                VStack(alignment: .leading) {
                    Text(site.customDomain)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(site.updatedAt, style: .relative)
                        .font(.footnote)
                }
            }
            .contextMenu {
                Link(destination: site.url) {
                    Label("Открыть сайт", systemImage: "safari")
                }
                Link(destination: site.adminUrl) {
                    Label("Открыть панель администратора", systemImage: "wrench.and.screwdriver.fill")
                }
            }
        }
    }
}

struct SiteDetails: View {
    var site: Site
    
    var body: some View {
        Form {
            Section {
                
            }
        }
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
