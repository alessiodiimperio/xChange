//
//  QuickSpecSnapShoting.swift
//  xChangeSnapShotTest
//
//  Created by Alessio on 2021-05-11.
//

import Foundation
import Quick

protocol QuickSpecSnapshoting {
    
    var shouldRecordAllSnapshots: Bool { get }
}

extension QuickSpec: QuickSpecSnapshoting {
    
    /**
     Use this one for re record all snapshots for every test i.e. when adding a new device or changing a global UI element
     */
    private var shouldRecordEverything: Bool { return false }
    /**
     Override and return true to record snapshots from one Spec
     */
    var shouldRecordAllSnapshots: Bool { return false }
    
    func shouldRecordSnapshot(_ recordThisSnapshot: Bool) -> Bool {
        return recordThisSnapshot || shouldRecordAllSnapshots || shouldRecordEverything
    }
}
