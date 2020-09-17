//
//  HomeCard.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

struct HomeCard {
    var title: String
    var titleDetail: String
    var imageBackgroundDetail: String
    var list: [HomeCardDetail]
    
    init(title: String, titleDetail: String, imageBackgroundDetail: String,
         list: [HomeCardDetail]) {
        
        self.title = title
        self.titleDetail = titleDetail
        self.imageBackgroundDetail = imageBackgroundDetail
        self.list = list
    }
}

extension HomeCard {
    
    static func getValues() -> [HomeCard] {
        var listReturn: [HomeCard] = []
        
        listReturn.append(getValuesEmployees())
        listReturn.append(getValuesPartners())
        listReturn.append(getValuesCompanies())
        
        return listReturn
    }
    
    static private func getValuesEmployees() -> HomeCard {
        var listDetails: [HomeCardDetail] = []
        
        listDetails.append(HomeCardDetail.init(nameImage: "iconFuncBars",
                                               nameImageDetail: "iconFuncBarsDetail",
                                               title: "Maior controle do nível de qualidade de vida",
                                               description: "Os funcionários possuem controle dos índices que influenciam na sua qualidade de vida, podendo implementar ações de melhoria"))
        
        listDetails.append(HomeCardDetail.init(nameImage: "iconFuncRun",
                                               nameImageDetail: "iconFuncRunDetail",
                                               title: "Acesso as informações de saúde e qualidade de vida",
                                               description: "O Use Vida disponibiliza o portal Info Vida com vídeos e artigos relacionados à saúde e qualidade de vida e bem-estar"))
        
        listDetails.append(HomeCardDetail.init(nameImage: "iconFuncDiscount",
                                               nameImageDetail: "iconFuncDiscountDetail",
                                               title: "Descontos exclusivos",
                                               description: "O usuário poderá economizar, graças aos nossos descontos exclusivos em estabelecimentos com produtos e serviços relacionados à qualidade de vida"))
        
        listDetails.append(HomeCardDetail.init(nameImage: "iconFuncProfessionals",
                                               nameImageDetail: "iconFuncProfessionalsDetail",
                                               title: "Busca rápida por profissionais de saúde",
                                               description: "Os usuários poderão encontrar profissionais de saúde especializados e qualificados por localidade, especialidade"))
        
        return self.init(title: "PARA FUNCIONÁRIOS", titleDetail: "FUNCIONÁRIOS",
                         imageBackgroundDetail: "imageHomeBGDetailEmployees",
                         list: listDetails)
    }
    
    static private func getValuesPartners() -> HomeCard {
        var listDetails: [HomeCardDetail] = []
        
        listDetails.append(HomeCardDetail.init(nameImage: "iconParcGrafics",
                                               nameImageDetail: "iconParcGraficsDetail",
                                               title: "Aumento de faturamento",
                                               description: "Com os incentivos que proporcionamos aos usuários, nossos parceiros têm uma grande oportunidade de um aumento real no seu faturamento"))
        
        listDetails.append(HomeCardDetail.init(nameImage: "iconParcDisclose",
                                               nameImageDetail: "iconParcDiscloseDetail",
                                               title: "Maior divulgação para seu negócio",
                                               description: "Nossos parceiros são amplamente divulgados em nosso site e redes sociais. Os usuários receberão notificações sobre promoções e lançamentos dos estabelecimentos parceiros"))
        
        listDetails.append(HomeCardDetail.init(nameImage: "iconParcMajorRelevancy",
                                               nameImageDetail: "iconParcMajorRelevancyDetail",
                                               title: "Mais relevância para o seu serviço",
                                               description: "Os profissionais de saúde ganharão relevância na sua atuação, pois os temas fazem parte de uma nova abordagem de prevenção na área da qualidade de vida integrativa"))
        
        listDetails.append(HomeCardDetail.init(nameImage: "iconParcNumPatients",
                                               nameImageDetail: "iconParcNumPatientsDetail",
                                               title: "Aumento do número de pacientes",
                                               description: "Os profissionais de saúde podem divulgar seus vídeos e artigos em nossa plataforma digital além de serem divulgados e recomendados para os nossos usuários"))

        
        return self.init(title: "PARA PARCEIROS", titleDetail: "PARCEIROS",
                         imageBackgroundDetail: "imageHomeBGDetailPartners",
                         list: listDetails)
    }
    
    static private func getValuesCompanies() -> HomeCard {
        var listDetails: [HomeCardDetail] = []
        
        listDetails.append(HomeCardDetail.init(nameImage: "iconEmpreCosts",
                                               nameImageDetail: "iconEmpreCostsDetail",
                                               title: "Redução de custos",
                                               description: "Informações e ações de qualidade de vida no trabalho reduzem a sinistralidade dos planos de saúde e o absenteísmo nas organizações"))
        
        listDetails.append(HomeCardDetail.init(nameImage: "iconEmpreProductivity",
                                               nameImageDetail: "iconEmpreProductivityDetail",
                                               title: "Aumento de produtividade",
                                               description: "Saúde e bem-estar no trabalho exercem grande influência sobre a motivação, criatividade e produtividade dos funcionários"))
        
        listDetails.append(HomeCardDetail.init(nameImage: "iconEmpreMapping",
                                               nameImageDetail: "iconEmpreMappingDetail",
                                               title: "Mapeamento da qualidade de vida dos funcionários",
                                               description: "Identificar as oportunidades de melhoria na qualidade de vida dos funcionários é a estratégia correta para um investimento em programas de saúde e bem-estar"))
        
        listDetails.append(HomeCardDetail.init(nameImage: "iconEmpreSatisfaction",
                                               nameImageDetail: "iconEmpreSatisfactionDetail",
                                               title: "Aumento da satisfação dos funcionários",
                                               description: "Funcionários com equilíbrio na qualidade de vida e com hábitos regulares de saúde são funcionários mais satisfeitos"))
        
        listDetails.append(HomeCardDetail.init(nameImage: "",
                                               nameImageDetail: "iconEmpreBenefitsDetail",
                                               title: "Aumento do pacote dos benefícios",
                                               description: "Somos um grande benefício oferecido aos funcionários. Moderno, eficiente e prático, nos destacamos por proporcionar a maximização do bem-estar"))
        
        listDetails.append(HomeCardDetail.init(nameImage: "",
                                               nameImageDetail: "iconEmpreClimateDetail",
                                               title: "Melhora do clima organizacional",
                                               description: "Empresas que investem em benefícios para os funcionários tem um melhor clima organizacional e estão no topo das melhores empresas para se trabalhar"))
        
        
        return self.init(title: "PARA EMPRESAS", titleDetail: "EMPRESAS",
                         imageBackgroundDetail: "imageHomeBGDetailCompanies",
                         list: listDetails)
    }
}
