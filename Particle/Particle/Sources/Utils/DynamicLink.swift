//
//  DynamicLink.swift
//  Particle
//
//  Created by 이원빈 on 2023/12/09.
//

import FirebaseDynamicLinks
import RxSwift

struct DynamicLinkMaker {
    
    static func execute(particleId: String) -> Observable<String> {
        
        let dynamicLinksDomainURIPrefix = "https://wonbeen.page.link"
        let link = URL(string: "https://github.com/DDD-Community/Particle-iOS/detail?id=\(particleId)")!
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
        
        linkBuilder!.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.wonbeen.Particle")
        linkBuilder!.iOSParameters?.appStoreID = "6464103528" // 앱스토어에 올라가야 실행가능할듯
        linkBuilder!.iOSParameters?.fallbackURL = URL(string: "https://github.com/DDD-Community/Particle-iOS")!
        
        linkBuilder!.navigationInfoParameters = DynamicLinkNavigationInfoParameters()
        linkBuilder!.navigationInfoParameters?.isForcedRedirectEnabled = true
        
        linkBuilder!.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder!.socialMetaTagParameters?.title = "우리 앱에 참여해보세요 !"
        linkBuilder!.socialMetaTagParameters?.imageURL = URL(string: "https://hackmd.io/_uploads/Bylt5yLWUp.png")
        
        let longDynamicLink = linkBuilder!.url!
        
        return Observable.create { emitter in
            DynamicLinkComponents.shortenURL(longDynamicLink, options: nil) { url, warning, error in
                let urlString = url?.absoluteString
                emitter.onNext(urlString!)
            }
            return Disposables.create()
        }
    }
}

final class DynamicLinkParser {
    static let shared = DynamicLinkParser()
    
    private init() {}
    
    let recordId: BehaviorSubject<String?> = .init(value: nil)
    
    func handleDynamicLink(_ dynamicLink: DynamicLink?) {
        
        guard let dynamicLink = dynamicLink,
              let link = dynamicLink.url else { return }

        let queryItems = URLComponents(url: link, resolvingAgainstBaseURL: true)?.queryItems
        let recordID = queryItems?.filter { $0.name == "id" }.first?.value
        recordId.onNext(recordID)
    }
}
