//
//  iOSApp.swift
//  iOS
//
//  Created by christopher cruz on 5/6/23.
//

import SwiftUI

@main
struct iOSApp: App {
    @StateObject var vm = ViewModel(api: APICaller(apiKey: ""))

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(vm: vm)
            }
        }
    }
}


