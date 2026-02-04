import SwiftUI

struct CreateFantasyLeagueSheetV2: View {
    @State private var vm = CreateFantasyLeagueViewModelV2()
    
    var body: some View {
        ZStack {
            Color.backgroundMain.ignoresSafeArea()
            
            ScrollView {
                VStack {
                    header("Fantasy League Name")
                    leagueNameTextField
                }
                .padding()
                
                VStack {
                    header("Draft Date")
                    draftDatePicker
                }
                .padding()
                
                HStack {
                    header("PPR")
                    pprToggle
                }
                .padding()
                
                HStack {
                    header("Kickers")
                    kickerToggle
                }
                .padding()
                
                HStack {
                    header("Punters")
                    punterToggle
                }
                .padding()
                
                VStack {
                    Text("QB Stats")
                        .font(.title)
                        .bold()
                    
                    qbStatSteppers
                }
                .fontWeight(.semibold)
                .padding()
                
                VStack {
                    Text("RB Stats")
                        .font(.title)
                        .bold()
                    
                    rbStatSteppers
                }
                .fontWeight(.semibold)
                .padding()
                
                VStack {
                    Text("REC Stats")
                        .font(.title)
                        .bold()
                    
                    recStatSteppers
                }
                .fontWeight(.semibold)
                .padding()
                
                if vm.newFantasyLeague.includeKickers {
                    VStack {
                        Text("KICK Stats")
                            .font(.title)
                            .bold()
                        
                        kickStatSteppers
                    }
                    .fontWeight(.semibold)
                    .padding()
                }
                
                if vm.newFantasyLeague.includePunters {
                    VStack {
                        Text("PUNT Stats")
                            .font(.title)
                            .bold()
                        
                        puntStatSteppers
                    }
                    .fontWeight(.semibold)
                    .padding()
                }
                
                VStack {
                    Text("RETURN Stats")
                        .font(.title)
                        .bold()
                    
                    returnStatSteppers
                }
                .fontWeight(.semibold)
                .padding()
                
                VStack {
                    Text("MISC Stats")
                        .font(.title)
                        .bold()
                    
                    miscStatSteppers
                }
                .fontWeight(.semibold)
                .padding()
            }
            .navigationTitle("Create Fantasy League")
            .navigationBarTitleDisplayMode(.inline)
            .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        Task {
                            await vm.createFantasyLeague()
                        }
                    } label: {
                        Text("Create League")
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .scrollContentBackground(.hidden)
            .foregroundStyle(.offWhite)
        }
    }
    
