//
//  GelenSiparis.swift
//  ShoppingAppAdmin
//
//  Created by Gizemnur Özden on 2.07.2024.

import UIKit
import FirebaseFirestore

class GelenSiparis: UIViewController {

    @IBOutlet weak var siparisTableView: UITableView!
    
    var siparisler: [Siparis] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        siparisTableView.delegate = self
        siparisTableView.dataSource = self

        fetchSiparisler()
    }

    func fetchSiparisler() {
        let db = Firestore.firestore()
        db.collection("GelenSiparisler").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let musteriMaili = data["kullaniciMaili"] as? String ?? ""
                    let musteriAdres = data["adres"] as? String ?? ""
                    let siparisTarihi = data["siparisTarihi"] as? String ?? ""
                    
                    if let urunler = data["urunler"] as? [[String: Any]] {
                        for urun in urunler {
                            let urunAdi = urun["ad"] as? String ?? ""
                            let urunBedeni = urun["secilenBeden"] as? String ?? ""
                            let urunAdeti = urun["adet"] as? Int ?? 0
                            
                            let siparis = Siparis(musteriMaili: musteriMaili, siparisTarihi: siparisTarihi, urunAdi: urunAdi,  urunAdeti: urunAdeti)
                            self.siparisler.append(siparis)
                        }
                    }
                }
                self.siparisTableView.reloadData()
            }
        }
    }
}
extension GelenSiparis: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return siparisler.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "siparisHucre", for: indexPath) as! GelenSiparisTableViewCell
        
        let siparis = siparisler[indexPath.row]
        cell.musteriMaili.text = siparis.musteriMaili
      
        cell.siparisTarihi.text = siparis.siparisTarihi
        cell.urunAdi.text = siparis.urunAdi
   
        cell.urunAdeti.text = "\(siparis.urunAdeti)"
        
        return cell
    }
}
