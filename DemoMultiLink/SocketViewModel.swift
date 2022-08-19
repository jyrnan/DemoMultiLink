//
//  SocketViewModel.swift
//  DemoMultiLink
//
//  Created by Yong Jin on 2022/8/5.
//
  

import Foundation
import TestMultiLinkSDK


class SocketViewModel: ObservableObject, Listener {
    
    //MARK: - 变量
    var service: YMLNetworkService = .init()
    @Published var ip: String = "127.0.0.1"
    @Published var port: String = "8000"
    @Published var message: String = ""
    @Published var logMessage: String = ""
    
    @Published var ips: [String] = ["127.0.0.1", "255.255.255.255"]
    
    @Published var isConnected: Bool = false
    
    private func setupListener() {
        service.lisener = self
        ips = ["127.0.0.1", "255.255.255.255"] + getIFAddresses()
    }
    
    func startTcpServer() {
        setupListener()
        isConnected = service.listeningOn(port: port)
    }
    
    func connectClientTo() {
        setupListener()
        isConnected = service.connectToHost(ip, on: port)
    }
    
    func sendtcpData() {
        let data = message.data(using: .utf8)
        
        service.sendTCPData(data: data)
        
        message = ""
    }
    
    //MARK: - UDP
    func startUdp() {
        setupListener()
        isConnected = service.createUdpChannel(info: DeviceInfo())
    }
    
    func stopUdp() {
//        service.closeUdpSocket()
        isConnected = false
    }
    
    func sendUdpData() {
        let data = message.data(using: .utf8)!
        //TODO: - 发送命令
        service.sendGeneralCommand(command: "", data: KEYData())
    }
    
    //MARK: - 数据处理方法
    
    private func updateLogMessage(log: String) {
        let date = Date.now.formatted(date: .omitted, time: .standard)
        logMessage += "\(date): \(log)\n"
    }
    
    private func dataHandler(data: Data) {
        let msg = String(data: data[12...], encoding: .utf8)
        let msgHex = data.hexString()
        
        updateLogMessage(log: msg ?? "未知数据")
        updateLogMessage(log: msgHex)
    }
    
    //MARK: - Listener protocol
    
    func deliver(data: Data) {
        dataHandler(data: data)
    }
    
    func deliver(devices: [DeviceInfo]) {
        updateLogMessage(log: devices.description)
    }
    
    func notified(with message: String) {
        updateLogMessage(log: message)
    }
    
    //MARK: - 获取IP
    func getIFAddresses() -> [String] {
            var addresses = [String]()
            
            // Get list of all interfaces on the local machine:
            var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
            if getifaddrs(&ifaddr) == 0 {
              
              var ptr = ifaddr
              while ptr != nil {
                let flags = Int32((ptr?.pointee.ifa_flags)!)
                var addr = ptr?.pointee.ifa_addr.pointee
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                  if addr?.sa_family == UInt8(AF_INET) //|| addr?.sa_family == UInt8(AF_INET6)
                    {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr!, socklen_t((addr?.sa_len)!), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                      if let address = String(validatingUTF8: hostname) {
                        addresses.append(address)
                      }
                    }
                  }
                }
                ptr = ptr?.pointee.ifa_next
              }

                freeifaddrs(ifaddr)
            }
            print("Local IP \(addresses)")
            return addresses
        }
   
}

extension Data {
    func hexString() -> String {
        return self.isEmpty ? "No HexData" : "\\x" + self.map { String(format: "%02x", $0)}.joined(separator: "\\x")
    }
}
