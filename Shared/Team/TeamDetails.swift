//
//  TeamDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 31.03.2021.
//

import SwiftUI

struct TeamDetails: View {
    var team: Team
    
    @State private var bandwidthLoadingState: LoadingState<Bandwidth> = .loading(.placeholder)
    @State private var statusLoadingState: LoadingState<BuildStatus> = .loading(.placeholder)
    
    private func getBandwidth() {
        Endpoint.api.fetch(.bandwidth(slug: team.slug)) { (result: Result<Bandwidth, ApiError>) in
            switch result {
            case let .success(value):
                bandwidthLoadingState = .success(value)
            case let .failure(error):
                bandwidthLoadingState = .failure(error)
                print(error)
            }
        }
    }
    
    private func getStatus() {
        Endpoint.api.fetch(.status(slug: team.slug)) { (result: Result<BuildStatus, ApiError>) in
            switch result {
            case let .success(value):
                statusLoadingState = .success(value)
            case let .failure(error):
                statusLoadingState = .failure(error)
                print(error)
            }
        }
    }
    
    var body: some View {
        Form {
            Section {
                LoadingView(
                    loadingState: $bandwidthLoadingState,
                    load: getBandwidth
                ) { bandwidth in
                    ProgressView(
                        value: Float(bandwidth.used),
                        total: Float(bandwidth.included),
                        label: {
                            Text("progress_view_bandwidth")
                                .fontWeight(.bold)
                            Text("progress_view_updated \(bandwidth.lastUpdatedAt.siteDate)")
                                .font(.caption2)
                        },
                        currentValueLabel: {
                            HStack {
                                Text(bandwidth.used.byteSize)
                                Spacer()
                                Text(bandwidth.included.byteSize)
                            }
                        }
                    )
                }
            }
            Section {
                LoadingView(
                    loadingState: $statusLoadingState,
                    load: getStatus
                ) { status in
                    ProgressView(
                        value: Float(status.minutes.current),
                        total: Float(status.minutes.includedMinutes),
                        label: {
                            Text("progress_view_build_minutes")
                                .fontWeight(.bold)
                            Text("progress_view_updated \(status.minutes.lastUpdatedAt.siteDate)")
                                .font(.caption2)
                        },
                        currentValueLabel: {
                            HStack {
                                Text("\(status.minutes.current)")
                                Spacer()
                                Text("\(status.minutes.includedMinutes)")
                            }
                        }
                    )
                }
            }
            Section {
                FormItems("Name", value: team.name)
                FormItems("Type", value: team.typeName)
                FormItems("Members count", value: "\(team.membersCount)")
                FormItems("Slug", value: team.slug)
                if let billingName = team.billingName {
                    FormItems("Billing name", value: billingName)
                }
                if let billingEmail = team.billingEmail {
                    FormItems("Billing email", value: billingEmail)
                }
                if let billingPeriod = team.billingPeriod {
                    FormItems("Billing period", value: billingPeriod)
                }
                if let billingDetails = team.billingDetails {
                    FormItems("Billing details", value: billingDetails)
                }
            }
        }
        .navigationTitle(team.name)
    }
}
