//
//  Fireball.swift
//  Toothless
//
//  Created by igmstudent on 2/22/16.
//  Copyright © 2016 igmstudent. All rights reserved.
//

import SpriteKit
import Foundation
class Fireball : SKSpriteNode {
    init()
    {
        let texture = SKTexture(imageNamed: "fireball")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}