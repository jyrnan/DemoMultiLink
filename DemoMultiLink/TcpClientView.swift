//
//  TcpClientView.swift
//  DemoMultiLink
//
//  Created by Yong Jin on 2022/8/5.
//

import SwiftUI

struct TcpClientView: View {
    
    @StateObject var serviceVM: SocketViewModel = SocketViewModel()
   
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                            Text("IP:")
                                .frame(width: 80, alignment: .trailing)
                            TextField("127.0.0.1", text: $serviceVM.ip)
                                .textFieldStyle(.roundedBorder)
                                .frame(minWidth: 120, maxWidth: .infinity, alignment: .leading)
                            
                        }
                        .frame(minWidth: 300, maxWidth: .infinity)

            HStack(alignment: .firstTextBaseline) {
                Text("Port:")
                    .frame(width: 80, alignment: .trailing)
                TextField("127.0.0.1", text: $serviceVM.port)
                    .textFieldStyle(.roundedBorder)
                    .frame(minWidth: 120, maxWidth: .infinity, alignment: .leading)
                
            }
            .frame(minWidth: 300, maxWidth: .infinity)
            
            Button {
                serviceVM.connectClientTo()
            } label: {
                Text("Connect")
                    .padding([.bottom, .horizontal])
                    .frame(maxWidth:.infinity ,alignment: .trailing)
            }
            

            HStack(alignment: .firstTextBaseline) {
                Text("Message:")
                    .frame(width: 80, alignment: .trailing)
                TextField("Input some message here...", text: $serviceVM.message)
                    .textFieldStyle(.roundedBorder)
                    .frame(minWidth: 120, maxWidth: .infinity, alignment: .leading)
                
            }
            .frame(minWidth: 300, maxWidth: .infinity)
            
            Button {
                serviceVM.sendtcpData()
            } label: {
                Text("Send")
                    .padding([.bottom, .horizontal])
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Divider()
            
            Text("Log Message")

            TextEditor(text: $serviceVM.logMessage)
                .border(.gray.opacity(0.2))
            
        }

        .padding()
    }
}

struct ClientView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
