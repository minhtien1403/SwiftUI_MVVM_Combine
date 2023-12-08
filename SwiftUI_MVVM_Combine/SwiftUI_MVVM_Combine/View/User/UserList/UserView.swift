//
//  UserView.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 04/12/2023.
//

import SwiftUI

struct UserView: View {
    
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(user.name)
                .bold()
            Text(user.birthday.formatted(date: .abbreviated, time: .omitted))
        }
        .badge(user.gender.title)
    }
}

//#Preview {
//    UserView()
//}
