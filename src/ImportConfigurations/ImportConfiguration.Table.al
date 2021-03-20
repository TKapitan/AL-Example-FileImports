/// <summary>
/// Table TKA Import Configuration (ID 50000).
/// </summary>
table 50000 "TKA Import Configuration"
{
    Caption = 'Import Configuration';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "TKA Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "TKA Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(10; "TKA Import File Format"; Enum "TKA Import File Format")
        {
            Caption = 'Import File Format';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if xRec."TKA Import File Format" <> Rec."TKA Import File Format" then
                    exit;
                "TKA Field Separator" := '';
                "TKA Skip X Lines" := 0;
            end;
        }
        field(15; "TKA Field Separator"; Code[1])
        {
            Caption = 'Field Separator';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                IImportFileFormat: Interface "TKA IImport File Format";
                FieldSeparatorNotSupportedErr: Label 'Field Separator is not supported.';
            begin
                if Rec."TKA Field Separator" = '' then
                    exit;

                IImportFileFormat := Rec."TKA Import File Format";
                if not IImportFileFormat.FieldSeparatorSupported() then
                    Error(FieldSeparatorNotSupportedErr);
            end;
        }
        field(16; "TKA Skip X Lines"; Integer)
        {
            Caption = 'Skip X Lines';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "TKA Code")
        {
            Clustered = true;
        }
    }


    /// <summary>
    /// Import lines using import configuration form current Record (Rec)
    /// </summary>
    /// <returns>Return value of type Record "CSV Buffer" temporary, contains all lines from imported file.</returns>
    procedure ImportFile(): Record "CSV Buffer" temporary
    var
        IImportFileFormat: Interface "TKA IImport File Format";
    begin
        IImportFileFormat := "TKA Import File Format";
        exit(IImportFileFormat.ImportFile(Rec."TKA Code"));
    end;
}