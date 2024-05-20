//
//  DefaultDataTransferErrorLogger.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/09.
//

public final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
    public init() {}
    
    public func log(error: Error) {
        printIfDebug("----------")
        printIfDebug("\(error.localizedDescription)")
    }
}
