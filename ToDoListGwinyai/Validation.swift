//
//  Validation.swift
//  ToDoListGwinyai
//
//  Created by admin on 28.02.2023.
//

import Foundation

enum ValidationError: Error {
    
    case Empty
    
    case Short
    
    case Long
    
    
    
}

class Validation {
    
    func validate(text: String?, minlength: Int, maxLength: Int) throws -> String {
        guard let text = text,
              !text.isEmpty else {
            throw ValidationError.Empty
        }
        if text.count < minlength {
            throw ValidationError.Short
        }
        if text.count > maxLength {
            throw ValidationError.Long
        }
        return text
    }
}
