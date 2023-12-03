//
//  SwiftUI_MVVM_CombineApp.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 30/11/2023.
//

import SwiftUI

@main
struct SwiftUI_MVVM_CombineApp: App {
    
    @StateObject var navigator = Navigator()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigator.navigationPath) {
                navigator.getRootView().view
                    .navigationDestination(for: Destination.self) { destination in
                        destination.view
                    }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(navigator)
        }
    }
}
