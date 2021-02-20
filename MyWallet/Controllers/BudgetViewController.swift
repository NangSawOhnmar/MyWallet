//
//  BudgetViewController.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import UIKit
import CoreData

class BudgetViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var editingMode = false
    var fetchedResultsController: NSFetchedResultsController<Categories>!
    var totalBudget = 0.0
    var maxBudget = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    @IBAction func tappedEditButton(_ sender: Any) {
        if editingMode == true {
            loadData()
            editingEnd()
        } else {
            editingBegin()
        }
    }
    
    func editingBegin() {
        editingMode = true
        editButton.style = .done
        editButton.title = "Save"
        tableView.reloadData()
    }

    func editingEnd() {
        editingMode = false
        editButton.style = .plain
        editButton.title = "Edit"
    }
    
    func loadData() {
        // prepare result controller
        let request: NSFetchRequest<Categories> = Categories.fetchRequest()
        let sort = NSSortDescriptor(key: "sortId", ascending: false)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 20

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: Facade.share.model.container.viewContext,
            sectionNameKeyPath: "direction",
            cacheName: nil)
        fetchedResultsController.delegate = self

        let predicate = NSPredicate(format: "direction = %d", -1)
        fetchedResultsController.fetchRequest.predicate = predicate

        do {
            try fetchedResultsController.performFetch()

            // set total & max budget
            totalBudget = Facade.share.model.getTotalBudget()
            maxBudget = Facade.share.model.getMaxAmountInBudget()

            tableView.reloadData()
            loadFooter()
        } catch {
            print("Fetch failed")
        }
    }

    func loadFooter() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45))
        footerView.backgroundColor = UIColor.white

        let labelView = UILabel(frame: CGRect(x: 0, y: 5, width: tableView.frame.width, height: 30))
        labelView.textAlignment = .center
        labelView.text = "Total: \(NSLocale.defaultCurrency)\(totalBudget.clean)"

        footerView.addSubview(labelView)
        tableView.tableFooterView = footerView
    }
}

extension BudgetViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CostCell.IDENTIFIER, for: indexPath) as! CostCell
        cell.budgetDelegate = self
        let category = fetchedResultsController.object(at: indexPath)
        cell.categoryLabel.text = category.name
        cell.amountLabel.text = NSLocale.defaultCurrency

        if category.budget != 0 {
            cell.budgetAmount.text = "\(category.budget.clean)"
        } else {
            cell.budgetAmount.text = ""
            cell.budgetPercentage.progress = 0
        }

        if category.budget != 0 && totalBudget != 0 {
            let share = category.budget / totalBudget
            let maxShare = maxBudget / totalBudget
            cell.budgetPercentage.progress = Float(share * (1 / maxShare))
        } else {
            cell.budgetPercentage.progress = 0
        }

        cell.budgetAmount.isEnabled = editingMode
        cell.iconView.image = category.iconImage()

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard editingMode else { return }
        let cell = tableView.dequeueReusableCell(withIdentifier: CostCell.IDENTIFIER, for: indexPath) as? CostCell
        cell?.makeFirstResponder()
    }
}

extension BudgetViewController: BudgetFieldDelegate {
    func didEndEditing(cell: CostCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }

        let category = fetchedResultsController.object(at: indexPath)
        category.budget = cell.budgetAmount.text?.getDoubleFromLocal() ?? 0
        Facade.share.model.saveContext()

        self.loadData()
    }
}
