import Foundation
import Network

class NetworkDiscovery: NSObject, NSNetServiceBrowserDelegate {
    var discoveredDevices: [String: String] = [:]
    var completion: (([String: String]) -> Void)?
    var serviceBrowser: NetServiceBrowser?

    func discoverHisenseDevices(completion: @escaping ([String: String]) -> Void) {
        self.completion = completion
        self.discoveredDevices = [:]

        serviceBrowser = NetServiceBrowser()
        serviceBrowser?.delegate = self
        serviceBrowser?.searchForServices(ofType: "_http._tcp", inDomain: "local.")

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.stopDiscovery()
            completion(self.discoveredDevices)
        }
    }

    func stopDiscovery() {
        serviceBrowser?.stop()
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didFind netService: NetService, moreComing: Bool) {
        if netService.name.lowercased().contains("hisense") ||
           netService.name.lowercased().contains("star") ||
           netService.name.lowercased().contains("ac") {

            let resolver = netService
            resolver.delegate = self
            resolver.resolve(withTimeout: 2.0)
        }
    }

    func scanNetwork() -> AnyPublisher<[String: String], Error> {
        Future { promise in
            self.discoverHisenseDevices { devices in
                promise(.success(devices))
            }
        }
        .eraseToAnyPublisher()
    }
}

extension NetworkDiscovery: NetServiceDelegate {
    func netServiceDidResolveAddress(_ sender: NetService) {
        if let addresses = sender.addresses {
            for addr in addresses {
                if let ipString = ipFromAddress(addr) {
                    discoveredDevices[sender.name] = ipString
                    print("Found: \(sender.name) at \(ipString)")
                }
            }
        }
    }

    private func ipFromAddress(_ data: Data) -> String? {
        guard data.count > 4 else { return nil }

        let bytes = [UInt8](data)
        if bytes.count >= 4 {
            return "\(bytes[0]).\(bytes[1]).\(bytes[2]).\(bytes[3])"
        }
        return nil
    }
}
