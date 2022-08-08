//
//  udpClientView.swift
//  DemoMultiLink
//
//  Created by Yong Jin on 2022/8/7.
//

import SwiftUI

struct UdpClientView: View {
    @StateObject var vm: SocketViewModel = SocketViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                            Text("IP:")
                                .frame(width: 80, alignment: .trailing)
                            TextField("127.0.0.1", text: $vm.ip)
                                .textFieldStyle(.roundedBorder)
                                .frame(minWidth: 120, maxWidth: .infinity, alignment: .leading)
                            
                        }
                        .frame(minWidth: 300, maxWidth: .infinity)
                        

            HStack(alignment: .firstTextBaseline) {
                Text("Port:")
                    .frame(width: 80, alignment: .trailing)
                TextField("127.0.0.1", text: $vm.port)
                    .textFieldStyle(.roundedBorder)
                    .frame(minWidth: 120, maxWidth: .infinity, alignment: .leading)
                
            }
            .frame(minWidth: 300, maxWidth: .infinity)
            
            Button {
                if vm.service.isUdpListening {
                    vm.stopUdp()
                } else {
                    vm.startUdp()
                }
                
            } label: {
                Text(vm.service.isUdpListening ? "DisConnect" : "Connect")
            }
            .frame(maxWidth:.infinity ,alignment: .trailing)
            

            HStack(alignment: .firstTextBaseline) {
                Text("Message:")
                    .frame(width: 80, alignment: .trailing)
                TextField("Input some message here...", text: $vm.message)
                    .textFieldStyle(.roundedBorder)
                    .frame(minWidth: 120, maxWidth: .infinity, alignment: .leading)
                
            }
            .frame(minWidth: 300, maxWidth: .infinity)
            
            Button {
                vm.sendUdpData()
            } label: {
                Text("Send")
            }
            .frame(maxWidth:.infinity ,alignment: .trailing)
            .disabled(!vm.isConnected || vm.message.isEmpty)
            
            
            Divider()
            
            Text("Log Message")

            TextEditor(text: $vm.logMessage)
                .border(.gray.opacity(0.2))
            
        }

        .padding()
    }
}

struct udpClientView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
