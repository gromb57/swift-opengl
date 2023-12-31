//
//  ViewController+ContextMenu.swift
//  swift-opengl
//
//  Created by Jerome Bach on 13/08/2023.
//

import Foundation
import UIKit
import GLKit

extension ViewController: UIContextMenuInteractionDelegate {
    func setNewRootViewController(vc: UIViewController) {
        UIApplication.shared.windows.first!.rootViewController = nil
        UIApplication.shared.windows.first!.rootViewController = vc
    }

    func setupContextMenu() {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.setImage(UIImage(systemName: "contextualmenu.and.cursorarrow"), for: UIControl.State.normal)
        
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 48.0),
            button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1.0),
            button.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        button.menu = UIMenu(title: "", children: self.actions())
        button.showsMenuAsPrimaryAction = true
        
        let interaction = UIContextMenuInteraction(delegate: self)
        button.addInteraction(interaction)
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: { [weak self] suggestedActions in
                                            
            return UIMenu(title: "", children: self?.actions() ?? [])
        })
    }
    
    func actions() -> [UIMenuElement] {
        return  [
            self.perspectiveAction(),
            self.rotationsSubmenu(),
            self.shapesSubmenu(),
            self.curvesSubmenu()
        ]
    }
    
    func perspectiveAction() -> UIAction {
        return UIAction(title: NSLocalizedString("Perspective: Activate/Deactivate", comment: ""),
                 image: UIImage(systemName: "perspective")) { [weak self] action in
            if let self {
                self.isPerspective = !self.isPerspective
            }
        }
    }
    
    func rotationsSubmenu() -> UIMenu {
        return UIMenu(title: "Rotations", children: [
            self.rotateOnXAction(),
            self.rotateOnYAction(),
            self.rotateOnZAction()
        ])
    }
    
    func rotateOnXAction() -> UIAction {
        return UIAction(title: NSLocalizedString("Rotation on X: Activate/Deactivate", comment: ""),
                 image: UIImage(systemName: "rotate.left")) { [weak self] action in
            if let self {
                self.isRotatingOnX = !self.isRotatingOnX
                self.isRotatingOnY = false
                self.isRotatingOnZ = false
            }
        }
    }
    
    func rotateOnYAction() -> UIAction {
        return UIAction(title: NSLocalizedString("Rotation on Y: Activate/Deactivate", comment: ""),
                 image: UIImage(systemName: "rotate.left")) { [weak self] action in
            if let self {
                self.isRotatingOnX = false
                self.isRotatingOnY = !self.isRotatingOnY
                self.isRotatingOnZ = false
            }
        }
    }
    
    func rotateOnZAction() -> UIAction {
        return UIAction(title: NSLocalizedString("Rotation on Z: Activate/Deactivate", comment: ""),
                 image: UIImage(systemName: "rotate.left")) { [weak self] action in
            if let self {
                self.isRotatingOnX = false
                self.isRotatingOnY = false
                self.isRotatingOnZ = !self.isRotatingOnZ
            }
        }
    }

    // MARK: Shapes
    func shapesSubmenu() -> UIMenu {
        return UIMenu(title: "Shapes", children: [
            self.pyramidAction(),
            self.sphereAction(),
            self.splashAction(),
            self.squareAction()
        ])
    }
    
    func pyramidAction() -> UIAction {
        return UIAction(title: NSLocalizedString("Pyramid", comment: ""),
                image: UIImage(systemName: "pyramid")) { [weak self] action in
            self?.setNewRootViewController(vc: PyramidController())
       }
    }
    
    func sphereAction() -> UIAction {
        return UIAction(title: NSLocalizedString("Sphere", comment: ""),
                image: UIImage(systemName: "circlebadge")) { [weak self] action in
            self?.setNewRootViewController(vc: SphereController())
       }
    }
          
    func splashAction() -> UIAction {
        return UIAction(title: NSLocalizedString("Splash", comment: ""),
                image: UIImage(systemName: "photo.artframe")) { [weak self] action in
            self?.setNewRootViewController(vc: SplashController())
       }
    }
    
    func squareAction() -> UIAction {
        return UIAction(title: NSLocalizedString("Square", comment: ""),
                image: UIImage(systemName: "square")) { [weak self] action in
            self?.setNewRootViewController(vc: SquareController())
       }
    }

    // MARK: Courbes
    func curvesSubmenu() -> UIMenu {
        return UIMenu(title: "Curves", children: [
            self.bezierAction()
        ])
    }
    
    func bezierAction() -> UIAction {
        return UIAction(title: NSLocalizedString("Bezier", comment: ""),
                image: UIImage(systemName: "point.topleft.down.curvedto.point.bottomright.up")) { [weak self] action in
            self?.setNewRootViewController(vc: BezierController())
       }
    }
   
}
