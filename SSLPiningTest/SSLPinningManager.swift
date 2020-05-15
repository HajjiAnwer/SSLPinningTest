import Foundation
import Alamofire
import IOSSecuritySuite

class SSLPinningManager {
    
    var session = SessionManager()
    static let shared = SSLPinningManager()
    
    func isSecureEnvironement() -> Bool {
        if IOSSecuritySuite.amIDebugged() || IOSSecuritySuite.amIReverseEngineered() {
            return false
        }
        return true
    }
    
    func isJailbrokenDeviceOrEmulator() -> Bool{
        if isSimulator() {
            return false
        }
        if IOSSecuritySuite.amIJailbroken() || IOSSecuritySuite.amIRunInEmulator(){
            return true
        } else {
            return false
        }
    }
    
    private func isSimulator () ->Bool {
        #if arch(i386) || arch(x86_64)
            return true
        #else
            return false
        #endif
    }
    
    func enableCertificatesPinning (){
        let certificates : [SecCertificate] = getCertificates()
        let trustPolicy = ServerTrustPolicy.pinCertificates(
            certificates: certificates,
            validateCertificateChain: true,
            validateHost: true)
        let trustPolicies = ["https://www.google.com": trustPolicy]
        let policyManager = ServerTrustPolicyManager(policies: trustPolicies)
        session = SessionManager(configuration: .default, serverTrustPolicyManager: policyManager)
    }
    
    func enablePublicKeyPinning(){
        let trustPolicy = ServerTrustPolicy.pinPublicKeys(
            publicKeys: savedPublicKeys(),
            validateCertificateChain: true,
            validateHost: true)
        let trustPolicies = ["https://www.google.com": trustPolicy]
        let policyManager = ServerTrustPolicyManager(policies: trustPolicies)
        session = SessionManager(configuration: .default, serverTrustPolicyManager: policyManager)
    }
    
    private func savedPublicKeys() -> [SecKey]    {
        var publicKeys:[SecKey] = []
        ServerTrustPolicy.publicKeys(in: Bundle.main).forEach { (key) in
            publicKeys.append(key)
        }
        return publicKeys
    }
    
    private func getCertificates() -> [SecCertificate] {
        let url = Bundle.main.url(forResource: "google", withExtension: "cer")!
        let localCertificate = try! Data(contentsOf: url) as CFData
        guard let certificate = SecCertificateCreateWithData(nil, localCertificate) else { return [] }
        return [certificate]
    }
    
}
