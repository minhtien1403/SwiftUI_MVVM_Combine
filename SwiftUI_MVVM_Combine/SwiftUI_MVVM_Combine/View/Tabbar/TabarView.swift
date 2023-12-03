//
//  TabarView.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 01/12/2023.
//

import SwiftUI

struct TabarView: View {
    
    var body: some View {
        TabView {
            Destination.main(viewModel: MainViewModel()).view
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            Destination.login(viewModel: LoginViewModel()).view
                .tabItem {
                    Label("Shopping", systemImage: "basket.fill")
                }
        }
    }
}

#Preview {
    TabarView()
}
