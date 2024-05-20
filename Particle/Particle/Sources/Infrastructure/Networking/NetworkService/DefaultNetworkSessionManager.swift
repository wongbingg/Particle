//
//  DefaultNetworkSessionManager.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/08.
//

import Foundation
import RxSwift

public class DefaultNetworkSessionManager: NetworkSessionManager {
    
    public init() {}
    
    public func request(_ request: URLRequest) -> Observable<NetworkingOutput> {
        
        return Observable.create { emitter in

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    emitter.onError(error)
                }
                if let data = data, let response = response {
                    emitter.onNext((data, response))
                }
                // TODO: data, response 둘중 하나가 nil일 때 처리 안되어있음. 
            }
            task.resume()
            return Disposables.create {
                Console.log("\(#function) 작업 취소")
                task.cancel()
            }
        }
    }
}
