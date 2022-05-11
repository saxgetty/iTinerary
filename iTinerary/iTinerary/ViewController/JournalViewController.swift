//
//  JournalViewController.swift
//  iTinerary
//
//  Created by Melissa Ho on 5/4/22.
//
// Resource: https://www.youtube.com/watch?v=pZVXENscpTM

import Foundation
import UIKit

class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
    
    var models: [(title: String, note: String)] = []
    
    private var models2 = [JournalItem]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "Journal"
        getAllItems()
        if(!models2.isEmpty){
            self.label.isHidden = true
            self.tableView.isHidden = false
        }else{
            self.label.isHidden = false
            self.tableView.isHidden = true
        }
    }
    
    @IBAction func didTapNewNote(){
        guard let EntryViewController = storyboard?.instantiateViewController(withIdentifier: "new") as? EntryViewController else {
            return
        }
        EntryViewController.title = "New Note"
        EntryViewController.navigationItem.largeTitleDisplayMode = .never
        EntryViewController.completion = {
            noteTitle, note in
            self.navigationController?.popViewController(animated: true)
            self.createItem(name: noteTitle, desc: note)
            
            
            self.getAllItems()
            self.label.isHidden = true
            self.tableView.isHidden = false
            
        }
        navigationController?.pushViewController(EntryViewController, animated: true)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models2[indexPath.row].name
        cell.detailTextLabel?.text = models2[indexPath.row].desc
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = models2[indexPath.row]
        let sheet = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Inspect", style: .default, handler: {
            _ in
            tableView.deselectRow(at: indexPath, animated: true)

            guard let NoteViewController = self.storyboard?.instantiateViewController(withIdentifier: "note") as? NoteViewController else {
                return
            }
            let model = self.models2[indexPath.row]
            NoteViewController.navigationItem.largeTitleDisplayMode = .never
            NoteViewController.title = "Note"
            NoteViewController.noteTitle = model.name!
            NoteViewController.note = model.desc!
            self.navigationController?.pushViewController(NoteViewController, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Edit Item", message: "Enter Your Item", preferredStyle: .alert)

            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.desc
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self]_ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }

                self?.updateItem(item: item, newName: newName)
            }))

            self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))

        present(sheet, animated: true)
    }
    
    // Core Data
    func getAllItems() {
        
        do {
            models2 = try context.fetch(JournalItem.fetchRequest())
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
        catch {
            // Add any errors here
        }
    }
    
    func createItem(name: String, desc: String) {
        let newItem = JournalItem (context: context)
        newItem.name = name
        newItem.desc = desc
        newItem.createdAt = Date()
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            
        }
    }
    
    func deleteItem(item: JournalItem) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            
        }
    }
    
    func updateItem(item: JournalItem, newName: String) {
        item.desc = newName
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            
        }
    }
}
