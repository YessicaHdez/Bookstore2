//
//  ViewController.swift
//  bookstore
//
//  Created by user168036 on 4/3/20.
//  Copyright © 2020 Tec. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadBooks().count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")else {
            return UITableViewCell()
        }
        let book: Book = loadBooks()[indexPath.row]
     //  book.title!.sorted(by: {$0 < $1})
        
        cell.textLabel?.text = book.title
        return cell
        
    }
    
     @IBOutlet weak var myTableView: UITableView!
     var managedObjectContext: NSManagedObjectContext!
    var selectedBook: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDejegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDejegate.persistentContainer.viewContext as NSManagedObjectContext
        
    }
       
    func loadBooks() -> [Book] {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        var result: [Book] = []
        
        do{
            result = try managedObjectContext.fetch(fetchRequest)
          
        }catch{
            NSLog("My Error: %@",error as NSError)
        }

        return result
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let books: [Book] = loadBooks()
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if selectedBook.contains(books[indexPath.row]) {
                cell.accessoryType = .none
                if let selectedBookIndex = selectedBook.firstIndex(of: books[indexPath.row]) {
                    selectedBook.remove(at: selectedBookIndex)
                }
            } else {
                cell.accessoryType = .checkmark
                selectedBook.append(books[indexPath.row])
            }
        }
        NSLog("You selected cell number: \(indexPath.row)!")
    }
    @IBAction func addNew(_ sender: UIBarButtonItem) {
        let book: Book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: managedObjectContext) as! Book
        book.title = "My Book" + String(loadBooks().count)
        do{
            try managedObjectContext.save()
        }catch let error as NSError{
            NSLog("Mi Error: %@", error)
            
        }
        myTableView.reloadData()
    }
    
    
    
    @IBAction func removebook(_ sender: UIBarButtonItem){
        let moc = getContext()
       
           for object in selectedBook {
            moc.delete(object)
    }
        do{
            try managedObjectContext.save()
        }catch let error as NSError{
            NSLog("Mi Error: %@", error)
            
        }
        selectedBook.removeAll(keepingCapacity: false)
        myTableView.reloadData()
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}

