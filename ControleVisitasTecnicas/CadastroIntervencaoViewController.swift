import UIKit
import CoreData

class CadastroIntervencaoViewController: UIViewController  {
    
    @IBOutlet weak var descricaoEquipamento: UITextView!
    @IBOutlet weak var descricaoIntervencao: UITextView!
    
    var context: NSManagedObjectContext!
    var intervencao: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.descricaoEquipamento.becomeFirstResponder()
        self.descricaoIntervencao.becomeFirstResponder()
        
        
        if intervencao != nil {
            if let descrEquipRecuperada = intervencao.value(forKey: "equipamento") {
                self.descricaoEquipamento.text = String(describing: descrEquipRecuperada)
            }
            
            if let descrIntervRecuperada = intervencao.value(forKey: "descricao") {
                self.descricaoIntervencao.text = String(describing: descrIntervRecuperada)
            }
        } else {
            self.descricaoEquipamento.text = ""
            self.descricaoIntervencao.text = ""
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }

    @IBAction func salvar(_ sender: Any) {
        if intervencao == nil {
            salvarIntervencao()
        } else {
            atualizarIntervencao()
        }
        self.navigationController?.popViewController(animated: true)
    }
    

    // Cadastra informações de uma intervenção feita durante uma visita
    func salvarIntervencao(){
        let novaIntervencao = NSEntityDescription.insertNewObject(forEntityName: "Intervencoes", into: context)
        
        novaIntervencao.setValue(self.descricaoEquipamento.text, forKey: "equipamento")
        novaIntervencao.setValue(self.descricaoIntervencao.text, forKey: "descricao")
        
        do {
            try context.save()
            print("Intervenção salva com sucesso!!!")
        } catch let erro {
            print("Erro ao salvar intervenção: \(erro.localizedDescription)")
        }
    }
    
    
    // Atualiza informações de uma intervenção técnica
    func atualizarIntervencao(){
        intervencao.setValue(self.descricaoEquipamento.text, forKey: "equipamento")
        intervencao.setValue(self.descricaoIntervencao.text, forKey: "descricao")
        
        do {
            try context.save()
            print("Intervenção atualizada com sucesso!!!")
        } catch let erro {
            print("Erro ao atualizar intervenção: \(erro.localizedDescription)")
        }
    }

}
