//
//  udpClientView.swift
//  DemoMultiLink
//
//  Created by Yong Jin on 2022/8/7.
//

import SwiftUI

struct UdpClientView: View {
    @StateObject var vm: SocketViewModel = .init()

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Text("IP:")
                    .frame(width: 80, alignment: .leading)
              
                Spacer()
            
                Picker(selection: $vm.ip, content: {
                    ForEach(vm.ips, id: \.self, content: { ip in
                        Text(ip)
                    })
                    
                }, label: { Text("IP") })
            }
            .frame(minWidth: 300, maxWidth: .infinity)
            
            HStack(alignment: .firstTextBaseline) {
                Text("Port:")
                    .frame(width: 80, alignment: .leading)
                TextField("127.0.0.1", text: $vm.port)
                    .textFieldStyle(.roundedBorder)
                    .frame(minWidth: 120, maxWidth: .infinity, alignment: .leading)
            }
            .frame(minWidth: 300, maxWidth: .infinity)
            
            HStack {
                
                Button {
                    vm.service.searchDeviceInfo(searchListener: vm)
                } label: {
                    Text("SearchDevice")
                }
                
                //Connet按钮
                Button {
                    if vm.service.isUdpListening {
                        vm.stopUdp()
                    } else {
                        vm.startUdp()
                    }
                    
                } label: {
                    Text(vm.service.isUdpListening ? "DisConnect" : "Connect")
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            
            
            HStack(alignment: .firstTextBaseline) {
                Text("Message:")
                    .frame(width: 80, alignment: .leading)
                TextField("Input some message here...", text: $vm.message)
                    .textFieldStyle(.roundedBorder)
                    .frame(minWidth: 120, maxWidth: .infinity, alignment: .leading)
            }
            .frame(minWidth: 300, maxWidth: .infinity)
            
            HStack {
                Button {
                    vm.sendUdpData()
                } label: {
                    Text("Send")
                }
                .disabled(!vm.isConnected || vm.message.isEmpty)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Divider()
            
            Text("Log Message")

            TextEditor(text: $vm.logMessage)
                .border(.gray.opacity(0.2))
        }

        .padding()
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct udpClientView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
