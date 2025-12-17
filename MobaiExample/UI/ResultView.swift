//
//  ResultView.swift
//  MobaiExample
//
//  Created by serif.kazan on 11/12/2025.
//

import SwiftUI

struct ResultView: View {
    let result: VideoDecodingResponse?
    var onNavigateBack: () -> Void
    
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            
            HStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Verification Completed")
                        .foregroundStyle(Color.white)
                        .font(Font.title3.bold())
                        .padding(.vertical, 15)
                        .padding(.horizontal, 15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white, lineWidth: 2)
                        )
                    
                    Text("Result")
                        .foregroundStyle(Color(hex: "#F2C04C"))
                        .font(Font.title3.bold())
                    
                    if let result = result {
                        VStack(alignment: .leading, spacing: 4){
                            Text("Recognition Result: \(result.recognition!.passed ? "✅ Passed" : "❌ Failed")")
                                .foregroundStyle(Color(hex: "#F2C04C"))
                                .font(Font.headline.bold())
                            Text("Pad Check: \(result.pad!.passed ? "✅ Passed" : "❌ Failed")")
                                .foregroundStyle(Color(hex: "#F2C04C"))
                                .font(Font.headline.bold())
                            Text("Authenticity Result: \(result.authenticity!.passed ? "✅ Passed" : "❌ Failed")")
                                .foregroundStyle(Color(hex: "#F2C04C"))
                                .font(Font.headline.bold())
                            Text("Integrity Result: \(result.integrity!.passed ? "✅ Passed" : "❌ Failed")")
                                .foregroundStyle(Color(hex: "#F2C04C"))
                                .font(Font.headline.bold())
                            Text("Deepfake Result: \(result.deepFake!.passed ? "✅ Passed" : "❌ Failed")")
                                .foregroundStyle(Color(hex: "#F2C04C"))
                                .font(Font.headline.bold())
                            Text("Face Quality:")
                                .foregroundStyle(Color(hex: "#F2C04C"))
                                .font(Font.headline.bold())
                            Text("Illumination Uniformity: \(result.faceQualityProbe?.metrics.illuminationUniformity ?? "")")
                                .foregroundStyle(Color(hex: "#F2C04C"))
                                .font(Font.subheadline.bold())
                                .padding(.leading, 20)
                            
                            Text("Lumination Mean: \(result.faceQualityProbe?.metrics.luminanceMean ?? "")")
                                .foregroundStyle(Color(hex: "#F2C04C"))
                                .font(Font.subheadline.bold())
                                .padding(.leading, 20)
                            
                            Text("Lumination Variance: \(result.faceQualityProbe?.metrics.luminanceVariance ?? "")")
                                .foregroundStyle(Color(hex: "#F2C04C"))
                                .font(Font.subheadline.bold())
                                .padding(.leading, 20)
                            
                            Text("Under Exposure Prevention: \(result.faceQualityProbe?.metrics.underExposurePrevention ?? "")")
                                .foregroundStyle(Color(hex: "#F2C04C"))
                                .font(Font.subheadline.bold())
                                .padding(.leading, 20)
                            
                            Text("Over Exposure Prevention: \(result.faceQualityProbe?.metrics.overExposurePrevention ?? "")")
                                .foregroundStyle(Color(hex: "#F2C04C"))
                                .font(Font.subheadline.bold())
                                .padding(.leading, 20)
                            
                            Text("Dynamic Range: \(result.faceQualityProbe?.metrics.dynamicRange ?? "")")
                                .foregroundStyle(Color(hex: "#F2C04C"))
                                .font(Font.subheadline.bold())
                                .padding(.leading, 20)
                            
                            Text("Sharpness: \(result.faceQualityProbe?.metrics.sharpness ?? "")")
                                .foregroundStyle(Color(hex: "#F2C04C"))
                                .font(Font.subheadline.bold())
                                .padding(.leading, 20)
                            
                            Text("Natural Color: \(result.faceQualityProbe?.metrics.naturalColor ?? "")")
                                .foregroundStyle(Color(hex: "#F2C04C"))
                                .font(Font.subheadline.bold())
                                .padding(.leading, 20)
                        }
                    }
                }
                
                Spacer()
            }
            
            Spacer()
            
            Button{
                onNavigateBack()
            } label:{
                Text("Go Back")
                    .font(Font.system(size: 18).bold())
                    .foregroundStyle(.black)
                    .padding(18)
                    .frame(maxWidth: .infinity)
            }
            .background(Color(hex: "#F2C04C"))
            .cornerRadius(25)
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [Color(hex: "#18323C"), Color(hex: "#2B586A")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

#Preview {
    ResultView(result: VideoDecodingResponse(
        id: "1",
        recognition: RecognitionObject(passed: true, score: 100),
        pad: PadObject(passed: true, score: 100),
        authenticity: AuthenticityObject(passed: true),
        integrity: IntegrityObject(passed: true),
        deepFake: DeepFakeObject(passed: true, score: 100),
        faceQualityProbe: FaceQualityProbeObject(
            metrics: FaceQualityMetrics(
                illuminationUniformity: "100",
                luminanceMean: "100",
                luminanceVariance: "100",
                underExposurePrevention: "100",
                overExposurePrevention: "100",
                dynamicRange: "100",
                sharpness: "100",
                naturalColor: "100"
            )
        ),
        error: ErrorObject(code: 10, message: "")
    ), onNavigateBack: {
        
    })
}
