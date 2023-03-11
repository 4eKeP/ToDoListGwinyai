//
//  ToDoItemModel.swift
//  ToDoListGwinyai
//
//  Created by admin on 20.02.2023.
//

import Foundation
import RealmSwift

public class LocalDataBaseManager{
    static var realm: Realm?{
        get {
            do{
                let realm = try Realm()
                return realm
            }catch{
                return nil
            }
        }
        
    }
}

class Task: Object {
    
    @objc dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    @objc dynamic var name = ""
    @objc dynamic var details = ""
    @objc dynamic var completionDate = Date()
    // если ошибка NSDate()
    @objc dynamic var startDate = Date()
    @objc dynamic var isComplete = false
}
/*
class Task: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var details: String = ""
    @Persisted var completionDate = Date()
    @Persisted var startDate = Date()
    @Persisted var isComplete = false
    
    
    
    convenience init(name: String, details: String, completionDate: Date) {
        
        self.init()
        self.name = name
        self.details = details
        self.completionDate = completionDate
        
    }
}
 */

/*
struct ToDoItemModel {
    
    var name: String
    
    var details: String
    
    var completionDate: Date
    
    var startDate: Date
    
    var isComplete: Bool
    
    init(name: String, details: String, completionDate: Date) {
        
        self.name = name
        
        self.details = details
        
        self.completionDate = completionDate
        
        self.isComplete = false
        
        self.startDate = Date()
    }
    
    
}
*/
