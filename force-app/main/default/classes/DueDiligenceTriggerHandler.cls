public class DueDiligenceTriggerHandler {
        public static Boolean isFirstTime = true;

    public static void updatecheckBox(List<Due_Diligence__c> dueDiligenceList){
        Set<ID> partnerId=new set<ID>(); // Set to save the id for partners
        for(Due_Diligence__c due:dueDiligenceList){
            partnerId.add(due.Partner__c);
        }
        List<Due_Diligence__c> dueDiligenceList2=[Select id,Status__c,Active__c,Partner__c from Due_Diligence__c where Partner__c In:partnerId];
        List<Due_Diligence__c> updateddueDiligenceList=new List<Due_Diligence__c>();
        for(Due_Diligence__c due:dueDiligenceList2){
            due.Status__c='Completed';
            due.Active__c=False;
            updateddueDiligenceList.add(due);
        }
        if(!updateddueDiligenceList.isempty()){
            update updateddueDiligenceList;
        }                 
    } 
    
    public static void updateRAGCount(Map<ID,Due_Diligence__c> ddMap)
    {
        List<Due_Diligence__c> updateDDLIst=new List<Due_Diligence__c>();
         List<Due_Diligence__c> DDLIst=[Select A_del__c, Active__c, Amber_RAG_Count__c, Assets_Vs_Liability_Rating__c, Assets_Vs_Liability_Score__c, Assets_Vs_Liability_Weight__c, Call_Support_Management_Overall_Weight__c, Company_Established_Rating__c, Company_Established_Score__c, Company_Established_Weight__c, Company_Established__c, Company_Overall_Weight__c, Company_Overview_RAG_del__c, Coverage_Point_Presence_Overall_Weight__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_spare_in_stock_Management_Score__c, Current_spare_in_stock_Management_Weight__c, Current_spares_in_stock_Management__c, Customer_Base_Feedback_Overall_Weight__c, Customer_Base_Rating__c, Customer_Base_Score__c, Customer_Base_Weight__c, Date_of_Expiry__c, E_bonding_capabilities_Rating__c, E_bonding_capabilities_Score__c, E_bonding_capabilities_Weight__c, Employee_Strength_Rating__c, Employee_Strength_Score__c, Employee_Strength_Weight__c, Employee_Strength__c, Existing_Customer_Recommendation_Weight__c, Existing_Customer_Recommendations_Rating__c, Existing_Customer_Recommendations_Score__c, Existing_Score__c, FSM_Geo_Head__c, Financial_Credibility_Overall_Weight__c, Financial_stability_or_Credit_Rating__c, Financial_stability_or_Credit_Score__c, Financial_stability_or_Credit_Weight__c, Future_plan_enhance_the_presence_Rating__c, Future_plan_enhance_the_presence_Score__c, Future_plan_enhance_the_presence_Weight__c, G_del__c, Green_RAG_Count__c, Health_Safety_Processes_Rating__c, Health_Safety_Processes_Score__c, Health_Safety_Processes_Weight__c, Health_Safety_Processes__c, Id, In_considered10__c, In_considered1__c, In_considered2__c, In_considered3__c, In_considered4__c, In_considered5__c, In_considered6__c, In_considered7__c, In_considered8__c, In_considered9__c, IsDeleted, LastActivityDate, LastModifiedById, LastModifiedDate, Maintenance_or_break_fix_support_Rating__c, Maintenance_or_break_fix_support_Score__c, Maintenance_or_break_fix_support_Weight__c, NBD_Resolution_or_Others_Rating__c, NBD_Resolution_or_Others_Score__c, NBD_Resolution_or_Others_Weight__c, Name, Net_Margin_Growth_for_last_3_year_Rating__c, Net_Margin_Growth_for_last_3_year_Score__c, Net_Margin_Growth_for_last_3_year_Weigh__c, No_of_Countries_covered_direct_Rating__c, No_of_Countries_covered_direct_Score__c, No_of_Countries_covered_direct_Weight__c, No_of_Field_Engineers_Rating__c, No_of_Field_Engineers_Score__c, No_of_Field_Engineers_Weight__c, No_of_High_value_customers_Rating__c, No_of_High_value_customers_Score__c, No_of_High_value_customers_Weight__c, OEM_Partnership_Certification_Rating__c, OEM_Partnership_Certification_Score__c, OEM_Partnership_Certification_Weight__c, OEM_Product_support_Rating__c, OEM_Product_support_Score__c, OEM_Product_support_Weight__c, OEM_model_Spare_Score__c, OEM_model_Spare_replacement_Rating__c, OEM_model_Spare_replacement_Weight__c, Overall10__c, Overall1__c, Overall2__c, Overall3__c, Overall4__c, Overall5__c, Overall6__c, Overall7__c, Overall8__c, Overall9__c, Overall_Normalized_Partnership_RAG__c, Overall_Normalized_Partnership_Score__c, Overall_Normalized_Partnership_Weight__c, Overall_Score_Service_Delievery_Hidden__c, Overall_delivery_capabilities_Rating__c, Overall_delivery_capabilities_Score__c, Overall_delivery_capabilities_Weight__c, Partner_H_O__c, Partner__c, Point_of_presence_Rating__c, Point_of_presence_Score__c, Point_of_presence_Weight__c, Proactiveness_Rating__c, Proactiveness_Score__c, Proactiveness_Weight__c, Products_supported_Rating__c, Products_supported_Score__c, Products_supported_Weight__c, Prospective_Project__c, QualityPCSC_List__c, Quality_PC_SC_List_Rating__c, Quality_PC_SC_List_Score__c, Quality_PC_SC_List_Weight__c, Quality_of_Communication_Document_Weight__c, Quality_of_Communication_Document_submit__c, Quality_of_Communication_Documents_sub__c, RAG_Call_Support_Management__c, RAG_CoveragePointPresence__c, RAG_Customer_Base_Feedback__c, RAG_Financial_Credibility__c, RAG_Responses_Quality_of_Doc__c, RAG_SLA__c, RAG_Service_Delivery__c, RAG_Spare_Management__c, RAG_Technical_capabilities__c, R_del__c, Red_RAG_Count__c, Referral_Customer_feedback_Rating__c, Referral_Customer_feedback_Score__c, Referral_Customer_feedback_Weight__c, Responses_Quality_of_Doc_Overall_Weight__c, Responsiveness_Rating__c, Responsiveness_Score__c, Responsiveness_Weight__c, Retention_of_the_customer_Rating__c, Retention_of_the_customer_Score__c, Retention_of_the_customer_Weight__c, Revenue_Growth_for_last_3_year_Score__c, Revenue_Growth_for_last_3_year_Weight__c, Revenue_Growth_for_last_3_years_Rating__c, SLA_Overall_Weight__c, Service_Delivery_Overall_Weight__c, Skilled_Employees_Certification_RatingTC__c, Skilled_Employees_Certification_Rating__c, Skilled_Employees_Certification_ScoreTC__c, Skilled_Employees_Certification_Score__c, Skilled_Employees_Certification_WeightTC__c, Skilled_Employees_Certification_Weight__c, Spare_Management_Overall_Weight__c, Status__c, SystemModstamp, Technical_capabilities_Overall_Weight__c, Technical_delivery_Matrix_Rating__c, Technical_delivery_Matrix_Score__c, Technical_delivery_Matrix_Weight__c, Ticketing_tools_process_Rating__c, Ticketing_tools_process_Score__c, Ticketing_tools_process_Weight__c, Value_add_innovation_Rating__c, Value_add_innovation_Score__c, Value_add_innovation_Weight__c, Warehouse_Management_Rating__c, Warehouse_Management_Score__c, Warehouse_Management_Weight__c, Warranty_Out_of_Warranty_support_Score__c, Warranty_Out_of_warranty_support_Rating__c, Warranty_Out_of_warranty_support_Weight__c, X24x7_call_center_HelpDesk_support_Ratin__c, X24x7_call_center_HelpDesk_support_Score__c, X24x7_call_center_HelpDesk_support_Weigh__c, X2_hours_Fix_Resolution_Rating__c, X2_hours_Fix_Resolution_Score__c, X2_hours_Fix_Resolution_Weight__c, X4_hours_Fix_Resolution_Rating__c, X4_hours_Fix_Resolution_Score__c, X4_hours_Fix_Resolution_Weight__c, X8_hours_Fix_Resolution_Rating__c, X8_hours_Fix_Resolution_Score__c, X8_hours_Fix_Resolution_Weight__c, label10__c, label11__c, label12__c, label13__c, label14__c, label15__c, label16__c, label17__c, label18__c, label19__c, label20__c, label21__c, label22__c, label23__c, label24__c, label25__c, label26__c, label27__c, label28__c, label29__c, label31__c, label32__c, label33__c, label34__c, label35__c, label36__c, label37__c, label38__c, label39__c, label3__c, label40__c, label4__c, label5__c, label6__c, label7__c, label8__c, label9__c FROM Due_Diligence__c  where id in:ddMap.keySet()];
      for(Due_Diligence__c dd:DDLIst)
      {
          dd.Overall_Score_Service_Delievery_Hidden__c=dd.No_of_Field_Engineers_Score__c+dd.Skilled_Employees_Certification_Score__c+dd.OEM_Product_support_Score__c+dd.Maintenance_or_break_fix_support_Score__c+dd.Existing_Score__c+dd.Overall_delivery_capabilities_Score__c;
          Due_Diligence__c dd1=new Due_Diligence__c();
          dd1.Overall_Score_Service_Delievery_Hidden__c=dd.Overall_Score_Service_Delievery_Hidden__c;
          Integer greenCount=0;
          Integer redCount=0;
          Integer amberCount=0;
          
          If((dd.Overall9__c/dd.Company_Overall_Weight__c)*100 <=55)
          {
              redCount++;
          }else if((dd.Overall9__c/dd.Company_Overall_Weight__c)*100 <80)
          {
              amberCount++;
          }
          else 
          {
              greenCount++;
          }
          
          If((dd.Overall6__c/dd.Financial_Credibility_Overall_Weight__c)*100 <=55)
          {
              redCount++;
          }else if((dd.Overall6__c/dd.Financial_Credibility_Overall_Weight__c)*100 <80)
          {
              amberCount++;
          }
          else 
          {
              greenCount++;
          }
          System.debug('dd.Overall_Score_Service_Delievery_Hidden__c/dd.Service_Delivery_Overall_Weight__c)*100 '+(dd.Overall_Score_Service_Delievery_Hidden__c/dd.Service_Delivery_Overall_Weight__c)*100);
          If((dd.Overall_Score_Service_Delievery_Hidden__c/dd.Service_Delivery_Overall_Weight__c)*100 <=55)
          {
              redCount++;
          }else if((dd.Overall_Score_Service_Delievery_Hidden__c/dd.Overall_Score_Service_Delievery_Hidden__c)*100 <80)
          {
              amberCount++;
          }
          else 
          {
              greenCount++;
          }
          
          If((dd.Overall8__c/dd.Coverage_Point_Presence_Overall_Weight__c)*100 <=55)
          {
              redCount++;
          }else if((dd.Overall8__c/dd.Coverage_Point_Presence_Overall_Weight__c)*100 <80)
          {
              amberCount++;
          }
          else 
          {
              greenCount++;
          }
          
          If((dd.Overall3__c/dd.SLA_Overall_Weight__c)*100 <=55)
          {
              redCount++;
          }else if((dd.Overall3__c/dd.SLA_Overall_Weight__c)*100 <80)
          {
              amberCount++;
          }
          else 
          {
              greenCount++;
          }
          
             If((dd.Overall1__c/dd.Technical_capabilities_Overall_Weight__c)*100 <=55)
          {
              redCount++;
          }else if((dd.Overall1__c/dd.Technical_capabilities_Overall_Weight__c)*100 <80)
          {
              amberCount++;
          }
          else 
          {
              greenCount++;
          }
          
             If((dd.Overall10__c/dd.Call_Support_Management_Overall_Weight__c)*100 <=55)
          {
              redCount++;
          }else if((dd.Overall10__c/dd.Call_Support_Management_Overall_Weight__c)*100 <80)
          {
              amberCount++;
          }
          else 
          {
              greenCount++;
          }
          
              If((dd.Overall2__c/dd.Spare_Management_Overall_Weight__c)*100 <=55)
          {
              redCount++;
          }else if((dd.Overall2__c/dd.Spare_Management_Overall_Weight__c)*100 <80)
          {
              amberCount++;
          }
          else 
          {
              greenCount++;
          }
          
            If((dd.Overall5__c/dd.Responses_Quality_of_Doc_Overall_Weight__c)*100 <=55)
          {
              redCount++;
          }else if((dd.Overall5__c/dd.Responses_Quality_of_Doc_Overall_Weight__c)*100 <80)
          {
              amberCount++;
          }
          else 
          {
              greenCount++;
          }
          
            If((dd.Overall7__c/dd.Customer_Base_Feedback_Overall_Weight__c)*100 <=55)
          {
              redCount++;
          }else if((dd.Overall7__c/dd.Customer_Base_Feedback_Overall_Weight__c)*100 <80)
          {
              amberCount++;
          }
          else 
          {
              greenCount++;
          }
          //
         dd1.id=dd.id;
          dd1.Green_RAG_Count__c=greenCount;
          dd1.Amber_RAG_Count__c=amberCount;
          dd1.Red_RAG_Count__c=redCount;
          updateDDLIst.add(dd1);
      }
        if(updateDDLIst.size()>0)
        {
        update updateDDLIst;
        }
    
    }
}