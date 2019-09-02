//
//  HistoryTableViewController.swift
//  Beautiful Calculator
//
//  Created by TAEWON KONG on 8/31/19.
//  Copyright © 2019 TAEWON KONG. All rights reserved.
//

import UIKit

class HistoryTableVC: UIViewController {
    

    @IBOutlet weak var backgroundImage: UIImageView!
    
    var calculationHistory: [String]?
    
    var imageArray: [UIImage]?
    
    var imageNumber: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backgroundImage.image = imageArray?[imageNumber!]
    }
    
}

extension HistoryTableVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculationHistory?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryCell
        
        cell.setCalculation(calculationHistory?[indexPath.row] ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
