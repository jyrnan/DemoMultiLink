//
//  ContentView.swift
//  DemoMultiLink
//
//  Created by Yong Jin on 2022/8/5.
//

import SwiftUI
import TestMultiLinkSDK

struct ContentView: View {
    var service: YMLNetworkService = YMLNetworkService()
    var body: some View {
        NavigationView {
            
            TabView {
                UdpClientView()
                    .tabItem{
                        Label("Udp", systemImage: "desktopcomputer")
                    }
                
                TcpClientView()
                    .tabItem{
                        Label("TcpClient", systemImage: "desktopcomputer")
                    }
                
                ServerView()
                    .tabItem{
                        Label("TcpServer", systemImage: "server.rack")}
            }
            .navigationTitle("SocketTest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
