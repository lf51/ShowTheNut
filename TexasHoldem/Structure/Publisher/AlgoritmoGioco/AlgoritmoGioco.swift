//
//  AlgoritmoGioco.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 24/09/21.
//

import Foundation

class AlgoritmoGioco: ObservableObject {
    
  var studCards: [String] = ["01c", "02c", "03c", "04c", "05c", "06c", "07c", "08c", "09c", "10c", "11c", "12c", "13c","01f", "02f", "03f", "04f", "05f", "06f", "07f", "08f", "09f", "10f", "11f", "12f", "13f","01q", "02q", "03q", "04q", "05q", "06q", "07q", "08q", "09q", "10q", "11q", "12q", "13q","01p", "02p", "03p", "04p", "05p", "06p", "07p", "08p", "09p", "10p", "11p", "12p", "13p"] // Teniamo lo zero nei numeri da 1 a 9 per standardizzare il prefix a due cifre per le mappature
    @Published var shuffledCards: [String] = []
    
    @Published var flop: [String] = ["retroCarta2", "retroCarta2", "retroCarta2"]
    @Published var turn: String = "retroCarta2"
    @Published var river: String = "retroCarta2"

    @Published var scartoTurnRiver: String = "retroCarta2"
    
    @Published var myCards:[String] = ["retroCarta2", "retroCarta2"]
    
    @Published var nutsCards:[String] = []
    var highestCombination: PossibleResults?
    var highestCombinationString: String = "ND"
    
    @Published var playerWin: Bool = false  //  resultCalculator()
   // var result = false
    @Published var myCardRemoved: String = ""
    
    @Published var areCardsUnpickable: Bool = true // per abilitare le carte fra cui scegliere
    @Published var showStudCards: Bool = false
    @Published var changingCardAvaible: Bool = false // per attivare il pick sulle pocketCard
  
    @Published var showNuts: Bool = false // mostra i valori nuts.
    @Published var goodCardInTheBoard: [String] = []
    
    @Published var isFlopReady:Bool = false
    @Published var isTurnReady:Bool = false
    @Published var isRiverReady:Bool = false
    @Published var stepCount: Int = 0 // cadenza i passaggi, preFlop = 0
    
    @Published var stopShuffle:Bool = false // serve a stoppare la mischiata di Carte

    var cardsShowedConstructor:[String] {
        
        var cardsShowed = self.flop
        
        cardsShowed.append(self.turn)
        cardsShowed.append(myCardRemoved)
       // cardsShowed.append(self.scartoTurnRiver)
        cardsShowed.append(self.river)
        cardsShowed.append(contentsOf: myCards)

        return cardsShowed
        
    }
    
    var allCardsShowed: [String] {
        
    studCards.filter { data in
        
        !self.cardsShowedConstructor.contains(data)
    }
    
    }
    
    func cleanOrFoldAction() {
   //self.shuffledCards = []
        self.flop = ["retroCarta2", "retroCarta2", "retroCarta2"]
        self.turn = "retroCarta2"
        self.river = "retroCarta2"
        
     //   self.scartoPrimo = "s1"
        self.scartoTurnRiver = "retroCarta2"
        self.myCardRemoved = "retroCarta2"
        
        self.myCards = ["retroCarta2", "retroCarta2"]
        self.nutsCards = []
        self.goodCardInTheBoard = []
        self.mazzoA = []
        self.shuffledCards = self.studCards // se le shuffledCards sono uguali alle studs nelle partite successive alla prima il tavolo non si svuota ed è come se le carte venissero ammucchiate in mezzo per essere reimmischiate. Nella mano zero il tavolo è vuoto perchè le shuffled sono []. Se mettessimo qui l'uguaglianza al vuoto dovremmo attribuirgli le studcards fuori, nella shuffleUp()
        
      //  self.showOptions = false
        self.showNuts = false
      //  self.showResult = false
        self.playerWin = false
        
        self.isFlopReady = false
        self.isTurnReady = false
        self.isRiverReady = false
        
        self.areCardsUnpickable = true
        self.stopShuffle = false
        self.stepCount = 0 // da tenere qui per la foldAction
        
        self.showStudCards = false
        
    }
    
    var temporaryStudCards:[String] = []
    var mazzoA:[String] = []
    var mazzoB:[String] = []
    
