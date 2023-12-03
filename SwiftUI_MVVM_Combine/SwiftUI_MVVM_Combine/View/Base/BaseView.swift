//
//  BaseView.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 02/12/2023.
//

import SwiftUI

struct BaseView<Content: View>: View {
    
    private let content: Content
    private var error: NetworkRequestError?
    @EnvironmentObject var navigator: Navigator
    
    public init(@ViewBuilder content: () -> Content, error: NetworkRequestError? = nil) {
        self.content = content()
        self.error = error
    }
    
    var body: some View {
        ZStack {
            content
                .alert("Error", isPresented: $navigator.isPresentingAlert) {
                    Button(action: {
                        navigator.dismissAlert()
                    }, label: {
                        Text("OK")
                    })
                } message: {
                    Text("\(error?.errorDescription ?? "nil")")
                }
        }
    }
}
