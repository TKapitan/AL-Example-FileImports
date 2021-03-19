/// <summary>
/// Enum TKA Import File Format (ID 50000) implements Interface TKA IImport File Format.
/// </summary>
enum 50000 "TKA Import File Format" implements "TKA IImport File Format"
{
    Extensible = true;

    value(5; "Excel file (.xlsx)")
    {
        Caption = 'Excel file (.xlsx)';
        Implementation = "TKA IImport File Format" = "TKA Import File Format XLSX";
    }
    value(10; "CSV file (.csv)")
    {
        Caption = 'CSV file (.csv)';
        Implementation = "TKA IImport File Format" = "TKA Import File Format CSV";
    }
}