    /* LINEA TEST */  var mazzoTest:[String] = ["11c","05f","01c","13p","02p","10c","13c","12c","05p"]
    
    func shuffleUp() {
    
        // testing area
      //  print(CFLocaleCopyPreferredLanguages()!)
        
       // let language = CFLocaleCopyPreferredLanguages()
       // var languages = language as! [String]
       // print(languages)
    
        //end testing area
        cleanOrFoldAction()
        
        self.stepCount = 1
        
        for time in stride(from: 0.0, to: 5.0, by: 1.0) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
               // self.studCards.shuffle()
                SoundManager.instance.playSound(sound: .cardShuffler) // Tutti gli shuffler registrati risultano fastidiosi
                self.shuffledCards.shuffle()
  
                if time == 4.0 {
                    self.stopShuffle = true
                  //  print("time == \(time)")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        
                        (self.temporaryStudCards, self.mazzoA, self.mazzoB) = self.smazzata()
                      //  print("temporaryStud: \(self.temporaryStudCards)")
                        self.shuffledCards.shuffle() // questa Shufflata ci serve per aggiornare il Published nel ForEach, il mazzo è stato già creato con la smazzata()
                        
                      //  print("shuffledCard == studcardShuffled - studCard.count:\(self.shuffledCards.count)")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                            self.mazzoA = self.temporaryStudCards
                         
    /* LINEA CORRETTA */ self.shuffledCards = self.temporaryStudCards // Qui abbiamo il mazzo smazzato con cui giocare
                            
    /* LINEA TEST */ // self.shuffledCards = self.mazzoTest // Da eliminare
                            
                            self.stepCount = 2
                         //   print("shuffledCard == temporaryStud - shuffledCard.count:\(self.shuffledCards.count)")
                         //   print("shuffledCardsAsToBeEqualAtTemporary: \(self.shuffledCards)")
                        }
                        
                        
                    }
                    
                }
            })
         
        }
      
    }
       
    func smazzata() -> (mazzoIntero:[String],mazzoA:[String],mazzoB:[String]) {
        
        let indexSmazzata = Int.random(in: 1...51)
        
        var mazzoA:[String] = []
        var mazzoB:[String] = []
        
      //  print("mazzoShufflato: \(self.shuffledCards)")
        
        let reversedStudCards:[String] = self.shuffledCards.reversed() // questo perchè in realta la carta più in alto nel mazzo, quindi la prima che viene servita non è la [0] ma la [51], ossia l'ultima. Girandolo qui, una volta terminate le shufflate, possiamo mantenere invariato il codice nella view, poichè le carte del flop saranno si le [0],[1],[2] ma in realtà corrisponderanno alla [51],[50],[49], ossia a quelle in cima al mazzo.
        
     //   print("mazzoRibalta: \(reversedStudCards)")
        
        for indexCard in 0..<indexSmazzata {
            
            mazzoA.append(reversedStudCards[indexCard])
            
        }
        
        for indexCard in indexSmazzata..<52 {
            
            mazzoB.append(reversedStudCards[indexCard])
            
        }
        
        let mazzoIntero = mazzoB + mazzoA
      //  print("mazzoSmazzato:\(mazzoIntero)")
        return (mazzoIntero,mazzoA,mazzoB)

    }
        
    func deal() {
        
      //  clean()
        
     //   DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: DispatchWorkItem(block: { // Diamo uno stacco per far eseguire il clean. Senza questo lo stepCount restava a zero perchè evidentemente prima lo metteva ad uno e poi arrivava lo zero del clean.
           
            // Questo ci da un secondo prima che appaiano le carte, possiamo usarlo per inserire il suono delle carte mischiate
     
            self.isFlopReady = true
            self.showStudCards = true
            
         self.stepCount = 3
    //    }))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: DispatchWorkItem(block: {
            self.flop[0] = self.shuffledCards[0]
            SoundManager.instance.playSound(sound: .cardClip)
        }))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: DispatchWorkItem(block: {
            self.flop[1] = self.shuffledCards[1]
            SoundManager.instance.playSound(sound: .cardClip)
        }))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: DispatchWorkItem(block: {
            self.flop[2] = self.shuffledCards[2]
            SoundManager.instance.playSound(sound: .cardClip)
            
        }))
        
       DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: DispatchWorkItem(block: {
            
            self.areCardsUnpickable = false
            print("AllCardsShowed.Count on FLOP: \(self.allCardsShowed.count)")
        }))

       
    }
    
    func pickACard(card:String) {
        
        if self.myCards[0] == "retroCarta2" {
            SoundManager.instance.playSound(sound: .cardClip)
            self.myCards[0] = card
            
            if self.stepCount == 5 {
                
                self.areCardsUnpickable = true
                self.stepCount = 7
                
            }
            
        }
        
        else {
            SoundManager.instance.playSound(sound: .cardClip)
            guard self.myCards[0] != card else {return}
            self.myCards[1] = card
            self.areCardsUnpickable = true
           
            if self.stepCount == 3 {self.stepCount += 1}
            else if self.stepCount == 5 {self.stepCount = 7 }
        }

        print("AllCardsShowed.Count AfterPICK: \(self.allCardsShowed.count)")
    }
 
    func showTurn() {
        
       self.stepCount = 5
        
       self.shuffledCards.removeAll { card in
            myCards.contains(card)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: DispatchWorkItem(block: {
            self.isTurnReady = true
        }))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: DispatchWorkItem(block: {
            self.turn = self.shuffledCards[3]
            SoundManager.instance.playSound(sound: .cardClip)
        }))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: DispatchWorkItem(block: {
           // self.showOptions = true
            self.stepCount = 6
            print("AllCardsShowed.Count onTURN: \(self.allCardsShowed.count)")
        }))
             
    }
    
    func showRiver() {
        
      //  self.showOptions = false
        self.stepCount = 8
        
        self.shuffledCards.removeAll { card in
             myCards.contains(card)
         }
        
        self.scartoTurnRiver = self.shuffledCards[4]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: DispatchWorkItem(block: {
            self.isRiverReady = true
        }))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: DispatchWorkItem(block: {
            self.river = self.shuffledCards[5]
            SoundManager.instance.playSound(sound: .cardClip)
           // self.showResult = true
        }))

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: DispatchWorkItem(block: {
            
            self.nutsCalculator()
            print("AllCardsShowed.Count on RIVER: \(self.allCardsShowed.count)")
        }))
        
     
    }
    
    // resultCalculator
    
    func resultCalculator() -> Bool {
        
        let localResult: Bool
        
       // print("preCalculo PlayerWin is: \(playerWin.description)")
 
        if nutsCards.contains("retroCarta2") {
            
            let indexretroCarta2 = nutsCards.firstIndex(of: "retroCarta2")
            nutsCards.remove(at: indexretroCarta2!)
         
        }

       switch highestCombination {
        
       case .set:
           //Point 4

        let plainMyCards:[Int] = myCards.map { card in
                Int(card.prefix(2)) ?? 0
            }
        
        let plainNuts:[Int] = nutsCards.map { card in
                Int(card.prefix(2)) ?? 0
            }
            
         localResult = plainMyCards == plainNuts
           
           
         //  print("Point 4 \(Set(plainMyCards).count)")
           // if nutsCards.count == 1 { nutsCards.append("retroCarta2") }
           print("dentro resultCalculator .set")
           
        case .straight:
           //Point 2

        var plainMyCards:[Int] = myCards.map { card in
                Int(card.prefix(2)) ?? 0
            }
        
        let plainNuts:[Int] = nutsCards.map { card in
                Int(card.prefix(2)) ?? 0
            }
            
           plainMyCards.append(contentsOf: plainNuts) // vabene messa prima perchè viene appeso in coda e [0] e [1] non cambiano
           
          if plainMyCards[0] != plainMyCards[1] {
              
              localResult = Set(plainMyCards).count == 2
          }
          else {
              
              localResult = (Set(plainMyCards).count + 1) == 2
          }
           
        //   print("Point 2 \(Set(plainMyCards).count)")
            if nutsCards.count == 1 { nutsCards.append("retroCarta2") }
            else if nutsCards.count == 0 { nutsCards.append(contentsOf: ["retroCarta2","retroCarta2"]) }

           print("dentro resultCalculator .straight")
        // ECCEZIONE SCALA Funzionante
        
       case .flush(let seedCount):
  
           if seedCount == 3  {
               
               if Set(myCards.map({$0.suffix(1)})).count == 1 {
                  //Point 1
                  // self.playerWin = myCards.contains(nutsCards[0]) ? true : false
                  localResult = myCards.contains(nutsCards[0]) // tendenzialmente avremo la carta più alta in posizione [0]
                //   print("Point 1:\(myCards.contains(nutsCards[0]))")
                  // return myCards.contains(nutsCards[0])
                   
               } else {
                 //  self.playerWin = false
              localResult = false
                  // return false
               }
   
           }
           else {
               
               var myCardsImage = self.myCards
               myCardsImage.append(contentsOf: nutsCards)
           
               localResult = Set(myCardsImage).count == 2
           }
          
           if nutsCards.count == 1 { nutsCards.append("retroCarta2") } // MODIFICARE IL NUTS PUO' ESSERE VUOTO. IN QUEL CASO VANNO RIAAPESE DUE RETROCARD
           print("dentro resultCalculator .flush")
           
       // ECCEZIONE FLUSH FUNZIONANTE
           
      case .poker(let quadsOnBoardKickerPlay):
           
           if quadsOnBoardKickerPlay {
               
               let plainMyCards:[Int] = myCards.map { card in
                       Int(card.prefix(2)) ?? 0
                   }
               
               let plainNuts:[Int] = nutsCards.map { card in
                       Int(card.prefix(2)) ?? 0
                   }
               
               localResult = plainMyCards.contains(plainNuts[0])
               if nutsCards.count == 1 { nutsCards.append("retroCarta2") }
               print("inside switch .poker ")
           } else {fallthrough}
           
        default:
           //Point 3
           var myCardsImage = self.myCards // necessario perchè le myCards vengono sottratte alle allCardsShowed, e se operiamo direttamente sulle myCards le carte nuts scompaiono dalle allCardsShowed
           
            myCardsImage.append(contentsOf: nutsCards)
       
           localResult = Set(myCardsImage).count == 2
         //  print("Point 3 \(Set(myCards).count)")
       
            if nutsCards.count == 1 { nutsCards.append("retroCarta2") }
           print("dentro resultCalculator .default")
           
        }
        
      //  print("self.playerWin description: \(self.playerWin.description)")
      
      //  result = true
       // self.playerWin = localResult
       // print("localResult is \(localResult)")
      //  print("playerWin is \(self.playerWin)")

        return localResult
    }
  
    // nuts Calculator
    
    func boardConstructor() ->(board:[String],plainBoard:[Int],setBoard:Set<Int>)  {
        // dopo aver creato questa funzione in loco di una computed, un test ha dato risultato corretto 10/10
        var board: [String] = []

        board.append(contentsOf: self.flop)
        board.append(self.turn)
        board.append(self.river)
 
        let plainBoard:[Int] = board.map { card in
            Int(card.prefix(2)) ?? 0
        }
        
        let plainBoardAsSet = Set(plainBoard)
        
        return (board,plainBoard,plainBoardAsSet)
        
    }

    func nutsCalculator() {

        let (board,plainBoard,plainBoardAsSet) = boardConstructor()
        
        var filteredColoredBoard: [String] = []
            
            for color in ["c","q","f","p"] {
                
                let boardLegatoColore = board.filter {$0.suffix(1) == color}
    
                if boardLegatoColore.count >= 3 {filteredColoredBoard = boardLegatoColore;break}
                
            }

        // IF board va a COLORE
        
        if filteredColoredBoard.count >= 3 {
            
            /* Nuts possibili:
             • Scala Reale / scala colore
             • Poker (se accoppiato)
             • Colore all'Asso */
            
            // verifichiamo legatura a scala delle carte a colore

            let plainBoardColored = filteredColoredBoard.map { card in
                Int(card.prefix(2))!
            }
    
            let seme = filteredColoredBoard[0].suffix(1)
            
            let (checkStraightFlush,straightFlushsCards,_) = checkStraight_StraightFlush(plainBoard: plainBoardColored)
            
            // 1. Check ScalaColore
            
            if checkStraightFlush {
                
                // Nuts Possibili Scala Reale / scala colore
              if straightFlushsCards.count == 1 {nutsCards.append("retroCarta2") }
                
                for plainCard in straightFlushsCards {
                    
                let card:String = String(plainCard).count == 1 ? ("0" + String(plainCard) + seme) : (String(plainCard) + seme)
                    
                    nutsCards.append(card)
                    
                }
                highestCombination = .straightFlush
                highestCombinationString = "Straight Flush"
                self.goodCardInTheBoard = filteredColoredBoard
                print("Nuts Scala Colore / Scala Reale - card:\(nutsCards)")
            }
            
            // 2. Se board non accoppiato check Colore
            
            else if plainBoardAsSet.count == 5 {
                
                let flushNutsCard:Int = trovaFlushNutsCards(plainBoard: plainBoardColored)
                
                //if flushNutsCards.count == 1 {nutsCards.append("retroCarta2") }
                // Nuts Possibile Colore dall'Asso a scendere
               // for plainCard in flushNutsCards {
                    
                let stringFlushNutsCard:String = String(flushNutsCard).count == 1 ? ("0" + String(flushNutsCard) + seme) : (String(flushNutsCard) + seme)
                    
                    nutsCards.append(stringFlushNutsCard)
                    nutsCards.append("retroCarta2")
                    
               // }
                highestCombination = .flush(seedCount:plainBoardColored.count)
                highestCombinationString = "Flush"
                self.goodCardInTheBoard = filteredColoredBoard
                print("Nuts Colore:\(nutsCards)")
            }
            
            //3. Se board accoppiato check Poker
            
            else { // Nuts Possibile Poker
                
                let quadsOnBoardKickerPlay:Bool
                
                (nutsCards,goodCardInTheBoard,quadsOnBoardKickerPlay) = checkPoker(board: board)
                highestCombination = .poker(quadsOnBoardKickerPlay: quadsOnBoardKickerPlay)
                highestCombinationString = "Quads"
              print("Nuts Poker: \(nutsCards)")
            }
     
        } else { /* il board non è legato a colore
             
             Nuts Possibili:
             • Poker (se board accoppiato)
             • Scala (se board legato a scala)
             • Set della carta più alta
             
             */
       
            if plainBoardAsSet.count == 5 {
                
                /* Nuts Possibili:
                • Scala
                • Set
                */
                
                let (checkStraight,straightCards,goodPlainCardsITB) = checkStraight_StraightFlush(plainBoard: plainBoard)
                
                if checkStraight {
                    
                    // Nuts Scala
                    
                    if straightCards.count == 1 {nutsCards.append("retroCarta2") }
                    
                    for plainCard in straightCards {
                  
                        let card:String = String(plainCard).count == 1 ? ("0" + String(plainCard) + "c") : (String(plainCard) + "c")
                        
                        nutsCards.append(card)
                        
                    }
                    highestCombination = .straight
                    highestCombinationString = "Straight"
                    self.goodCardInTheBoard = board.filter({ card in
                        goodPlainCardsITB.contains(Int(card.prefix(2))!)
                    })
                    print("Nuts Scala: \(nutsCards)")
                    
                    
                } else { //Nuts Set
                    
                    (nutsCards,goodCardInTheBoard) = setNuts(board: board)
                    highestCombination = .set
                    highestCombinationString = "Set"
                    print("Set is Nuts: \(nutsCards)")
                    
                    // goodCardsInTheBoard da fare
                }
     
            } else { // Nuts Poker
                
                let quadsOnBoardKickerPlay:Bool
                
                (nutsCards,goodCardInTheBoard,quadsOnBoardKickerPlay) = checkPoker(board: board)
                highestCombination = .poker(quadsOnBoardKickerPlay:quadsOnBoardKickerPlay)
                highestCombinationString = "Quads"
                print("Nuts Poker: \(nutsCards)")
                
            }
        
        }
        
        self.showNuts = true
       // self.resultCalculator()
        self.playerWin = self.resultCalculator()
        print("Player win true/false :\(self.playerWin)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.stepCount = 9
        }
        
    }

     
    // Metodi di Servizio al nutsCalculator()
    
    func setNuts(board:[String]) -> (nutsResult:[String],highestCard:[String]) {
        
        // il seme delle nuts cards è irrilevante poichè non possono esserci due set sulla stessa carta
        var nutsResult: [String] = []

        let plainBoard:[Int] = board.map({Int($0.prefix(2))!})
        
        let highestPlainCard = plainBoard.contains(1) ? 1 : (plainBoard.max() ?? 1)
        let highestStringCard = String(highestPlainCard).count == 1 ? ("0" + String(highestPlainCard)) : String(highestPlainCard)
        
        let highestCard = board.filter({$0.hasPrefix(highestStringCard)})
        
        for seme in ["c","q","f","p"] {
            
            let card = highestStringCard + seme
            if !highestCard.contains(card) {nutsResult.append(card)} // else {goodCardITB[0] = card}
            
            if nutsResult.count == 2 {break}
        }
        
        return (nutsResult,highestCard)
    }
    
    func checkPoker(board:[String]) -> (result:[String],board:[String],Bool) {
         
        //board: ["01f","01c","10p","08p","09p"]
        var result:[String] = []
        var goodCardsInTheBoard:[String] = []
        var quadsOnBoardKikerPlay:Bool = false
        
        let duplicati:[String:[String]] = Dictionary(grouping: board) { String($0.prefix(2))}
        
        var coppieTrovate:[Int] = []
        var carteSingole:[String] = []
        
        for (key,value) in duplicati {
            
            if value.count == 1 { carteSingole.append(value[0])}
            if value.count >= 2 { coppieTrovate.append(Int(key) ?? 0)}
            
        }
        
        let keyMax:Int
        
        if coppieTrovate.contains(01) {keyMax = 01} else {keyMax = coppieTrovate.max() ?? 01 }
   
        var stringKeyMax: String {
            
            if String(keyMax).count == 1 { return "0" + String(keyMax)}
            else {return String(keyMax)}
        }
        
        var ipoteticPoker:Set<String> = []
        
        // con poker a terra alcune delle seguenti operazioni sono condizionabili
        
        for seme in ["c","q","f","p"]  {
            
            let value = stringKeyMax + seme
            
            ipoteticPoker.insert(value)
        }
        
        let nutsHunting = ipoteticPoker.subtracting(duplicati[stringKeyMax]!)
        
        // tre casi:
        
        if nutsHunting.count == 2 {
            result = Array(nutsHunting)
            goodCardsInTheBoard = duplicati[stringKeyMax]!
        }
        
        else if nutsHunting.count == 1 {
            
            let carta_uno = Array(nutsHunting)[0]
            result.append(carta_uno)
            result.append("retroCarta2")
            
            goodCardsInTheBoard = duplicati[stringKeyMax]!
        /* Con il tris a terra, la carta non gioca poichè soltanto uno può avere la quarta carta mancante, dunque l'accompagnamento diventa irrilevante */
            
             }
        
        else if nutsHunting.count == 0 {
            
             let carta_uno = trovaCartaAlta(keyMax: stringKeyMax)
            
            print("cartaUnoprefix:\(carta_uno.prefix(2)) - cartaSingola[0].prefix: \(carteSingole[0].prefix(2))")
            
            if carta_uno.prefix(2) == carteSingole[0].prefix(2) {
                
                result = []
                
                goodCardsInTheBoard = board
            
            } else {
                
                result.append(carta_uno)
                result.append("retroCarta2")
               
               goodCardsInTheBoard = duplicati[stringKeyMax]!
               quadsOnBoardKikerPlay = true
            }
        
        }
        
        return (result,goodCardsInTheBoard,quadsOnBoardKikerPlay)
        
    }
    
        func trovaCartaAlta(keyMax:String) -> String {
        
            guard keyMax == "01" else {
                print("Poker non di Assi; Quindi carta Alta Asso")
                return "01c" }
            
            return "13c"
     
    }
    
    
    func trovaFlushNutsCards(plainBoard:[Int]) -> Int {
        
        let allPlainCards:[Int] = [01,13,12,11,10,09,08,07,06,05,04,03,02]
        // nel ciclo for si controlla se il plainboard contiene l'elemento dell'indice, se no lo inserisce fra le pocketCards. Con l'array scorriamo dalla più alta alla più bassa.
       
      //  var plainFlushNutsCards: Int
        
        for card in allPlainCards {
            
            if !plainBoard.contains(card) {
                
               return card
       
            }
        
        }

        return 0 // in teoria questo ritorno non dovrebbe mai esserci. Trovare il modo di rendere il ciclo esaustivo
    }
    
    func checkStraight_StraightFlush(plainBoard:[Int]) -> (boardAScala:Bool,missedCards:[Int],goodCardITB:[Int])/* Possiamo ritornare una tupla Bool,Int*/ {
         
       let plainBoardAsSet = Set(plainBoard)
        
        let modelliDiScala:[String:[Int]] = ["scala01_10":[01,13,12,11,10],"scala13_09":[13,12,11,10,09],"scala12_08":[12,11,10,09,08],"scala11_07":[11,10,09,08,07],"scala10_06":[10,09,08,07,06],"scala09_05":[09,08,07,06,05],"scala08_04":[08,07,06,05,04],"scala07_03":[07,06,05,04,03],"scala06_02":[06,05,04,03,02],"scala05_01":[05,04,03,02,01]]
  
        let modelliDiScalaKeys:[String] = ["scala01_10","scala13_09","scala12_08","scala11_07","scala10_06","scala09_05","scala08_04","scala07_03","scala06_02","scala05_01"]
        
        var straightCardsMissed:Set<Int> = []
        var boardAScala: Bool = false
        var goodPlainCardsInTheBoard: [Int] = []
        
        for key in modelliDiScalaKeys {
            
            let intersezioneInsiemi = Set(modelliDiScala[key]!).intersection(plainBoardAsSet) // usiamo l'array con le chiavi, invece di usare direttamente il dizionario, perchè il dizionario è disordinato, mentre con l'array possiamo scorrere dalla scala più alta alla più bassa e interrompere non appena viene trovata una legatura senza il rischio di aver lasciato fuori una legatura più alta.
            
            if intersezioneInsiemi.count >= 3 {
                
                boardAScala = true
                
                straightCardsMissed = Set(modelliDiScala[key]!).subtracting(intersezioneInsiemi)
                
                goodPlainCardsInTheBoard = Array(intersezioneInsiemi)
               /* self.plainNutsCards = Set(modelliDiScala[key]!).subtracting(intersezioneInsiemi) */
                
                break }
            
        }
 
        return (boardAScala,Array(straightCardsMissed),goodPlainCardsInTheBoard)
        
    }
   
    
}

