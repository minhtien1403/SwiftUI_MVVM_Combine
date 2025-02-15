//
//  RepoView.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 01/12/2023.
//

import SwiftUI

struct RepoView: View {
    let repo: Repo
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: repo.owner?.avatarUrl ?? ""), scale: 2) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.5)
            }
            .frame(width: 60, height: 60)
            .cornerRadius(5)
            
            Text(repo.fullName)
            
            Spacer()
        }
    }
}
