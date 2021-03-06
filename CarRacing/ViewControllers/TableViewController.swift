







import UIKit
import FirebaseCrashlytics
import RxSwift
import RxCocoa

class TableViewController: UIViewController, UIScrollViewDelegate {
   
    @IBOutlet var tableView: UITableView!
    
    private let bag = DisposeBag()
    private let viewModel = GameViewController()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            tableView.rx.setDelegate(self).disposed(by: bag)
            
            bindTableView()
        }
    
    private func bindTableView() {
        tableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: "cellId")
                
        viewModel.rxResult.bind(to: tableView.rx.items(cellIdentifier: "cellId", cellType: ResultTableViewCell.self)) { (row,result,cell) in
                    cell.rxResult = result
                }.disposed(by: bag)
                
                tableView.rx.modelSelected(RaceResult.self).subscribe(onNext: { result in
                    print("SelectedItem: \(result.name)")
                }).disposed(by: bag)
                
       }
    
    
   
        
    
    
    
    
    
    
    
    
    /*
    // These strings will be the data for the table view cells
    var results = [RaceResult]()
    private let KeyForUserDefaults = "myKey"
    let cellReuseIdentifier = "cell"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readRecord()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func readRecord() {
        guard AppSettings.shared.scores.count > 0 else {
            let userInfo = [
                NSLocalizedDescriptionKey: NSLocalizedString("The request failed.", comment: ""),
                NSLocalizedFailureReasonErrorKey: NSLocalizedString("No records found", comment: ""),
                NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString("Does this data exist?", comment: ""),
                "ProductID": "CarRacing",
                "View": "TableViewController"
            ]
            let error = NSError.init(domain: NSCocoaErrorDomain,
                                     code: -1001,
                                     userInfo: userInfo)
            Crashlytics.crashlytics().record(error: error)
            return
        }
        results = AppSettings.shared.scores
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) ?? UITableView()) as! UITableViewCell
        let currentResult = results[indexPath.row]
        cell.textLabel?.text = "Name:\(currentResult.name) Score:\(currentResult.score) Date:\(currentResult.getStringDate())"
        
        //cell.textLabel?.text = self.results[indexPath.row]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    // this method handles row deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // remove the item from the data model
            results.remove(at: indexPath.row)
            AppSettings.shared.scores.remove(at: indexPath.row)
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    */
}
extension TableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
