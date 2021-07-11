//
//  SNTheme.swift
//  YiCore
//
//  Created by Darcy on 2021/7/11.
//

import Foundation

public class SNTheme {

    public enum Themes {
        case imovie
        case yi
        case other(color : String)
    }
    
    public static let `default` = SNTheme()
    var theme = Themes.imovie

    func apply(theme: Themes)  {
        self.theme = theme
    }
}
