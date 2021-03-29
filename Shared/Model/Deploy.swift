//
//  Deploy.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import Foundation
import SwiftUI

struct Deploy: Codable {
    let id, siteId, userId: String
    let buildId: String?
    let name: String
    let state: DeployState
    let adminUrl, deployUrl, url, sslUrl, deploySslUrl: URL
    let screenshotUrl, commitUrl: URL?
    let reviewId: Int?
    let branch: String?
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
    let manualDeploy: Bool
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
            Image(systemName: "star.fill")
                .foregroundColor(.pink)
        case .building:
            Image(systemName: "gearshape.2.fill")
                .foregroundColor(.yellow)
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
    case building
}

struct Message: Codable, Hashable {
    let type: Type
    let title, description: String
    let details: String?
}

enum Type: String, Codable, View {
    case info
    case warning
    case error
    case building
    case new
    
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
        case .building:
            Image(systemName: "gearshape.2.fill")
                .foregroundColor(.yellow)
        case .new:
            Image(systemName: "star.fill")
                .foregroundColor(.pink)
        }
    }
}

extension Message {
    static let error = Message(
        type: .error,
        title: "Deploy failed",
        description: "We couldn’t deploy your site. Check out our [Build docs](https://docs.netlify.com/configure-builds/troubleshooting-tips/) for tips on troubleshooting your build, or [ask us for debugging advice](https://www.netlify.com/support/).",
        details: nil
    )
    static let building = Message(
        type: .building,
        title: "Deploy in progress",
        description: "Netlify’s robots are busy building and deploying your site to our CDN.",
        details: nil
    )
    static let new = Message(
        type: .new,
        title: "New deploy",
        description: "Waiting for other deploys from your team to complete.",
        details: nil
    )
}

extension Deploy {
    var gitInfo: String {
        var string = ""
        
        if manualDeploy {
            string = "Manual deploy"
        } else {
            if let branch = branch, branch.count >= 10 {
                string.append(String(branch.prefix(10) + "... @"))
            }
            
            if let branch = branch, branch.count < 10 {
                string.append(branch + "@")
            }
            
            if let commitRef = commitRef {
                string.append(String(commitRef.prefix(7)))
            } else {
                string.append("HEAD")
            }
        }
        
        return string
    }
}
