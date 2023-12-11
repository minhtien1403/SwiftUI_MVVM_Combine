//
//  Navigator.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 30/11/2023.
//

import SwiftUI

@MainActor
class Navigator: ObservableObject {
    
    @Published var navigationPath = NavigationPath()
    @Published var presentingSheet: Destination? = nil
    @Published var presentingFullScreen: Destination? = nil
    @Published var isPresentingAlert: Bool = false
    @Published var isPresentingFullScreen: Bool = false
    
    private var rootView: Destination {
        return .tabbar
    }
    
    func getRootView() -> Destination {
        rootView
    }
    
    func push(to view: Destination) {
        navigationPath.append(view)
    }
    
    func pop() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    func popTo(destination: Destination) {
        
    }
    
    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    func presentSheet(sheet: Destination) {
        presentingSheet = sheet
    }
    
    func presentFullScreen(view: Destination) {
        presentingFullScreen = view
        isPresentingFullScreen = true
    }
    
    func presentAlert() {
        isPresentingAlert = true
    }
    
    func dismissSheet() {
        presentingSheet = nil
        presentingFullScreen = nil
        isPresentingFullScreen = false
    }
    
    func dismissAlert() {
        isPresentingAlert = false
    }
}
