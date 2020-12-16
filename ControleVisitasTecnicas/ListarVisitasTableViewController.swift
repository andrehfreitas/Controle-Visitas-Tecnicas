import UIKit
import CoreData


class ListarVisitasTableViewController: UITableViewController {
    var context: NSManagedObjectContext!
    var visitas: [NSManagedObject] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    
    // Recarrega os itens da lista quando ela é exibida
    override func viewDidAppear(_ animated: Bool) {
        recuperarVisitas()
    }
    
    
    // Função que recupera a lista de visitas técnicas e preenche a lista
    func recuperarVisitas(){
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Visitas")
        let ordenacao = NSSortDescriptor(key: "data", ascending: false)
        
        requisicao.sortDescriptors = [ordenacao]
        
        do {
            let visitasRecuperadas = try context.fetch(requisicao)
            self.visitas = visitasRecuperadas as! [NSManagedObject]
            self.tableView.reloadData()
        } catch let erro {
            print("Erro ao recuperar visitas técnicas: \(erro.localizedDescription)")
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.visitas.count
    }
    
    
    // Preenche a célula com os dados do banco de dados
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        
        let visita = self.visitas[indexPath.row]
        let empresaRecuperada = visita.value(forKey: "empresa")
        let dataRecuperada = visita.value(forKey: "data")
        
        // Formatação da data
        let dataFormatada = DateFormatter()
        dataFormatada.dateFormat = "dd/MM/yyyy"
        let novaData = dataFormatada.string(from: dataRecuperada as! Date)
        
        cell.textLabel?.text = empresaRecuperada as? String
        cell.detailTextLabel?.text = novaData

        return cell
    }
    
    
    // Coloca o item da lista selecionado em edição na ViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let visita = self.visitas[indexPath.row]
        self.performSegue(withIdentifier: "verVisita", sender: visita)
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Função que apaga uma visita técnica
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let visita = self.visitas[indexPath.row]
            self.context.delete(visita)
            self.visitas.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try self.context.save()
                print("Visita técnica apagada com sucesso!!!")
            } catch let erro {
                print("Erro ao apagar a visita técnica: \(erro.localizedDescription)")
            }
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verVisita" {
            let viewDestino = segue.destination as! ViewController
            viewDestino.visita = sender as? NSManagedObject
        }
    }
    

}
