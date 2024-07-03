//
//  ViewController.swift
//  MachineLearningApp
//
//  Created by Mert Erciyes Çağan on 6/10/24.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func changeImage(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        if let ciImage = CIImage(image: imageView.image!) {
            recognizeImage(image: ciImage)
        }
        

    }
    
    func recognizeImage(image: CIImage){
        if let model = try? VNCoreMLModel(for: MobileNetV2().model){
            let request = VNCoreMLRequest(model: model) { VNRequest, error in
                if error != nil {
                    print(error!)
                }
                
                if let results = VNRequest.results as? [VNClassificationObservation] {
                    let topResult = results.first
                    
                    DispatchQueue.main.async {
                        let confidenceLevel = (topResult?.confidence ?? 0) * 100
                        self.resultLabel.text = "\(confidenceLevel)% it's \(topResult?.identifier ?? "anything")"
                        
                            
                    }
                }
            }
            
            let handler = VNImageRequestHandler(ciImage: image)
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    try handler.perform([request])
                } catch {
                    print("error")
                }
            }
            
        }
        
      
    }
}

