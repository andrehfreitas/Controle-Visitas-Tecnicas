import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var dataVisita: UITextField!
    @IBOutlet weak var horaInicioVisita: UITextField!
    @IBOutlet weak var horaTerminoVisita: UITextField!
    @IBOutlet weak var empresaVisita: UITextField!
    @IBOutlet weak var tecnicoVisita: UITextField!
    @IBOutlet weak var equipamentoVisita: UITextField!
    @IBOutlet weak var descricaoVisita: UITextView!
    @IBOutlet weak var labelDataAtendimento: UILabel!
    
    
    var context: NSManagedObjectContext!
    var visita: NSManagedObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define a formatação da data a ser exibida no TextField dataVisita
        let dataFormatada = DateFormatter()
        dataFormatada.dateFormat = "dd/MM/yyyy"
        
        self.dataVisita.becomeFirstResponder()
        self.dataVisita.isUserInteractionEnabled = false
        self.horaInicioVisita.becomeFirstResponder()
        self.horaTerminoVisita.becomeFirstResponder()
        self.empresaVisita.becomeFirstResponder()
        self.tecnicoVisita.becomeFirstResponder()
        self.equipamentoVisita.becomeFirstResponder()
        self.descricaoVisita.becomeFirstResponder()
        		
        if visita != nil {
            if let dataRecuperada = visita.value(forKey: "data") {
                self.dataVisita.text = dataFormatada.string(from: dataRecuperada as! Date)
            }
            
            if let horaInicioRecuperada = visita.value(forKey: "horainicio") {
                self.horaInicioVisita.text = String(describing: horaInicioRecuperada)
            }
            
            if let horaTerminoRecuperada = visita.value(forKey: "horatermino") {
                self.horaTerminoVisita.text = String(describing: horaTerminoRecuperada)
            }
            
            if let empresaRecuperada = visita.value(forKey: "empresa") {
                self.empresaVisita.text = String(describing: empresaRecuperada)
            }
            
            if let tecnicoRecuperado = visita.value(forKey: "tecnico") {
                self.tecnicoVisita.text = String(describing: tecnicoRecuperado)
            }
            
            if let equipamentoRecuperado = visita.value(forKey: "equipamento") {
                self.equipamentoVisita.text = String(describing: equipamentoRecuperado)
            }
            
            if let descricaoRecuperada = visita.value(forKey: "descricao") {
                self.descricaoVisita.text = String(describing: descricaoRecuperada)
            }
            
        } else {
            self.dataVisita.text = dataFormatada.string(from: Date())
            self.horaInicioVisita.text = ""
            self.horaTerminoVisita.text = ""
            self.empresaVisita.text = ""
            self.tecnicoVisita.text = ""
            self.equipamentoVisita.text = ""
            self.descricaoVisita.text = ""
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }

    
    // Verifica quando se trata de um cadastro ou edição de uma visita técnica e
    // chama a função pertinente
    @IBAction func salvar(_ sender: Any) {
        if visita == nil {
            self.salvarVisita()
        } else {
            self.atualizarVisita()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // Cadastra informações de uma visita técnica
    func salvarVisita(){
        let novaVisita = NSEntityDescription.insertNewObject(forEntityName: "Visitas", into: context)
        
        novaVisita.setValue(Date(), forKey: "data")
        novaVisita.setValue(self.horaInicioVisita.text, forKey: "horainicio")
        novaVisita.setValue(self.horaTerminoVisita.text, forKey: "horatermino")
        novaVisita.setValue(self.empresaVisita.text, forKey: "empresa")
        novaVisita.setValue(self.tecnicoVisita.text, forKey: "tecnico")
        novaVisita.setValue(self.equipamentoVisita.text, forKey: "equipamento")
        novaVisita.setValue(self.descricaoVisita.text, forKey: "descricao")
        
        do {
            try context.save()
            print("Visita técnica salva com sucesso!!!")
        } catch let erro {
            print("Erro ao salvar visita técnica: \(erro.localizedDescription)")
        }
    }
    
    
    // Atualiza informações de uma visita cadastrada
    func atualizarVisita(){
        visita.setValue(self.horaInicioVisita.text, forKey: "horainicio")
        visita.setValue(self.horaTerminoVisita.text, forKey: "horatermino")
        visita.setValue(self.empresaVisita.text, forKey: "empresa")
        visita.setValue(self.tecnicoVisita.text, forKey: "tecnico")
        visita.setValue(self.equipamentoVisita.text, forKey: "equipamento")
        visita.setValue(self.descricaoVisita.text, forKey: "descricao")
        do {
            try context.save()
            print("Visita técnica atualizada com sucesso!!!")
        } catch let erro {
            print("Erro ao atualizar visita técnica: \(erro.localizedDescription)")
        }
    }
}
