/*
MVHorizontalPicker - Copyright (c) 2016 Andrea Bizzotto bizz84@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import UIKit
@objc protocol UpdateScrollIndex{
    func UpdateIndex()
}

@IBDesignable @objc open class MVHorizontalPicker: UIControl {
    
    @IBInspectable open var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable open var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable open var font: UIFont? {
        didSet {
            for view in scrollView.subviews {
                if let item = view as? MVPickerItemView {
                    item.font = font
                }
            }
        }
    }
    
    @IBInspectable open var edgesGradientWidth: CGFloat = 0 {
        didSet {
            updateGradient(frame: self.bounds, edgesGradientWidth: edgesGradientWidth)
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateGradient(frame: self.bounds, edgesGradientWidth: edgesGradientWidth)
    }
    
    fileprivate func updateGradient(frame: CGRect, edgesGradientWidth: CGFloat) {
        
        if edgesGradientWidth > 0 && frame.width > 0 {
            let gradient = CAGradientLayer()
            gradient.frame = frame
            let clearColor = UIColor.clear.cgColor
            let backgroundColor = UIColor.white.cgColor
            gradient.colors = [ clearColor, backgroundColor, backgroundColor, clearColor ]
            let gradientWidth = edgesGradientWidth / frame.width
            gradient.locations = [ 0.0,
                                   NSNumber(floatLiteral: Double(gradientWidth)),
                                   NSNumber(floatLiteral: Double(1.0 - gradientWidth)),
                                   1.0]
            gradient.startPoint = CGPoint.zero
            gradient.endPoint = CGPoint(x: 1, y: 0)
            self.layer.mask = gradient
        }
        else {
            self.layer.mask = nil
        }
    }
    
    open var itemWidth: CGFloat {
        get {
            return scrollViewWidthConstraint.constant
        }
        set {
            scrollViewWidthConstraint.constant = newValue
            self.layoutIfNeeded()
            if titles.count > 0 {
                reloadSubviews(titles: titles)
                updateSelectedIndex(_selectedItemIndex, animated: false)
            }
        }
    }
    
    override open var tintColor: UIColor! {
        didSet {
            //triangleIndicator?.tintColor = self.tintColor
            layer.borderColor = tintColor?.cgColor
            let _ = scrollView?.subviews.map{ $0.tintColor = tintColor }
        }
    }
    
    @IBOutlet fileprivate var scrollView: UIScrollView!
    @IBOutlet fileprivate var scrollViewWidthConstraint: NSLayoutConstraint!

    fileprivate var previousItemIndex: Int?

    fileprivate var _selectedItemIndex: Int = 0
    var scrollingIndex: Int = 0
    var delegate : UpdateScrollIndex?
    
    open var selectedItemIndex: Int {
        get {
            return _selectedItemIndex
        }
        set {
            if newValue != _selectedItemIndex {
                _selectedItemIndex = newValue
                
                updateSelectedIndex(newValue, animated: false)
            }
        }
    }
    
    open var titles: [String] = [] {
        didSet {
            
            reloadSubviews(titles: titles)
            
            if let firstItemView = scrollView.subviews.first as? MVPickerItemView {
                firstItemView.selected = true
            }

            previousItemIndex = 0
            _selectedItemIndex = 0
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let bundle = Bundle(for: MVHorizontalPicker.self)
        
        if let view = bundle.loadNibNamed("MVHorizontalPicker", owner: self, options: nil)?.first as? UIView {
            
            self.addSubview(view)
            
            view.anchorToSuperview()
            layer.borderColor = self.tintColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        rendersInInterfaceBuilder = true
    }

    fileprivate func reloadSubviews(titles: [String]) {
        
        let size = scrollView.frame.size
//
        // Remove all subviews
        while let first = scrollView.subviews.first {
            first.removeFromSuperview()
        }

        let holder = scrollView.superview!
        var offsetX: CGFloat = 0
        for title in titles {
            let itemView = MVPickerItemView(text: title, font: font)
            scrollView.addSubview(itemView)
            itemView.tintColor = self.tintColor

            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.addConstraint(itemView.makeConstraint(attribute: .width, toView: nil, constant: size.width))
            scrollView.addConstraint(itemView.makeConstraint(attribute: .leading, toView: scrollView, constant: offsetX))
            scrollView.addConstraint(itemView.makeEqualityConstraint(attribute: .top, toView: scrollView))
            scrollView.addConstraint(itemView.makeEqualityConstraint(attribute: .bottom, toView: scrollView))
            holder.addConstraint(itemView.makeEqualityConstraint(attribute: .height, toView: holder))
            
            offsetX += size.width
        }
        
        if let last = scrollView.subviews.last {
            scrollView.addConstraint(last.makeConstraint(attribute: .trailing, toView: scrollView, constant: 0))
        }
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
    }
    
    open func setSelectedItemIndex(_ selectedItemIndex: Int, animated: Bool) {
        if selectedItemIndex != _selectedItemIndex {
            _selectedItemIndex = selectedItemIndex
            
            updateSelectedIndex(selectedItemIndex, animated: animated)
        }
    }
    
    fileprivate func updateSelectedIndex(_ selectedItemIndex: Int, animated: Bool) {
        
        if scrollView.contentSize != CGSize.zero {
            let offset = CGPoint(x: CGFloat(selectedItemIndex) * scrollView.frame.width, y: 0)
            scrollView.setContentOffset(offset, animated: animated)
            
            updateSelection(selectedItemIndex, previousItemIndex: previousItemIndex)
            
            previousItemIndex = selectedItemIndex
        }
    }

    // MARK: KVO
    fileprivate var rendersInInterfaceBuilder = false
    fileprivate var myContext: UInt = 0xDEADC0DE
    open override func awakeFromNib() {
        super.awakeFromNib()
        if !rendersInInterfaceBuilder {
            scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: &myContext)
        }
    }

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if rendersInInterfaceBuilder {
            return
        }
        if context == &myContext {
            if let newValue = change?[NSKeyValueChangeKey.newKey] {
                if (newValue as AnyObject).cgSizeValue != CGSize.zero {
                    updateSelectedIndex(_selectedItemIndex, animated: false)
                }
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        if !rendersInInterfaceBuilder {
            scrollView.removeObserver(self, forKeyPath: "contentSize", context: &myContext)
        }
    }
}

extension MVHorizontalPicker: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let _ = updateSelectedItem(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let selectedItemIndex = updateSelectedItem(scrollView)
        
        if selectedItemIndex != _selectedItemIndex {
            
            _selectedItemIndex = selectedItemIndex
            
            self.sendActions(for: .valueChanged)
        }
    }

    fileprivate func calculateSelectedItemIndex(_ scrollView: UIScrollView) -> Int {
        
        let itemWidth = scrollView.frame.width
        let fractionalPage = scrollView.contentOffset.x / itemWidth
        let page = lroundf(Float(fractionalPage))
        return min(scrollView.subviews.count - 1, max(page, 0))
    }

    fileprivate func updateSelection(_ selectedItemIndex: Int, previousItemIndex: Int?) {
        let fontSize: CGFloat = 18
        if let previousItemIndex = previousItemIndex,
            let previousItem = scrollView.subviews[previousItemIndex] as? MVPickerItemView {
                
                previousItem.selected = false
        }
        
        if let currentItem = scrollView.subviews[selectedItemIndex] as? MVPickerItemView {
            
            currentItem.selected = true
            scrollingIndex = selectedItemIndex
            if(self.delegate != nil){
                self.delegate?.UpdateIndex()
            }            
            for i in 1...4{
                if(selectedItemIndex + i <= scrollView.subviews.count - 1){
                    if let mediumItem = scrollView.subviews[selectedItemIndex + i] as? MVPickerItemView {
                        mediumItem.font = UIFont(name: "Roboto", size: fontSize - CGFloat(i * 2))!
                    }
                }
                if(selectedItemIndex - i >= 0){
                    if let mediumItem = scrollView.subviews[selectedItemIndex - i] as? MVPickerItemView {
                        mediumItem.font = UIFont(name: "Roboto", size: fontSize - CGFloat(i * 2))!
                    }
                }
               
            }
        }
    }

    fileprivate func updateSelectedItem(_ scrollView: UIScrollView) -> Int {
        
        let selectedItemIndex = calculateSelectedItemIndex(scrollView)
        
        if selectedItemIndex != previousItemIndex {
            
            updateSelection(selectedItemIndex, previousItemIndex: previousItemIndex)
            
            previousItemIndex = selectedItemIndex
        }
        return selectedItemIndex
    }
    
}
