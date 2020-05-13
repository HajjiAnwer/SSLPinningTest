import Foundation
import Alamofire

class SSLPinningManager {
    
    var session = SessionManager()
    static let shared = SSLPinningManager()
    
    func enableCertificatesPinning (){
        let certificates : [SecCertificate] = getCertificates()
        let trustPolicy = ServerTrustPolicy.pinCertificates(
            certificates: certificates,
            validateCertificateChain: true,
            validateHost: true)
        let trustPolicies = ["www.google.com": trustPolicy]
        let policyManager = ServerTrustPolicyManager(policies: trustPolicies)
        session = SessionManager(configuration: .default, serverTrustPolicyManager: policyManager)
    }
    
    func testEnableCertificatesPinning (){
        let certificates : [SecCertificate] = []
        let trustPolicy = ServerTrustPolicy.pinCertificates(
            certificates: certificates,
            validateCertificateChain: true,
            validateHost: true)
        let trustPolicies = ["www.google.com": trustPolicy]
        let policyManager = ServerTrustPolicyManager(policies: trustPolicies)
        session = SessionManager(configuration: .default, serverTrustPolicyManager: policyManager)
    }
    
    private func getCertificates() -> [SecCertificate] {
        let url = Bundle.main.url(forResource: "google", withExtension: "cer")!
        let localCertificate = try! Data(contentsOf: url) as CFData
        guard let certificate = SecCertificateCreateWithData(nil, localCertificate)
           else { return [] }

        return [certificate]
    }
    
}
