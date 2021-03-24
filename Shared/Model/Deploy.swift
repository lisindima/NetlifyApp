//
//  Deploy.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import Foundation
import SwiftUI

struct Deploy: Codable {
    let id, siteId, userId, buildId: String
    let name: String
    let state: DeployState
    let adminUrl, deployUrl, url, sslUrl, deploySslUrl: URL
    let screenshotUrl, commitUrl: URL?
    let reviewId: Int?
    let branch: String
    let errorMessage, commitRef: String?
    let skipped: Bool?
    let createdAt, updatedAt: Date
    let publishedAt: Date?
    let title: String?
    let context: String
    let locked: Bool?
    let reviewUrl: URL?
    let committer: String?
    let framework: String?
    let deployTime: TimeInterval?
    let logAccessAttributes: LogAccessAttributes?
    let summary: Summary?
}

struct LogAccessAttributes: Codable {
    let type: String
    let url: String
    let endpoint: String
    let path, token: String
}

enum DeployState: String, Codable, View {
    case error
    case ready
    case new
    case building
    
    var body: some View {
        switch self {
        case .error:
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
        case .ready:
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        case .new:
            Image(systemName: "info.circle.fill")
                .foregroundColor(.purple)
        case .building:
            Image(systemName: "clock.arrow.2.circlepath")
                .foregroundColor(.yellow)
        }
    }
}

enum Type: String, Codable, View {
    case info
    case warning
    case error
    
    var body: some View {
        switch self {
        case .warning:
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.purple)
        case .info:
            Image(systemName: "info.circle.fill")
                .foregroundColor(.accentColor)
        case .error:
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
        }
    }
}

struct Summary: Codable {
    let status: Status
    let messages: [Message]
}

enum Status: String, Codable {
    case unavailable
    case ready
}

struct Message: Codable, Hashable {
    let type: Type
    let title, description: String
    let details: String?
}

extension Message {
    static let error = Message(
        type: .error,
        title: "Deploy failed",
        description: "We couldn’t deploy your site. Check out our [Build docs](https://docs.netlify.com/configure-builds/troubleshooting-tips/) for tips on troubleshooting your build, or [ask us for debugging advice](https://www.netlify.com/support/).",
        details: nil
    )
}
