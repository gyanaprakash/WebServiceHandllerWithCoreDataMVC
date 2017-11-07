//
//  CoreDataManager.swift
//  Mihtra
//
//  Created by Gyana Prakash on 1/19/17.
//  Copyright © 2017 Gyana Prakash. All rights reserved.
//

import UIKit
import CoreData

// Gyana

class CoreDataManager: NSObject {
    
    class func saveAllAccessToken(table: String, userInfo: UserTokenSession) {
        let managedContext: NSManagedObjectContext = Storage.shared.context
        let entity = NSEntityDescription.entity(forEntityName: table,
                                                in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        person.setValue(userInfo.accessToken, forKeyPath: "accessToken")
        person.setValue(userInfo.expiresIn, forKeyPath: "expiresIn")
        person.setValue(userInfo.refreshToken, forKeyPath: "refreshToken")
        person.setValue(Date(), forKeyPath: "generateTime")
        do {
            try managedContext.save()
        } catch let error as NSError {
            CommonMethodClass.PrintLog(statment: {
                print("Could not save. \(error), \(error.userInfo)")
            })
        }
    }
    
    
    class func saveAllConnectedDevicInformation(deviceInfo: NSDictionary) {
        let managedContext: NSManagedObjectContext = Storage.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "PAIREDDEVICEIFO",
                                                in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        person.setValue(deviceInfo.value(forKey: "DeviceName")!, forKeyPath: "devicename")
        person.setValue(deviceInfo.value(forKey: "peripheralDetected")!, forKeyPath: "peripheraldetected")
        person.setValue(deviceInfo.value(forKey: "DeviceId"), forKeyPath: "deviceId")
        person.setValue(deviceInfo.value(forKey: "status")!, forKeyPath: "status")
        do {
            try managedContext.save()
        } catch let error as NSError {
            CommonMethodClass.PrintLog(statment: {
                print("Could not save. \(error), \(error.userInfo)")
            })
        }
    }
        
    class func saveAllFitBitData(updatedFor: Date!) {
        let managedContext: NSManagedObjectContext = Storage.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "DATASYNC", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        person.setValue(updatedFor, forKeyPath: "date")
        person.setValue(true, forKeyPath: "syncStatus")
        do {
            try managedContext.save()
        } catch let error as NSError {
            CommonMethodClass.PrintLog(statment: {
                print("Could not save. \(error), \(error.userInfo)")
            })
        }
    }
    
    class func GetDateFromString(DateStr: String)-> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from:DateStr)!
    }
    
    class func saveAllColorMaperConstant(deviceInfo: NSDictionary) {
        let managedContext: NSManagedObjectContext = Storage.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "COLOURMAPER", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(deviceInfo.value(forKey: "testname"), forKeyPath: "testname")
        person.setValue(deviceInfo.value(forKey: "lowvalue"), forKeyPath: "lowvalue")
        person.setValue(deviceInfo.value(forKey: "highvalue"), forKeyPath: "highvalue")
        person.setValue(deviceInfo.value(forKey: "fixedvalue"), forKeyPath: "fixedvalue")
        person.setValue(deviceInfo.value(forKey: "color"), forKeyPath: "color")
        person.setValue(deviceInfo.value(forKey: "colorHexVal"), forKeyPath: "colorHexVal")
        do {
            try managedContext.save()
        } catch let error as NSError {
            CommonMethodClass.PrintLog(statment: {
                print("Could not save. \(error), \(error.userInfo)")
            })
        }
    }
    
    class func fetchUserDataFromStoredDBFor(DbName: String, SuccessWith: @escaping (_ result : [NSManagedObject])->(), failureWith: @escaping (_ result: String)->() ) {
        var deviceManagedObjects : [NSManagedObject] = []
        let managedContext: NSManagedObjectContext = Storage.shared.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DbName)
        do {
            deviceManagedObjects = try managedContext.fetch(fetchRequest)
            SuccessWith(deviceManagedObjects)
        } catch let error as NSError {
            failureWith("Could not fetch. \(error), \(error.userInfo)")
            CommonMethodClass.PrintLog(statment: {
                print("Could not save. \(error), \(error.userInfo)")
            })
        }
    }
    
    class func setEntityNillToClearAttributs(entityName: String!) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let managedContext: NSManagedObjectContext = Storage.shared.context
        // perform the delete
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            CommonMethodClass.PrintLog(statment: {
                print("Could not save. \(error.localizedDescription)")
            })
        }
    }

    class func deleteObject(object:NSManagedObject) {
        let managedContext: NSManagedObjectContext = Storage.shared.context
        CommonMethodClass.PrintLog(statment: {
            print(managedContext)
        })
        managedContext.delete(object)
    }

 }
