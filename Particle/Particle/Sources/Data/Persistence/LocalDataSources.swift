//
//  LocalDataSources.swift
//  Particle
//
//  Created by 이원빈 on 2024/01/12.
//

protocol LocalDataSourceProtocol {
    func getUserDataSource() -> UserDataSource
    func getRecordDataSource() -> RecordDataSource
}

final class LocalStorage: LocalDataSourceProtocol {
    
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage) {
        self.coreDataStorage = coreDataStorage
    }
    
    func getUserDataSource() -> UserDataSource {
        return LocalUserDataSource(coreData: coreDataStorage)
    }
    
    func getRecordDataSource() -> RecordDataSource {
        return LocalRecordDataSource(coreData: coreDataStorage)
    }
}
