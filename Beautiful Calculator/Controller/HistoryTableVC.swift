//
//  HistoryTableViewController.swift
//  Beautiful Calculator
//
//  Created by TAEWON KONG on 8/31/19.
//  Copyright © 2019 TAEWON KONG. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class HistoryTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let realm = try! Realm()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var calculationHistories: Results<CalculationHistory>?
    
    var imageArray: [UIImage]?
    
    var imageNumber: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonPressed))
    }
    
    @objc func deleteButtonPressed() {
        let alert = UIAlertController(title: nil, message: NSLocalizedString("Do you want to delete all?", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: { (action) in
            do {
                try self.realm.write {
                    self.realm.delete(self.calculationHistories!)
                    self.tableView.reloadData()
                }
            } catch {
                print("Error deleting all calculation histories, \(error)")
            }
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backgroundImage.image = imageArray?[imageNumber!]
    }
    
}

extension HistoryTableVC: SwipeTableViewCellDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculationHistories?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toHistory") as! HistoryCell
        
        cell.calculationLabel.text = calculationHistories?[indexPath.row].calculation ?? "No calculation history to be shown."
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Swipe Cell Delegate Method
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            // handle action by updating model with deletion
            if let historyForDeletion = self.calculationHistories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(historyForDeletion)
                    }
                } catch {
                    print("Error deleting calculation history, \(error)")
                }
            }
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "Trash_Icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }

}
