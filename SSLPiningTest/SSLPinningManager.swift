import Foundation
import Alamofire

class SSLPinningManager {
    
    var session = Session()
    static let shared = SSLPinningManager()
    
    func enableCertificatesPinning (){
        let certificates : [SecCertificate] = getCertificates()
        let trustPolicy = PinnedCertificatesTrustEvaluator(
            certificates: certificates,
            acceptSelfSignedCertificates: false,
            performDefaultValidation: true,
            validateHost: true)
        let trustPolicies = ["www.google.com": trustPolicy]
        let policyManager = ServerTrustManager(evaluators: trustPolicies)
        session = Session(configuration: .default, serverTrustManager: policyManager)
    }
    
    func testEnableCertificatesPinning (){
        let certificates : [SecCertificate] = []
        let trustPolicy = PinnedCertificatesTrustEvaluator(
            certificates: certificates,
            acceptSelfSignedCertificates: false,
            performDefaultValidation: true,
            validateHost: true)
        let trustPolicies = ["www.google.com": trustPolicy]
        let policyManager = ServerTrustManager(evaluators: trustPolicies)
        session = Session(configuration: .default, serverTrustManager: policyManager)
    }
    
    private func getCertificates() -> [SecCertificate] {
        let url = Bundle.main.url(forResource: "google", withExtension: "cer")!
        let localCertificate = try! Data(contentsOf: url) as CFData
        guard let certificate = SecCertificateCreateWithData(nil, localCertificate)
           else { return [] }

        return [certificate]
    }
    
}
