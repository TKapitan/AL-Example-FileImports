/// <summary>
/// Page TKA Import Configurations (ID 50000).
/// </summary>
page 50000 "TKA Import Configurations"
{
    Caption = 'Import Configurations';
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "TKA Import Configuration";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("TKA Code"; Rec."TKA Code")
                {
                    ToolTip = 'Specifies code of import configuration.';
                    ApplicationArea = All;
                }
                field("TKA Description"; Rec."TKA Description")
                {
                    ToolTip = 'Specifies description of import configuration.';
                    ApplicationArea = All;
                }
                field("TKA Import File Format"; Rec."TKA Import File Format")
                {
                    ToolTip = 'Specifies format of imported file.';
                    ApplicationArea = All;
                }
                field("TKA Skip X Fields"; Rec."TKA Skip X Fields")
                {
                    ToolTip = 'Specifies how many lines (from file start) should be skipped.';
                    ApplicationArea = All;
                }
                field("TKA Field Separator"; Rec."TKA Field Separator")
                {
                    ToolTip = 'Specifies separator of each field. Usage of this field depends on file format.';
                    ApplicationArea = All;
                }
            }
        }
    }

}