/* Regole del Gioco:
 
 1. Le pocket card sono scelte dal giocatore dopo il Flop
 2. Prima del flop e fra flop e turn non c'è scarto
 --> Lo scarto preFlop e fra flop e tunr crea un problem con la regola al punto 3. Se il giocatore infatti intende cambiare una carta, deve essergli data la possibilità di scegliare fra tutte le carte non mostrate. Quindi escluso il flop, le sue carte attuali e il turn. Qualora ci fosse stato lo scarto dopo il flop, questo avrebbe creato un problema. Se lo reinserissimo nel mazzo permettendo che venga scelto, dovremmo allora reinserirlo comunque nel mazzo permettendo che "riesca" come 2° scarto o come river... ma allora come lo reinseriremmo? Dovremmo shuffolare di nuovo!

    Qualora invece lo escludessimo dalla scelta, in quanto scarto, dovremmo allora rivelarlo, il che potrebbe andare ad influenzare la scelta. Per tutte queste ragioni concludiamo che sia meglio non scartare dopo il flop e mantenere lo scarto solo dopo il turn.
 
 3. Dopo il turn è consentito cambiare una carta
 4. Fra turn e river c'è uno scarto
 
 
 */

/* I punti nuts possibili sono:
 - Con board accoppiato e almeno tre carte dello stesso seme abbiamo:
 • Scala reale / scala colore
 • Poker
 
 - Con board NON accoppiato e almeno tre carte dello stesso seme abbiamo:
 • Scala reale / scala colore
 • Colore all'asso
 
 - Con Board Accoppiato e carte di seme diverso abbiamo:
 • Poker
 
 - Se entrambi falsi e c'è possibilità di scala abbiamo:
 • Scala
 
 - Se entrambi falsi e senza possibilità di scala abbiamo:
 • tris con la carta più alta a terra
 
 */

/*
 
 -- Il Gioco è scandito dallo StepCount --
 
 • == 0 --> PreShuffleUp - Point Zero
 
 • == 1 --> Durante lo ShuffleUp
 
 • == 2 --> Terminato lo Shuffle, Bet Open d'Apertura
 
 • == 3 --> Flop - pre Cards pick - Bet Closed
 
 • == 4 --> Bet open on Flop
 
 • == 5 --> During Turn showing - Bet Closed
 
 • == 6 --> Bet Open on Turn / Pick One card Avaible (if Pick.. stepCount come back to five, and Bet Closed)
 • == 7 --> Bet Open and Pick closed
 
 • == 8 --> Show River
 
 • == 9 --> Result Showed - Ready for a newGame
 
 */
