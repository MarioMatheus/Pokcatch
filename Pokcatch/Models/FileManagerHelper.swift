//
//  FileManagerHelper.swift
//  Pokcatch
//
//  Created by Mario Matheus on 27/10/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import UIKit

class FileManagerHelper {
    
    static func saveImageInFileManager(_ image: UIImage, at path: String) {
        let fileManager = FileManager.default
        let path = (getDirectoryPath() as NSString).strings(byAppendingPaths: [path]).first!
        
        let imageData = UIImage.pngData(image)()
        
        fileManager.createFile(atPath: path, contents: imageData, attributes: nil)
    }
    
    
    private static func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths.first!
        
        return documentsDirectory
    }
    
    
    static func getImageFrom(path: String) -> UIImage? {
        let fileManager = FileManager.default
        let imagePath = (self.getDirectoryPath() as NSString).strings(byAppendingPaths: [path]).first!
        if fileManager.fileExists(atPath: imagePath) {
            return UIImage(contentsOfFile: imagePath)
        }
        
        return nil
    }
    
    
    static func removeFromFileManagerWith(path: String) {
        let fileManager = FileManager.default
        let imagePath = (self.getDirectoryPath() as NSString).strings(byAppendingPaths: [path]).first!
        
        try? fileManager.removeItem(atPath: imagePath)
    }
    
}
