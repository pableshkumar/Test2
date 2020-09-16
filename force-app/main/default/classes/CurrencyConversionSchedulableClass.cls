global class CurrencyConversionSchedulableClass implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        CurrencyConversionClass b = new CurrencyConversionClass(); //Ur batch class
        database.executebatch(b);
    }
}