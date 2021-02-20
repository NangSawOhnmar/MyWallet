//
//  DisplayRecordViewController.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import UIKit
import CoreData

class DisplayRecordViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var prefixLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    var container: NSPersistentContainer!
    var accountsList = [Accounts]()
    var expenseCategoriesList = [Categories]()
    var incomeCategoriesList = [Categories]()
    var currentUid = ""
    var model: AddRecordModel = Facade.share.model.addRecordModel
    var record: Records!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupCategoriesList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataFilling()
        self.navigationController?.title = "Edit Record"
    }
    
    private func dataFilling() {
        guard let record = Facade.share.model.getRecord(uid: currentUid) else {
            return
        }
        self.record = record
        
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        
        self.amountLabel.text = String("\(numberFormatter.string(from: NSNumber(value: record.amount))!)")
        if record.direction == 1 {
            model.direction = 1
            
            for (index, cat) in incomeCategoriesList.enumerated()
            where cat.uid == record.relatedCategory?.uid {
                model.incomeIndex = index
                break
            }
        } else {
            model.direction = 0
            
            for (index, cat) in expenseCategoriesList.enumerated()
            where cat.uid == record.relatedCategory?.uid {
                model.expenseIndex = index
                break
            }
        }
        model.datetime = record.datetime ?? Date()
        model.uid = record.uid
        
        // datePicker
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        self.dateLabel.text = formatter.string(from: model.datetime)
        
        if model.direction == 0 {
            self.categoryLabel.text = (expenseCategoriesList.count > 0) ? expenseCategoriesList[model.expenseIndex].name : ""
            prefixLabel.text = "-" + NSLocale.defaultCurrency
            prefixLabel.textColor = UIColor.myAppBlack
        } else {
            self.categoryLabel.text = (incomeCategoriesList.count > 0) ? incomeCategoriesList[model.incomeIndex].name : ""
            prefixLabel.text = "+" + NSLocale.defaultCurrency
            prefixLabel.textColor = UIColor.myAppGreen
        }
    }
    
    public func setupCategoriesList() {
        do {
            let fetchRequest: NSFetchRequest<Categories> = Categories.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "direction == %d", 1)
            let sort = NSSortDescriptor(key: "sortId", ascending: false)
            fetchRequest.sortDescriptors = [sort]
            incomeCategoriesList = try Facade.share.model.container.viewContext.fetch(fetchRequest)
            
            fetchRequest.predicate = NSPredicate(format: "direction == %d", -1)
            fetchRequest.sortDescriptors = [sort]
            expenseCategoriesList = try Facade.share.model.container.viewContext.fetch(fetchRequest)
        } catch {
            print ("fetch task failed", error)
        }
    }
    
    @IBAction func tappedEditButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "AddRecord") as? AddRecordViewController {
            controller.currentUid = record.uid ?? ""
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
