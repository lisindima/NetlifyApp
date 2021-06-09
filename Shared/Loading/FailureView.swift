//
//  FailureView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 22.04.2021.
//

import SwiftUI

struct FailureView: View {
    let errorMessage: String
    
    var body: some View {
        VStack {
            Spacer()
            Text("title_error_state")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Text(errorMessage)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
        }
    }
}
