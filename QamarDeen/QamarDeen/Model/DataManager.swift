//
//  DataManager.swift
//  QamarDeen
//
//  Created by Mazyad Alabduljaleel on 12/28/16.
//  Copyright © 2016 Batoul Apps. All rights reserved.
//

import Foundation
import CoreData


/// DataManager
/// wraps the core data layer providing convenience access to
/// rest of the app.
/// For simplicity, we will only use a single MOC, with MainQueue
/// concurrency type
class DataManager {
    
    static let instance = DataManager()
    
    
    let moc: NSManagedObjectContext
    
    init() {
        
        let modelURL = Bundle.main.url(forResource: "QamarDeen", withExtension: "momd")!
        let objectModel = NSManagedObjectModel(contentsOf: modelURL)!
        let psc = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        
        moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = psc
        
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let storeUrl = docsUrl.appendingPathComponent("QamarDeen.sqlite")
        
        try! psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: "QamarDeen", at: storeUrl, options: [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ])
    }
}
