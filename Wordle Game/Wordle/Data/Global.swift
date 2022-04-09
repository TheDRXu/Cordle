//
//  Global.swift
//  WordleGame
//
//  Created by Dwayne Reinaldy on 3/30/22.
//

import UIKit

enum Global {
    
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    static var screenHeight: CGFloat {
        UIScreen.main.bounds.size.height
    }
    
    static var minDimension: CGFloat {
        min(screenWidth,screenHeight)
    }
    
    static var boardWidth: CGFloat {
        switch minDimension {
        case 0...320:
            return screenWidth - 55
        case 321...430:
            return screenWidth - 50
        case 431...1000:
            return 350
        default:
            return 500
        }
    }
    
    static var keyboardScale: CGFloat {
        switch minDimension {
        case 0...430:
            return screenWidth / 390
        case 431...1000:
            return CGFloat(1.2)
        default:
            return CGFloat(1.6)
        }
    }
    
    static let country5letters = ["BENIN","CHILE","CHINA","EGYPT","GABON","GHANA","HAITI","INDIA","ITALY","JAPAN","KENYA","LIBYA","MALTA",
                                  "NAURU","NEPAL","NIGER","PALAU","QATAR","SAMOA","SUDAN","SPAIN","SYRIA","TONGA","YEMEN"]
    
    static let country4letters = ["CHAD","CUBA","FIJI","IRAN","IRAQ","LAOS","MALI","NIUE","OMAN","PERU","TOGO"]
    
    static let country6letters = ["ANGOLA","BELIZE","BHUTAN","BRAZIL","BRUNEI","CANADA","CYPRUS","FRANCE","GAMBIA","GREECE","GUINEA","GUYANA","ISRAEL","JORDAN","KOSOVO","KUWAIT","LATVIA","MALAWI","MEXICO","MONACO","NORWAY","PANAMA","POLAND","RUSSIA","RWANDA","SERBIA","SWEDEN","TAIWAN","TURKEY","TUVALU","UGANDA","ZAMBIA"]
}
