//
//  ListViewController..swift
//  bambooPracticalExam
//
//  Created by Cuacko on 27/03/21.
//


import UIKit
import AVFoundation

class ListViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITableViewDataSource {
  
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    
    var recordSession : AVAudioSession!
    var audioRecorder : AVAudioRecorder!
    var numberOfRecords : Int = 0
    var audioPlayer : AVAudioPlayer!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        
        if let number : Int = UserDefaults.standard.object(forKey: "MyRecords") as? Int {
            numberOfRecords = number
        }
    }
    
    
    //MARK: Directory path
    func getDirectory() -> URL {
        let fileManager = FileManager.default
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            print(fileURLs)
        } catch {
            print("Error while enumerating files \(documentDirectory.path): \(error.localizedDescription)")
        }

        return documentDirectory
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dissmis", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: Recording Button
    @IBAction func recordAction(_ sender: Any) {
        
        if audioRecorder == nil {
        
            numberOfRecords += 1
            let audioFileName = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            let settingRecord = [ AVFormatIDKey : kAudioFormatAppleLossless,
                                  AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue,
                                  AVEncoderBitRateKey : 320000,
                                  AVNumberOfChannelsKey : 2,
                                  AVSampleRateKey : 44100.2 ] as [String : Any]
            //MARK: Start Recording
            do {
                audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settingRecord)
                audioRecorder.delegate = self
                audioRecorder.record()
                recordButton.setTitle("Stop", for: .normal)
            } catch {
                displayAlert(title: "Ups!", message: "Something Failed :(")
            }
        }else {
            audioRecorder.stop()
            audioRecorder = nil
            
            UserDefaults.standard.setValue(numberOfRecords, forKey: "MyRecords")
            table.reloadData()
            
            recordButton.setTitle("Start Recording", for: .normal)
//            let alert = UserDefaults.MyRecords{ [weak self] name in
//                self?.addNewRecord(with: name)
            
            }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRecords
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecordTableViewCell
        cell.recordLabel.text = ("Recording \(String(indexPath.row + 1))")
        return cell
    }

    
    @IBAction func pauseAction(_ sender: Any) {
        if audioPlayer.isPlaying == true {
            pauseButton.setBackgroundImage(UIImage.init(systemName: "play.circle.fill"), for: .normal)
            audioPlayer.pause()
        }else{
            pauseButton.setBackgroundImage(UIImage.init(systemName: "pause.circle.fill"), for: .normal)
            audioPlayer.play()
        }
        
    }
    
    @IBAction func stopAction(_ sender: Any) {
        audioPlayer.stop()
        pauseButton.setBackgroundImage(UIImage.init(systemName: "pause.circle.fill"), for: .normal)

    }
    
//    enum Section {
//        case main
//    }
//
//    func configureDataSource() {
//
//    dataSource = UITableViewDiffableDataSource<Section, String> (tableView: table) {
//            (tableView: UITableView, indexPath: IndexPath, item: String) -> UITableViewCell? in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecordTableViewCell
//        cell.recordLabel.text = ("Recording \(self.numberOfRecords.description)")
////            self.numberOfRecords.description
//
//            return cell
//    }
//            snapshot.appendSections([.main])
//            snapshot.appendItems([], toSection:.main)
//            dataSource.apply(snapshot, animatingDifferences: true)
//    }

}
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a")
        do {
           audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.play()
            pauseButton.setBackgroundImage(UIImage.init(systemName: "pause.circle.fill"), for: .normal)
            pauseButton.isHidden = false
            pauseButton.isEnabled = true
            stopButton.isHidden = false
            stopButton.isEnabled = true
        } catch {
            print(error)
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "    My Records"
            label.textColor = UIColor.black
            label.font = UIFont.boldSystemFont(ofSize: 20)

        return label
    }
}
