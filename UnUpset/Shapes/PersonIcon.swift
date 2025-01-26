//
//  PersonIcon.swift
//  UnUpset
//
//  Created by Андрей Степанов on 26.01.2025.
//

import SwiftUI

struct PersonIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.16947*width, y: height))
        path.addCurve(to: CGPoint(x: 0.10386*width, y: 0.98109*height), control1: CGPoint(x: 0.14163*width, y: height), control2: CGPoint(x: 0.11976*width, y: 0.9937*height))
        path.addCurve(to: CGPoint(x: 0.08*width, y: 0.92932*height), control1: CGPoint(x: 0.08795*width, y: 0.96847*height), control2: CGPoint(x: 0.08*width, y: 0.95121*height))
        path.addCurve(to: CGPoint(x: 0.10883*width, y: 0.82826*height), control1: CGPoint(x: 0.08*width, y: 0.89712*height), control2: CGPoint(x: 0.08961*width, y: 0.86344*height))
        path.addCurve(to: CGPoint(x: 0.19283*width, y: 0.7292*height), control1: CGPoint(x: 0.12838*width, y: 0.79309*height), control2: CGPoint(x: 0.15638*width, y: 0.76006*height))
        path.addCurve(to: CGPoint(x: 0.32554*width, y: 0.65404*height), control1: CGPoint(x: 0.22961*width, y: 0.69834*height), control2: CGPoint(x: 0.27385*width, y: 0.67329*height))
        path.addCurve(to: CGPoint(x: 0.4995*width, y: 0.62517*height), control1: CGPoint(x: 0.37723*width, y: 0.63479*height), control2: CGPoint(x: 0.43522*width, y: 0.62517*height))
        path.addCurve(to: CGPoint(x: 0.67396*width, y: 0.65404*height), control1: CGPoint(x: 0.56412*width, y: 0.62517*height), control2: CGPoint(x: 0.62227*width, y: 0.63479*height))
        path.addCurve(to: CGPoint(x: 0.80618*width, y: 0.7292*height), control1: CGPoint(x: 0.72566*width, y: 0.67329*height), control2: CGPoint(x: 0.76973*width, y: 0.69834*height))
        path.addCurve(to: CGPoint(x: 0.89067*width, y: 0.82826*height), control1: CGPoint(x: 0.84295*width, y: 0.76006*height), control2: CGPoint(x: 0.87112*width, y: 0.79309*height))
        path.addCurve(to: CGPoint(x: 0.92*width, y: 0.92932*height), control1: CGPoint(x: 0.91022*width, y: 0.86344*height), control2: CGPoint(x: 0.92*width, y: 0.89712*height))
        path.addCurve(to: CGPoint(x: 0.89614*width, y: 0.98109*height), control1: CGPoint(x: 0.92*width, y: 0.95121*height), control2: CGPoint(x: 0.91205*width, y: 0.96847*height))
        path.addCurve(to: CGPoint(x: 0.83053*width, y: height), control1: CGPoint(x: 0.88023*width, y: 0.9937*height), control2: CGPoint(x: 0.85837*width, y: height))
        path.addLine(to: CGPoint(x: 0.16947*width, y: height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.5*width, y: 0.53656*height))
        path.addCurve(to: CGPoint(x: 0.40009*width, y: 0.50719*height), control1: CGPoint(x: 0.46388*width, y: 0.53656*height), control2: CGPoint(x: 0.43058*width, y: 0.52677*height))
        path.addCurve(to: CGPoint(x: 0.32703*width, y: 0.42804*height), control1: CGPoint(x: 0.36994*width, y: 0.48761*height), control2: CGPoint(x: 0.34559*width, y: 0.46123*height))
        path.addCurve(to: CGPoint(x: 0.29969*width, y: 0.31654*height), control1: CGPoint(x: 0.3088*width, y: 0.39486*height), control2: CGPoint(x: 0.29969*width, y: 0.35769*height))
        path.addCurve(to: CGPoint(x: 0.32703*width, y: 0.20703*height), control1: CGPoint(x: 0.29969*width, y: 0.27605*height), control2: CGPoint(x: 0.3088*width, y: 0.23955*height))
        path.addCurve(to: CGPoint(x: 0.40059*width, y: 0.12887*height), control1: CGPoint(x: 0.34559*width, y: 0.17417*height), control2: CGPoint(x: 0.37011*width, y: 0.14812*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.1*height), control1: CGPoint(x: 0.43108*width, y: 0.10962*height), control2: CGPoint(x: 0.46421*width, y: 0.1*height))
        path.addCurve(to: CGPoint(x: 0.5999*width, y: 0.12837*height), control1: CGPoint(x: 0.53612*width, y: 0.1*height), control2: CGPoint(x: 0.56942*width, y: 0.10946*height))
        path.addCurve(to: CGPoint(x: 0.67297*width, y: 0.20603*height), control1: CGPoint(x: 0.63039*width, y: 0.14729*height), control2: CGPoint(x: 0.65474*width, y: 0.17317*height))
        path.addCurve(to: CGPoint(x: 0.7008*width, y: 0.31554*height), control1: CGPoint(x: 0.69153*width, y: 0.23855*height), control2: CGPoint(x: 0.7008*width, y: 0.27506*height))
        path.addCurve(to: CGPoint(x: 0.67297*width, y: 0.42804*height), control1: CGPoint(x: 0.7008*width, y: 0.35702*height), control2: CGPoint(x: 0.69153*width, y: 0.39453*height))
        path.addCurve(to: CGPoint(x: 0.5999*width, y: 0.50719*height), control1: CGPoint(x: 0.65474*width, y: 0.46123*height), control2: CGPoint(x: 0.63039*width, y: 0.48761*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.53656*height), control1: CGPoint(x: 0.56942*width, y: 0.52677*height), control2: CGPoint(x: 0.53612*width, y: 0.53656*height))
        path.closeSubpath()
        return path
    }
}
