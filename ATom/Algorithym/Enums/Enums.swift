//
//  Enums.swift
//  ECG_Project
//
//  Created by Châu Phan Thế on 6/3/19.
//  Copyright © 2019 Phung Duc Chinh. All rights reserved.
//

import Foundation

enum ErrorException:Error{
    case InvalidParameterException
}


enum QrsClass{
    /** Rejection class */
    case UNKNOWN
    /** No valid QRS complex, probably detection failure */
    case INVALID
    /** Normal QRS morphology */
    case NORMAL
    /** Premature Ventricular Contraction recognized in QRS (cc small) */
    case PVC
    /** PVC like aberrant beat (cc very small) */
    case PVC_ABERRANT
    /** Bundle branch block (q->s > 130ms) */
    case BB_BLOCK
    /** Various escape beats (> 600ms no QRS) */
    case ESCAPE
    /** Atrial premature complexes/beats */
    case APC
    /** Aberrated atrial premature beats */
    case APC_ABERRANT
    /** Various premature beats, unspecified, possibly junctional premature */
    case PREMATURE
    /** waveform differs significantly, potentially a/v flutter or fibrillation (cc < 0.4) */
    case ABERRANT
    /** Virtual beats, inserted for missed beats */
    case VIRTUAL
}

enum QrsArrhythmia{
    /** no arrhythmia, normal pace */
    case NORMAL_RHYTHM
    /** Very likely a normal beat, shows several deviations, but not enough to classify as ectopic */
    case ARTIFACT
    /** Fusion of two beats (rr < 0.65 * prev && no APC) */
    case FUSION
    /** atrioventricular block, generic (rr > 1.6 * prev => ESCAPE if nothing else) */
    case AV_BLOCK
    /** Heart rate > 130 bpm */
    case TACHYCARDIA
    /** Heart rate < 40 bpm */
    case BRADYCARDIA
    /** a/v flutter or fibrillation (ABERRANT && rr <<) */
    case FIBRILLATION
    /** Heart failure */
    case CARDIAC_ARREST
}


protocol Handle:class{
    func updateData()//use for another view
}

enum SegmentationStatus{
    case INVALID
    case THESHOLD_CROSSED
    case R_FOUND
    case FINISHED
    case PROCESSED
}

