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
                    Label("Watch", systemImage: "magnifyingglass")
                }
            
            TabEvaluate()
                .tabItem {
                    Label("Evaluate", systemImage: "chart.line.uptrend.xyaxis")
                }
            
            TabSell()
                .tabItem {
                    Label("Sell", systemImage: "xmark.circle")
                }
            
            TabDataCollection()
                .tabItem {
                    Label("Data Collection", systemImage: "icloud.and.arrow.down")
                }
            
        }
    }
}

struct TabContainer_Previews: PreviewProvider {
    static var previews: some View {
        TabContainer()
    }
}
