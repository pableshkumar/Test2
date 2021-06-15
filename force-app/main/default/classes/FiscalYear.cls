public class FiscalYear {
    public static string GetFiscalYear(date yearDate){
    string fiscalYear = '';
        FiscalYearSettings currentFY = new FiscalYearSettings();
        list<FiscalYearSettings> fyList = [SELECT Id, PeriodId, StartDate, EndDate, Name, IsStandardYear, YearType FROM FiscalYearSettings where IsStandardYear = false];
        for(FiscalYearSettings fy : fyList ){
            if(fy.StartDate <= yearDate && fy.EndDate >= yearDate){
             currentFY = fy;
            }
 }
        if(currentFY == null){
            return fiscalYear;
        }else{
 fiscalYear = currentFY.StartDate.month() + '/' + currentFY.StartDate.day() + '/' + currentFY.StartDate.year()+'-'+currentFY.EndDate.month() + '/' + currentFY.EndDate.day() + '/' + currentFY.EndDate.year();
        return fiscalYear;
    }
    }
}