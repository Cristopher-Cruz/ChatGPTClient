//
//  macOSApp.swift
//  MacOS
//
//  Created by christopher cruz on 5/6/23.
//


import SwiftUI

@main
struct macOSApp: App {
    
    @StateObject var vm = ViewModel(api: APICaller(apiKey: ""))
    
    var body: some Scene {
        MenuBarExtra("ChatGPT", image: "Icon") {
            VStack(spacing: 0) {
                HStack {
                    Text("ChatGPT")
                        .font(.title)
                    Spacer()
                   
                    Button {
                        guard !vm.isInteractingWithChatGPT else { return }
                        vm.clearMessages()
                    } label: {
                        Image(systemName: "trash")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 24))
                    }

                    .buttonStyle(.borderless)
                    
                    
                    Button {
                        exit(0)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 24))
                    }

                    .buttonStyle(.borderless)
                }
                .padding()
                
                ContentView(vm: vm)
            }
            .frame(width: 480, height: 576)
        }.menuBarExtraStyle(.window)
    }
}
