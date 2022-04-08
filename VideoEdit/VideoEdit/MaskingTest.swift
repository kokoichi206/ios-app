//
//  MaskingTest.swift
//  VideoEdit
//
//  Created by Takahiro Tominaga on 2022/04/07.
//

import SwiftUI

struct MaskingTest: View {
    var body: some View {
        ZStack {
//            Image(uiImage: UIImage(named: "ok.png")!)
            Image(uiImage: getMaskedImage())
        }
    }
    
    func getMaskedImage() -> UIImage {
        let image = UIImage(named: "cat.png")!
        let colorMasking: [CGFloat] = [0, 50, 0, 50, 0, 50]
        guard let cgImage = image.cgImage?.copy(maskingColorComponents: colorMasking) else {
            return UIImage(named: "cat.png")! }
        return UIImage(cgImage: cgImage)
    }
}

struct MaskingTest_Previews: PreviewProvider {
    static var previews: some View {
        MaskingTest()
    }
}
