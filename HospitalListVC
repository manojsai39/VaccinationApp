
import UIKit

class HospitalListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalCell") as! HospitalCell
        let data = self.arrData[indexPath.row]
        let tap = UITapGestureRecognizer()
        tap.addAction {
            
            
            if let vc = UIStoryboard.main.instantiateViewController(withClass: HospitalDetailsVC.self){
                vc.data = data
                vc.isEdit = self.isEdit
                vc.orderData = self.data
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        cell.lblName.text = data.hospitalName
        cell.vwMain.isUserInteractionEnabled = true
        cell.vwMain.addGestureRecognizer(tap)
        
        cell.selectionStyle = .none
        return cell
    }
    

    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var btnProcced: UIButton!
    
    
    var arrData = [HospitalModel]()
    var data: OrderModel!
    var isEdit = false
    
    @IBAction func btnProceed(_ sender: UIButton) {
        if isEdit {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: ModifyDetailsVC.self) {
                vc.data = data
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if let vc = UIStoryboard.main.instantiateViewController(withClass: AddBookingDetailsVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnProcced.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getHospitalData()
    }
    
    
    func getHospitalData() {
        _ = AppDelegate.shared.db.collection(kHospital).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.arrData.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let hospitalID : String = data1[kHospitalId] as? String, let name: String = data1[kHospitalName] as? String, let address: String = data1[kAddress] as? String, let city : String = data1[kCity] as? String, let zipcode: String = data1[kZipcode] as? String {
                        self.arrData.append(HospitalModel(id: hospitalID, hospitalName: name, address: address, city: city, zipcode: zipcode))
                    }
                }
                self.tblList.delegate = self
                self.tblList.dataSource = self
                self.tblList.reloadData()
            }
        }
    }

}




class HospitalCell: UITableViewCell {
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblName: UILabel!
   
    var isSelect = false
    
    override func awakeFromNib() {
        self.vwMain.layer.cornerRadius = 5
        self.vwMain.backgroundColor = UIColor.colorLine
        self.vwMain.layer.borderWidth = 1
        self.vwMain.layer.borderColor = UIColor.darkGray.cgColor
    }
}

