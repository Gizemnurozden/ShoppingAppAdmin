//
//  ViewController.swift
//  ShoppingAppAdmin
//
//  Created by Gizemnur Özden on 1.07.2024.
//
import UIKit
import Firebase
import FirebaseStorage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var urunAdiLabel: UITextField!
    @IBOutlet weak var urunFiyatText: UITextField!
    @IBOutlet weak var urunImage: UIImageView!
    @IBOutlet weak var urunKategoriSecim: UIButton!
    @IBOutlet weak var urunAciklamasi: UITextField!
    @IBOutlet weak var urunStok: UITextField!
    @IBOutlet weak var urunBeden: UITextField!

    var selectedCategory: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // UIImageView'i tıklanabilir hale getir
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        urunImage.isUserInteractionEnabled = true
        urunImage.addGestureRecognizer(tapGestureRecognizer)
    }

    @IBAction func selectImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
   

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            urunImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func urunuEkleButton(_ sender: Any) {
        guard let urunAdi = urunAdiLabel.text, !urunAdi.isEmpty,
              let urunFiyatText = urunFiyatText.text, !urunFiyatText.isEmpty,
              let urunFiyat = Double(urunFiyatText),
              let urunAciklama = urunAciklamasi.text, !urunAciklama.isEmpty,
              let urunStokText = urunStok.text, !urunStokText.isEmpty,
              let urunStok = Int(urunStokText),
              let urunBeden = urunBeden.text, !urunBeden.isEmpty,
              let urunImage = urunImage.image,
              let category = selectedCategory else {
            let alert = UIAlertController(title: "Hata", message: "Lütfen tüm alanları doğru doldurun.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

        let storageRef = Storage.storage().reference().child("\(UUID().uuidString).jpg")
        guard let imageData = urunImage.jpegData(compressionQuality: 0.75) else { return }

        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                }
                guard let imageUrl = url?.absoluteString else { return }

                let db = Firestore.firestore()
                let urunVerisi: [String: Any] = [
                    "ad": urunAdi,
                    "fiyat": urunFiyat,
                    "detay": urunAciklama,
                    "stok": urunStok,
                    "bedenler": urunBeden,
                    "resim": imageUrl
                ]

                db.collection(category).addDocument(data: urunVerisi) { error in
                    if let error = error {
                        let alert = UIAlertController(title: "Hata", message: "Ürün eklenirken hata oluştu: \(error.localizedDescription)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Başarılı", message: "Ürün başarıyla eklendi.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
                            self.urunAdiLabel.text = ""
                            self.urunFiyatText.text = ""
                            self.urunAciklamasi.text = ""
                            self.urunStok.text = ""
                            self.urunBeden.text = ""
                            self.urunImage.image = nil
                            self.urunKategoriSecim.setTitle("Kategori Seçin", for: .normal)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    @IBAction func selectCategory(_ sender: UIButton) {
        let alert = UIAlertController(title: "Kategori Seçin", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Kaban", style: .default, handler: { _ in
            self.selectedCategory = "KABAN"
            self.urunKategoriSecim.setTitle("Kaban", for: .normal)
        }))
        alert.addAction(UIAlertAction(title: "Mont", style: .default, handler: { _ in
            self.selectedCategory = "MONT"
            self.urunKategoriSecim.setTitle("Mont", for: .normal)
        }))
        alert.addAction(UIAlertAction(title: "Yağmurluk", style: .default, handler: { _ in
            self.selectedCategory = "YAĞMURLUK"
            self.urunKategoriSecim.setTitle("Yağmurluk", for: .normal)
        }))
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