    private func header(_ text: String) -> some View {
        Text(text)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var leagueNameTextField: some View {
        TextField("",
                  text: $vm.newFantasyLeague.leagueName)
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.15))
        )
        .foregroundStyle(.offWhite)
        .keyboardType(.asciiCapable)
        .textInputAutocapitalization(.words)
    }
    
    private var draftDatePicker: some View {
        DatePicker(
            "Draft Date",
            selection: $vm.newFantasyLeague.draftDate,
            in: Date.now...AppConfig.LAST_DAY_DRAFT,
            displayedComponents: .date
        )
        .datePickerStyle(.graphical)
        .foregroundStyle(.offWhite)
        .colorScheme(.dark)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.15))
        )
    }
    
    private var pprToggle: some View {
        Toggle("PPR", isOn: $vm.newFantasyLeague.ppr)
            .labelsHidden()
            .toggleStyle(.switch)
            .tint(.accentColor)
    }
    
    private var kickerToggle: some View {
        Toggle("Kickers", isOn: $vm.newFantasyLeague.includeKickers)
            .labelsHidden()
            .toggleStyle(.switch)
            .tint(.accentColor)
    }
    
    private var punterToggle: some View {
        Toggle("Punters", isOn: $vm.newFantasyLeague.includePunters)
            .labelsHidden()
            .toggleStyle(.switch)
            .tint(.accentColor)
    }
    
    private var qbStatSteppers: some View {
        VStack {
            StatStepperRow(title: "Points per 25 Pass Yards",
                           value: $vm.newFantasyLeague.pointsPer25PassYds,
                           range: 0.0...3.0,
                           step: 0.5)
            
            StatStepperRow(title: "Points per Pass TD",
                           value: $vm.newFantasyLeague.pointsPerPassTd,
                           range: 1.0...10.0,
                           step: 0.5)
            
            StatStepperRow(title: "Points per INT",
                           value: $vm.newFantasyLeague.pointsPerInt,
                           range: -3.0...0.0,
                           step: 0.5)
        }
    }
    
    private var rbStatSteppers: some View {
        VStack {
            StatStepperRow(title: "Points per 10 Rush Yards",
                           value: $vm.newFantasyLeague.pointsPer10RushYds,
                           range: 1.0...3.0,
                           step: 0.5)
            
            StatStepperRow(title: "Points per Rush TD",
                           value: $vm.newFantasyLeague.pointsPerRushTd,
                           range: 1.0...10.0,
                           step: 0.5)
        }
    }
    
    private var recStatSteppers: some View {
        VStack {
            if vm.newFantasyLeague.ppr {
                StatStepperRow(title: "Points per Reception",
                               value: $vm.newFantasyLeague.pointsPer10RushYds,
                               range: vm.POS_POINT_RANGE,
                               step: vm.STAT_STEP)
            }
            
            StatStepperRow(title: "Points per 10 Receiving Yards",
                           value: $vm.newFantasyLeague.pointsPer10RecYds,
                           range: vm.POS_POINT_RANGE,
                           step: vm.STAT_STEP)
            
            StatStepperRow(title: "Points per Receiving TD",
                           value: $vm.newFantasyLeague.pointsPerRecTd,
                           range: vm.POS_POINT_RANGE,
                           step: vm.STAT_STEP)
        }
    }
    
    private var kickStatSteppers: some View {
        VStack {
            StatStepperRow(title: "Points per FG Made",
                           value: $vm.newFantasyLeague.pointsPerFgMade,
                           range: vm.POS_POINT_RANGE,
                           step: vm.STAT_STEP)
            
            StatStepperRow(title: "Points per FG Miss",
                           value: $vm.newFantasyLeague.pointsPerFgMiss,
                           range: vm.NEG_POINT_RANGE,
                           step: vm.STAT_STEP)
            
            StatStepperRow(title: "Points per XP Made",
                           value: $vm.newFantasyLeague.pointsPerXpMade,
                           range: vm.POS_POINT_RANGE,
                           step: vm.STAT_STEP)
            
            StatStepperRow(title: "Points per XP Miss",
                           value: $vm.newFantasyLeague.pointsPerXpMiss,
                           range: vm.NEG_POINT_RANGE,
                           step: vm.STAT_STEP)
        }
    }
    
    private var puntStatSteppers: some View {
        VStack {
            StatStepperRow(title: "Points per Punt in 20",
                           value: $vm.newFantasyLeague.pointsPerPuntIn20,
                           range: vm.POS_POINT_RANGE,
                           step: vm.STAT_STEP)
        }
    }
    
    private var returnStatSteppers: some View {
        VStack {
            StatStepperRow(title: "Points per Kick Return TD",
                           value: $vm.newFantasyLeague.pointsPerKickReturnTd,
                           range: vm.POS_POINT_RANGE,
                           step: vm.STAT_STEP)
            
            StatStepperRow(title: "Points per Punt Return TD",
                           value: $vm.newFantasyLeague.pointsPerPuntReturnTd,
                           range: vm.POS_POINT_RANGE,
                           step: vm.STAT_STEP)
        }
    }
    
    private var miscStatSteppers: some View {
        VStack {
            StatStepperRow(title: "Points per Fumble Lost",
                           value: $vm.newFantasyLeague.pointsPerFumbleLost,
                           range: vm.NEG_POINT_RANGE,
                           step: vm.STAT_STEP)
        }
    }
}

#Preview {
    NavigationStack {
        CreateFantasyLeagueSheetV2()
    }
}
