//
//  RepoDetailsView.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 03/12/2023.
//

import SwiftUI

struct RepoDetailsView: View {
    
    @EnvironmentObject private var navigator: Navigator
    @ObservedObject private var viewModel: RepoDetailsViewModel
    
    init(viewModel: RepoDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        BaseView {
            List {
                Section {
                    VStack {
                        AsyncImage(url: URL(string: viewModel.repo.owner?.avatarUrl ?? ""), scale: 2) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.gray.opacity(0.5)
                        }
                        .frame(width: 120, height: 120)
                        .cornerRadius(10)
                        
                        Text(viewModel.repo.fullName)
                            .font(.title)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                    
                    Text("Star")
                        .badge(viewModel.repo.stars)
                    
                    Text("Fork")
                        .badge(viewModel.repo.forks)
                }
                
                Section("Events") {
                    if viewModel.state == .isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .listRowSeparator(.hidden)
                    } else {
                        ForEach(viewModel.events) { event in
                            EventView(event: event)
                        }
                    }
                }
                
                if viewModel.state == .loadingMore {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .listRowSeparator(.hidden)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .id(UUID())
                        
                } else {
                    Color.clear
                        .listRowSeparator(.hidden)
                        .padding()
                        .onAppear {
                            viewModel.loadMoreEvent()
                        }
                }
                
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                viewModel.reloadEvent()
            }
            .onAppear {
                viewModel.loadEvent()
            }
        }
    }
}

//#Preview {
//    RepoDetailsView(viewModel: RepoDetailsViewModel(repo: Repo()))
//}
