//
//  LocalRecordDataSource.swift
//  Particle
//
//  Created by 이원빈 on 2024/01/12.
//


import Foundation
import RxSwift
import CoreData

final class LocalRecordDataSource {
    
    private let coreData: CoreDataStorage
    
    init(coreData: CoreDataStorage) {
        self.coreData = coreData
    }
}

extension LocalRecordDataSource: RecordDataSource {
    
    func getMyRecords() -> RxSwift.Observable<[RecordReadDTO]> {
        return Observable.create { [weak self] emitter in
            do {
                guard let arr = try self?.coreData
                    .persistentContainer
                    .viewContext
                    .fetch(CDRecord.fetchRequest()) else {
                    emitter.onNext([])
                    return Disposables.create()
                }
                let recordList = arr.map {
                    RecordReadDTO(
                        id: $0.id ?? "",
                        title: $0.title ?? "",
                        url: $0.url ?? "",
                        items: [RecordReadDTO.RecordItemReadDTO].decode(from: $0.items ?? ""),
                        tags: ($0.tags ?? "").components(separatedBy: "&"),
                        attribute: RecordReadDTO.Attribute.decode(from: $0.attribute ?? ""),
                        createdAt: $0.createdAt ?? "",
                        createdBy: $0.createdBy ?? ""
                    )
                }
                emitter.onNext(recordList)
            } catch {
                emitter.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func getRecordBy(id: String) -> Observable<RecordReadDTO> {
        return Observable.create { [weak self] emitter in
            do {
                guard let arr = try self?.coreData
                    .persistentContainer
                    .viewContext
                    .fetch(CDRecord.fetchRequest()) else {
                    emitter.onNext(.stub())
                    return Disposables.create()
                }
                let filteredArr = arr.filter { $0.id == id }
                if let filteredRecord = filteredArr.first { // id 없으면 런타임에러 위험
                    let targetRecord = RecordReadDTO(
                        id: filteredRecord.id ?? "",
                        title: filteredRecord.title ?? "",
                        url: filteredRecord.url ?? "",
                        items: [RecordReadDTO.RecordItemReadDTO].decode(from: filteredRecord.items ?? ""),
                        tags: (filteredRecord.tags ?? "").components(separatedBy: "&"),
                        attribute: RecordReadDTO.Attribute.decode(from: filteredRecord.attribute ?? ""),
                        createdAt: filteredRecord.createdAt ?? "",
                        createdBy: filteredRecord.createdBy ?? ""
                    )
                    
                    emitter.onNext(targetRecord)
                } else {
                    emitter.onNext(.stub())
                }
                
            } catch {
                emitter.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func getRecordsBy(tag: String) -> RxSwift.Observable<[RecordReadDTO]> {
        return Observable.create { [weak self] emitter in
            do {
                guard let arr = try self?.coreData
                    .persistentContainer
                    .viewContext
                    .fetch(CDRecord.fetchRequest()) else {
                    emitter.onNext([])
                    return Disposables.create()
                }
                let recordList = arr.map {
                    RecordReadDTO(
                        id: $0.id ?? "",
                        title: $0.title ?? "",
                        url: $0.url ?? "",
                        items: [RecordReadDTO.RecordItemReadDTO].decode(from: $0.items ?? ""),
                        tags: ($0.tags ?? "").components(separatedBy: "&"),
                        attribute: RecordReadDTO.Attribute.decode(from: $0.attribute ?? ""),
                        createdAt: $0.createdAt ?? "",
                        createdBy: $0.createdBy ?? ""
                    )
                }
                
                let filteredList = recordList.filter {
                    $0.tags.contains(tag)
                }
                
                emitter.onNext(filteredList)
            } catch {
                emitter.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func createRecord(record: RecordCreateDTO) -> RxSwift.Observable<RecordReadDTO> {
        
        return Observable.create { [weak self] emitter in
            guard let self = self else { return Disposables.create() }
            
            let colors = ["YELLOW", "BLUE"]
            let managedContext = self.coreData.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "CDRecord", in: managedContext)!
            let cdrecord = NSManagedObject(entity: entity, insertInto: managedContext) as! CDRecord
            cdrecord.id = UUID().uuidString
            cdrecord.title = record.title
            cdrecord.url = record.url
            cdrecord.createdAt = DateManager.shared.todayString()
            cdrecord.createdBy = UserDefaults.standard.string(forKey: "USER_NAME") // 오프라인 상태일 때
            cdrecord.attribute = "\(colors.randomElement() ?? "BLUE")&\(record.style)"
            cdrecord.tags = record.tags.joined(separator: "&") // 모든 태그를 &로 이어주기
            cdrecord.items = record.items.map { $0.encodeForCoreData() }.joined(separator: "&")
            
            do {
                try managedContext.save()
                emitter.onNext(
                    .init(id: cdrecord.id ?? "",
                          title: cdrecord.title ?? "",
                          url: cdrecord.url ?? "",
                          items: [RecordReadDTO.RecordItemReadDTO].decode(from: cdrecord.items ?? ""),
                          tags: cdrecord.tags!.components(separatedBy: "&"),
                          attribute: RecordReadDTO.Attribute.decode(from: cdrecord.attribute ?? ""),
                          createdAt: cdrecord.createdAt ?? "",
                          createdBy: cdrecord.createdBy ?? ""))
            } catch {
                emitter.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func editRecord(id: String, to updatedModel: RecordCreateDTO) -> RxSwift.Observable<RecordReadDTO> {
        return Observable.create { [weak self] emitter in
            guard let self = self else { return Disposables.create() }
            do {
                let arr = try self.coreData
                    .persistentContainer
                    .viewContext
                    .fetch(CDRecord.fetchRequest())
                let colors = ["YELLOW", "BLUE"]
                var targetRecord = arr.filter { $0.id == id }.last!
                targetRecord.title = updatedModel.title
                targetRecord.url = updatedModel.url
                targetRecord.items = updatedModel.items.map { $0.encodeForCoreData() }.joined(separator: "&")
                targetRecord.tags = updatedModel.tags.joined(separator: "&")
                targetRecord.attribute = "\(colors.randomElement() ?? "BLUE")&\(updatedModel.style)"
                
                let context = targetRecord.managedObjectContext
                try context?.save()
                
                let resultRecord = RecordReadDTO(
                    id: targetRecord.id ?? "",
                    title: targetRecord.title ?? "",
                    url: targetRecord.url ?? "",
                    items: [RecordReadDTO.RecordItemReadDTO].decode(from: targetRecord.items ?? ""),
                    tags: targetRecord.tags!.components(separatedBy: "&"),
                    attribute: RecordReadDTO.Attribute.decode(from: targetRecord.attribute ?? ""),
                    createdAt: targetRecord.createdAt ?? "",
                    createdBy: targetRecord.createdBy ?? ""
                )
                emitter.onNext(resultRecord)
            } catch {
                emitter.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    
    
    func deleteRecord(recordId: String) -> RxSwift.Observable<String> {
        return Observable.create { [weak self] emitter in
            guard let self = self else { return Disposables.create() }
            do {
                let arr = try self.coreData
                    .persistentContainer
                    .viewContext
                    .fetch(CDRecord.fetchRequest())
                
                let targetRecord = arr.filter { $0.id == recordId }.last!
                let context = targetRecord.managedObjectContext
                context?.delete(targetRecord)
                
                try context?.save()
                emitter.onNext(recordId)
            } catch {
                emitter.onError(error)
            }
            
            return Disposables.create()
        }
    }
}
