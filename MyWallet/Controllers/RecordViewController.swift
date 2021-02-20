//
//  RecordViewController.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import UIKit
import CoreData

class RecordViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var firstRecordLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var commitPredicate: NSPredicate?
    var fetchedResultsController: NSFetchedResultsController<Records>!

    let style: Style = Style.myApp

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return style.preferredStatusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.loadSavedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadSavedData()
    }
    
    func loadSavedData() {
        if fetchedResultsController == nil {
            let request: NSFetchRequest<Records> = Records.fetchRequest()
            let sort = NSSortDescriptor(key: "datetime", ascending: false)
            let sort2 = NSSortDescriptor(key: "uid", ascending: false)

            request.sortDescriptors = [sort, sort2]
            request.fetchBatchSize = 20

            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: Facade.share.model.container.viewContext,
                sectionNameKeyPath: "datetime",
                cacheName: nil)
            fetchedResultsController.delegate = self
        }

        fetchedResultsController.fetchRequest.predicate = commitPredicate

        do {
            try fetchedResultsController.performFetch()
            if fetchedResultsController.fetchedObjects?.count == 0 {
                tableView.separatorStyle = .none
            } else {
                tableView.separatorStyle = .singleLine
            }
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if fetchedResultsController.fetchedObjects?.count == 0 {
            self.firstRecordLabel.isHidden = false
        } else {
            DispatchQueue.main.async {
                self.firstRecordLabel.isHidden = true
            }
        }
    }
}

extension RecordViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordCell.IDENTIFIER, for: indexPath) as? RecordCell else {
            assertionFailure("Cell not found: RecordTableViewCell")
            return UITableViewCell()
        }

        let record = fetchedResultsController.object(at: indexPath)
        if record.direction > 0 {
            cell.amountLabel.textColor = UIColor.myAppGreen
            cell.amountLabel.text = record.amount.recordPresenter(for: .income, formatting: false)
        } else {
            cell.amountLabel.textColor = UIColor.myAppBlack
            cell.amountLabel.text = record.amount.recordPresenter(for: .cost, formatting: false)
        }
        cell.icon.image = record.relatedCategory?.iconImage()
        cell.titleLabel.text = record.relatedCategory?.name

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return nil
        }

        let objects = sectionInfo.objects
        if let topRecord: Records = objects?[0] as? Records {
            return topRecord.datetime?.dayRepresentation()
        } else {
            return sectionInfo.indexTitle
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return nil
        }

        guard let records = sectionInfo.objects as? [Records],
            let topRecord = records.first else {
            return nil
        }
        
        let headerView = MWRecordHeaderView()
        headerView.setup(with: MWRecordHeaderViewModel(
                            title: topRecord.datetime?.dayRepresentation(),
            spending: records.sum().value.recordPresenter(
                for: .all,
                formatting: false
        )))
        return headerView
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let record = fetchedResultsController.object(at: indexPath)
            Facade.share.model.container.viewContext.delete(record)
            Facade.share.model.saveContext()
            do {
                try fetchedResultsController.performFetch()
                tableView.reloadData()
            } catch {
                print("Fetch failed")
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record = fetchedResultsController.object(at: indexPath)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DisplayRecord") as! DisplayRecordViewController

        controller.currentUid = record.uid ?? ""
        navigationController?.pushViewController(controller, animated: true)
    }
}
