//
//  CoreDataManager.swift
//  ployz
//
//  Created by Mücahit Alperen Eryılmaz on 22.01.2023.
//

import UIKit
import CoreData

class FavoritesCoreData {
    static let shared = FavoritesCoreData()
    let context: NSManagedObjectContext!
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func setFavorite(gameId: Int, imageId: String) -> Bool? {
        let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: context)!
        let game = NSManagedObject(entity: entity, insertInto: context)
        game.setValue(gameId, forKey: "gameId")
        game.setValue(imageId, forKey: "imageId")
        
        do {
            try context.save()
            return true
        } catch let error as NSError {
            NotificationCenter.default.post(name: NSNotification.Name("detailGamesErrorMessage"), object: error.localizedDescription)
        }
        return nil
    }
    
    func getFavorite() -> [Favorites] {
        let getRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
        do {
            let games = try context.fetch(getRequest)
            return games as! [Favorites]
        } catch let error as NSError {
            NotificationCenter.default.post(name: NSNotification.Name("favoritesErrorMessage"), object: error.localizedDescription)
        }
        return []
    }
    
    func removeFavorite(game: Favorites) {
        context.delete(game)
        do {
            try context.save()
        } catch let error as NSError {
            NotificationCenter.default.post(name: NSNotification.Name("favoritesErrorMessage"), object: error.localizedDescription)
        }
    }
    
    func removeFavoriteGameById(id: Int) -> Bool? {
        let getRequest: NSFetchRequest<Favorites>
        getRequest = Favorites.fetchRequest()
        getRequest.predicate = NSPredicate(format: "gameId = %d", id)
        
        do {
            let games = try context.fetch(getRequest)
            
            for game in games {
                removeFavorite(game: game)
            }
            return false
        } catch let error as NSError {
            NotificationCenter.default.post(name: NSNotification.Name("detailGamesErrorMessage"), object: error.localizedDescription)
            return nil
        }
    }
    
    func isFavorite(_ id:Int) -> Bool? {
        let getRequest: NSFetchRequest<Favorites>
        getRequest = Favorites.fetchRequest()
        getRequest.predicate = NSPredicate(format: "gameId = %d", id)
        
        do {
            let game = try context.fetch(getRequest)
            if game.count > 0 {
                return true
            }
            return false
        } catch let error as NSError {
            NotificationCenter.default.post(name: NSNotification.Name("detailGamesErrorMessage"), object: error.localizedDescription)
            return nil
        }
    }
}

class NotesCoreData {
    static let shared = NotesCoreData()
    let context: NSManagedObjectContext!
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func addNote(gameId: Int, gameName: String, noteDetail: String) -> Bool? {
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)!
        let note = NSManagedObject(entity: entity, insertInto: context)
        note.setValue(gameId, forKey: "gameId")
        note.setValue(gameName, forKey: "gameName")
        note.setValue(noteDetail, forKey: "noteDetail")
        
        do {
            try context.save()
            return true
        } catch let error as NSError {
            NotificationCenter.default.post(name: NSNotification.Name("detailGamesErrorMessage"), object: error.localizedDescription)
        }
        return nil
    }
    
    func getNotes() -> [Notes] {
        let getRequest = NSFetchRequest<NSManagedObject>(entityName: "Notes")
        do {
            let notes = try context.fetch(getRequest)
            return notes as! [Notes]
        } catch let error as NSError {
            NotificationCenter.default.post(name: NSNotification.Name("notesErrorMessage"), object: error.localizedDescription)
        }
        return []
    }
}
