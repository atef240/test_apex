import Class Logs ;

global class SubscriptionComplianceCheck implements Database.Batchable<sObject> {
    private static final String ELEMENTS_MANQUANTS = 'Éléments manquants';
    private static final String IMMO_NEUF = 'Conformité Immo neuf';
	Logs__c log = new Logs__c();
    
    /* Possibilite de mettre une select All * */
    global List<SBQQ__Subscription__c> start(Database.BatchableContext cnx) { 
         return [SELECT * 
                 FROM SBQQ__Subscription__c WHERE Status__c = :ELEMENTS_MANQUANTS
                 AND Souscription_Conforme__c = false];
    }
    
    global void execute(Database.BatchableContext cnx, List<SBQQ__Subscription__c> scope) {
        try {
            List<SBQQ__Subscription__c> subs = new List<SBQQ__Subscription__c>();
            for(SBQQ__Subscription__c sub : scope) {
               if (sub.ComplianceProcess__c == IMMO_NEUF) {
                    SBQQ__Subscription__c subImmo = setConformiteImmoNeuf(sub);
                    if (subImmo != null) {
                        if (sub.SBQQ__RequiredById__c != null) {
                           setParentConforme(sub.SBQQ__RequiredById__c);
                       }
                    }
                }
            }
        } catch(Exception e) {
            Logs.error('SubscriptionComplianceCheck','Batch Compliance Check', e);
        }
    }
    
    global void finish(Database.BatchableContext cnx) {
    }
    

    private SBQQ__Subscription__c setConformiteImmoNeuf(SBQQ__Subscription__c sub) {
		
		log.info("Début du controle de conformite pour le souscrit numero " + sub.Id);
		String causesDeRefus = '';
		
		boolean isPromoterDescription__c = false;
		boolean isFlowType__c = false;
		boolean isProductWorkflow__c = false;
		boolean isContractEmail__c = false;
		boolean isCompanySiret__c = false;
		boolean isCompanyName__c = false;
		boolean isCompanyAddressStreet__c = false;
		boolean isCompanyAddressZipcode__c = false;
		boolean isCompanyAddressCity__c = false;
		boolean isCompanyPhone__c = false;
		boolean isContactGender__c = false;
		boolean isContactFirstName__c = false;
		boolean isContactLastName__c = false;
		boolean isLeadPhone__c = false;									
		
		if (sub.PromoterDescription__c != null){
			boolean isPromoterDescription__c = true;
		} else {
		causesDeRefus = causesDeRefus + " Le champ PromoterDescription__c est vide ";
		}
		
		if (sub.FlowType__c != null){
			boolean isFlowType__c = true;
		} else {
		causesDeRefus = causesDeRefus + " Le champ FlowType__c est vide ";
		}
		
		if (sub.ProductWorkflow__c != null){
			boolean isProductWorkflow__c = true;
		} else {
		causesDeRefus = causesDeRefus + " Le champ ProductWorkflow__c est vide ";
		}
		
		if (sub.ContractEmail__c != null){
			boolean isContractEmail__c = true;
		} else {
		causesDeRefus = causesDeRefus + " Le champ ContractEmail__c est vide ";
		}
		
		if (sub.CompanySiret__c != null){
			boolean isCompanySiret__c = true;
		} else {
		causesDeRefus = causesDeRefus + " Le champ CompanySiret__c est vide ";
		}
		
		if (sub.CompanyName__c != null){
			boolean isCompanyName__c = true;
		} else {
		causesDeRefus = causesDeRefus + " Le champ CompanyName__c est vide ";
		}
		
		if (sub.CompanyAddressStreet__c != null){
			boolean isCompanyAddressStreet__c = true;
		} else {
		causesDeRefus = causesDeRefus + " Le champ CompanyAddressStreet__c est vide ";
		}
		
		if (sub.CompanyAddressZipcode__c != null){
			boolean isCompanyAddressZipcode__c = true;
		} else {
		causesDeRefus = causesDeRefus + " Le champ CompanyAddressZipcode__c est vide ";
		}
		
		if (sub.CompanyAddressCity__c != null){
			boolean isCompanyAddressCity__c = true;
		} else {
		causesDeRefus = causesDeRefus + " Le champ CompanyAddressCity__c est vide ";
		}
		if (sub.CompanyPhone__c != null){
			boolean isCompanyPhone__c = true;
		} else {
		causesDeRefus = causesDeRefus + " Le champ CompanyPhone__c est vide ";
		}
		
		if (sub.ContactGender__c != null){
			boolean isContactGender__c = true;
		} else {
		causesDeRefus = causesDeRefus + " Le champ ContactGender__c est vide ";
		}
		
		if (sub.ContactFirstName__c != null){
			boolean isContactFirstName__c = true;
		} else {
		causesDeRefus = causesDeRefus + " Le champ ContactFirstName__c est vide ";
		}
		if (sub.ContactLastName__c != null){
			boolean isContactLastName__c = true;
		} else {
		causesDeRefus = causesDeRefus + " Le champ ContactLastName__c est vide ";
		}
		
		if (sub.LeadPhone__c != null){
			boolean isLeadPhone__c = true;
		} else {
		causesDeRefus = causesDeRefus + " Le champ LeadPhone__c est vide ";
		}
		
	
	
		// Optimisation de la condition de la conformité de la souscription
        if(	isPromoterDescription__c && isFlowType__c && isProductWorkflow__c && isContractEmail__c && isCompanySiret__c &&	 isCompanyName__c &&
		 isCompanyAddressStreet__c && isCompanyAddressZipcode__c &&	 isCompanyAddressCity__c &&	 isCompanyPhone__c && isContactGender__c &&
		 isContactFirstName__c && isContactLastName__c && isLeadPhone__c &&)
		{
            sub.Souscription_Conforme__c = true;
            update sub;
		log.info("Fin du controle de conformite pour le souscrit numero " + sub.Id + "avec succes");
            return sub;
        }
		log.info("Fin du controle de conformite pour le souscrit numero " + sub.Id + "avec erreur");
        return null;
    }
    
    private void setParentConforme(String parentId) {
		log.info("Début dela fonction  setParentConforme() du parent " + parentId);
        SBQQ__Subscription__c[] parentSub = [SELECT Id, Souscription_Conforme__c FROM SBQQ__Subscription__c WHERE Status__c = :ELEMENTS_MANQUANTS 
                                           AND Souscription_Conforme__c = false AND Id = :parentId];
        if (parentSub.size() > 0) {
            parentSub[0].Souscription_Conforme__c = true;
            UPDATE parentSub[0];
        }
		log.info("Fin dela fonction  setParentConforme() du parent " + parentId);
    }
}
