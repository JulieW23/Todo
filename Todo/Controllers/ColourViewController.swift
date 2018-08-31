//
//  ColourViewController.swift
//  Todo
//
//  Created by Julie Wang on 2018-08-24.
//  Copyright © 2018 Julie Wang. All rights reserved.
//

import UIKit
import IGColorPicker
import ChameleonFramework

class ColourViewController: UIViewController, ColorPickerViewDelegate, ColorPickerViewDelegateFlowLayout {

    @IBOutlet weak var colourPickerView: ColorPickerView!
    var categoryViewController: CategoryViewController?
    var categoryIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colourPickerView.delegate = self
        colourPickerView.layoutDelegate = self

        colourPickerView.colors = [FlatRed(), FlatOrange(), FlatYellow(), FlatSand(), FlatNavyBlue(), FlatBlack(), FlatMagenta(), FlatTeal(), FlatSkyBlue(), FlatGreen(), FlatMint(), FlatWhite(), FlatGray(), FlatForestGreen(), FlatPurple(), FlatBrown(), FlatPlum(), FlatWatermelon(), FlatLime(), FlatPink(), FlatMaroon(), FlatCoffee(), FlatPowderBlue(), FlatBlue()]
    }

    // MARK - Colour picker deligate
    func colorPickerView(_ colorPickerView: ColorPickerView, didSelectItemAt indexPath: IndexPath) {
        if let catIndexPath = categoryIndexPath {
            categoryViewController?.changeCategoryColour(indexPath: catIndexPath, colour: colourPickerView.colors[indexPath.item])
        }
    }
    
    // MARK - Colour picker flow layout
    func colorPickerView(_ colorPickerView: ColorPickerView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width
        let widthPerItem = availableWidth / 5
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }

    func colorPickerView(_ colorPickerView: ColorPickerView, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
