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
    var service: SocketService = .init()
    @Published var ip: String = "127.0.0.1"
    @Published var port: String = "7788"
    @Published var message: String = ""
    @Published var logMessage: String = ""
    
    @Published var isConnected: Bool = false
    
    private func setupListener() {
        service.lisener = self
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
        service.createUdpSocket(on: port)
        isConnected = true
    }
    
    func stopUdp() {
        service.closeUdpSocket()
        isConnected = false
    }
    
    func sendUdpData() {
        let data = message.data(using: .utf8)!
        
        service.sendUdpData(data, to: ip, on: port)
    }
    
    //MARK: - 数据处理方法
    
    private func updateLogMessage(log: String) {
        let date = Date.now.formatted(date: .omitted, time: .standard)
        logMessage += "\(date): \(log)\n"
    }
    
    private func dataHandler(data: Data) {
        let msg = String(data: data, encoding: .utf8)
        updateLogMessage(log: msg ?? "")
    }
    
    //MARK: - Listener protocol
    
    func deliver(data: Data) {
        dataHandler(data: data)
    }
    
    func notified(with message: String) {
        updateLogMessage(log: message)
    }
}
