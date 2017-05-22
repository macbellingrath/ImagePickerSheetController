//
//  ImagePickerAction.swift
//  ImagePickerSheet
//
//  Created by Laurin Brandner on 24/05/15.
//  Copyright (c) 2015 Laurin Brandner. All rights reserved.
//

import Foundation

public enum ImagePickerActionStyle {
    case `default`
    case cancel
}

open class ImagePickerAction {
    
    public typealias Title = (Int) -> String
    public typealias Handler = (ImagePickerAction) -> ()
    public typealias SecondaryHandler = (ImagePickerAction, Int) -> ()
    
    /// The title of the action's button.
    open let title: String
    
    /// The title of the action's button when more than one image is selected.
    open let secondaryTitle: Title
    
    /// The style of the action. This is used to call a cancel handler when dismissing the controller by tapping the background.
    open let style: ImagePickerActionStyle
    
    /// Set to 'true' to reset the currently selected images when the action is selected.
    public let reset: Bool
    
    let handler: Handler
    let secondaryHandler: SecondaryHandler
    
    /// Initializes a new ImagePickerAction. The secondary title and handler are used when at least 1 image has been selected.
    /// Secondary title defaults to title if not specified.
    /// Secondary handler defaults to handler if not specified.
    public convenience init(title: String, secondaryTitle: String? = nil, style: ImagePickerActionStyle = .Default, reset: Bool = false, handler: Handler, secondaryHandler: SecondaryHandler? = nil) {
        self.init(title: title, secondaryTitle: secondaryTitle.map { string in { _ in string }}, style: style, reset: reset, handler: handler, secondaryHandler: secondaryHandler)
    }
    
    /// Initializes a new ImagePickerAction. The secondary title and handler are used when at least 1 image has been selected.
    /// Secondary title defaults to title if not specified. Use the closure to format a title according to the selection.
    /// Secondary handler defaults to handler if not specified
    public init(title: String, secondaryTitle: Title?, style: ImagePickerActionStyle = .Default, reset: Bool = false, handler: Handler, var secondaryHandler: SecondaryHandler? = nil) {
        if secondaryHandler == nil {
            secondaryHandler = { action, _ in
                handler(action)
            }
        }
        
        self.title = title
        self.secondaryTitle = secondaryTitle ?? { _ in title }
        self.style = style
        self.reset = reset
        self.handler = handler
        self.secondaryHandler = secondaryHandler
    }
    
    func handle(_ numberOfImages: Int = 0) {
        if numberOfImages > 0 {
            secondaryHandler?(self, numberOfImages)
        }
        else {
            handler?(self)
        }
    }
    
}

func ?? (left: ImagePickerAction.Title?, right: @escaping ImagePickerAction.Title) -> ImagePickerAction.Title {
    if let left = left {
        return left
    }
    
    return right
}
