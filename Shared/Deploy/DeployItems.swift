//
//  DeployItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 06.03.2021.
//

import SwiftUI

struct DeployItems: View {
    var deploy: Deploy
    
    var body: some View {
        NavigationLink(destination: DeployDetails(deploy: deploy)) {
            Label {
                VStack(alignment: .leading) {
                    HStack {
                        Text(deploy.context.prettyValue)
                            .fontWeight(.bold)
                        Text(deploy.gitInfo)
                    }
                    .font(.footnote)
                    .lineLimit(1)
                    if let deployTime = deploy.deployTime {
                        Text("deploy_time_title \(deployTime.convertedDeployTime)")
                            .font(.caption2)
                    }
                    if let errorMessage = deploy.errorMessage {
                        Text(errorMessage)
                            .font(.caption2)
                            .lineLimit(2)
                    }
                }
            } icon: {
                deploy.state
            }
        }
    }
}
