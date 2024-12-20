//
//  TabContainer.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/20/24.
//

import SwiftUI

struct TabContainer: View {
    var body: some View {
        TabView {
            TabWatch()
                .tabItem {
                    Label("Watch", systemImage: "list.dash")
                }

        }
    }
}

struct TabContainer_Previews: PreviewProvider {
    static var previews: some View {
        TabContainer()
    }
}
