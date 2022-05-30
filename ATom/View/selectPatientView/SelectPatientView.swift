//
//  SelectPatientView.swift
//  ATom
//
//  Created by nguyen.vuong.thanh.loc on 11/27/19.
//  Copyright © 2019 phan.the.chau. All rights reserved.
//

import UIKit

protocol SelectPatientViewDelegate {
    func enableSelect(enable: Bool)
}

final class SelectPatientView: UIView {
    @IBOutlet weak private var icCheckECGImage: UIImageView!
    @IBOutlet weak private var icCheckAnalysisImage: UIImageView!
    @IBOutlet weak var selectECGView: UIView!
    @IBOutlet weak var selectAnalysisView: UIView!

    private var isSelectECG: Bool = false
    private var isSelectAnlysis: Bool = false
    var delegate: SelectPatientViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func showIconCheck(isShow: Bool) {
        if isShow {
            icCheckECGImage.isHidden = false
            icCheckAnalysisImage.isHidden = false
            
        } else {
            icCheckECGImage.isHidden = true
            icCheckAnalysisImage.isHidden = true
        }
    }
    
    func addTapGesture() {
        let tapECG = UITapGestureRecognizer(target: self, action: #selector(selectECG))
        let tapAnalysis = UITapGestureRecognizer(target: self, action: #selector(selectAnalysis))
        
        selectECGView.addGestureRecognizer(tapECG)
        selectAnalysisView.addGestureRecognizer(tapAnalysis)
    }
    
    @objc func selectECG() {
        if isSelectECG == false {
            icCheckECGImage.image = #imageLiteral(resourceName: "ic-check")
            isSelectECG = true
        } else {
            icCheckECGImage.image = #imageLiteral(resourceName: "ic-circle")
            isSelectECG = false
        }
        
    }
    
    func enableSelect(enable: Bool) {
        if enable {
            selectAnalysisView.isUserInteractionEnabled = true
            selectECGView.isUserInteractionEnabled = true

        } else {
            selectAnalysisView.isUserInteractionEnabled = false
            selectECGView.isUserInteractionEnabled = false
        }
    }
    
    @objc func selectAnalysis() {
        if isSelectAnlysis == false {
            icCheckAnalysisImage.image = #imageLiteral(resourceName: "ic-check")
            isSelectAnlysis = true
        } else {
            icCheckAnalysisImage.image = #imageLiteral(resourceName: "ic-circle")
            isSelectAnlysis = false
        }
    }
    
    
    private func configView() {
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        icCheckECGImage.isHidden = true
        icCheckAnalysisImage.isHidden = true
        selectAnalysisView.isUserInteractionEnabled = false
        icCheckECGImage.isUserInteractionEnabled = false
    }
    
    private func loadNib() {
        let view: UIView? = (Bundle.main.loadNibNamed("SelectPatientView", owner: self, options: nil)?[0] as? UIView)
        view?.frame = bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let view = view {
            self.addSubview(view)
        }
        configView()
        addTapGesture()
    }
}
