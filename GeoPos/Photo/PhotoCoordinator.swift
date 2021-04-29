//
//  PhotoCoordinator.swift
//  GeoPos
//
//  Created by Matthew on 29.04.2021.
//  Copyright © 2021 Ostagram Inc. All rights reserved.
//

import UIKit


final class PhotoCoordinator: BaseCoordinator {
    
    var onFinishFlow: ((UIImage?) -> Void)?
    
    override func start() {
        makeAvatar()
    }
    
    private func makeAvatar() {
        let imagePickerController = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
        } else {
            imagePickerController.sourceType = .savedPhotosAlbum
        }
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        UIApplication.shared.keyWindow?.rootViewController?.present(imagePickerController, animated: true)
    }
}


extension PhotoCoordinator: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let image = extractImage(from: info)
        onFinishFlow?(image)
        picker.dismiss(animated: true)
    }
    
    private func extractImage(from info: [UIImagePickerController.InfoKey: Any]) -> UIImage? {
        // Пытаемся извлечь отредактированное изображение
        if let image = info[.editedImage] as? UIImage {
            return image
            // Пытаемся извлечь оригинальное
        } else if let image = info[.originalImage] as? UIImage {
            return image
        } else {
            // Если изображение не получено, возвращаем nil
            return nil
        }
    }
}
