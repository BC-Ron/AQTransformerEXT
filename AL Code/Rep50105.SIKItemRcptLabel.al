report 50106 "SIK-Item Recpt Label2"
{
    DefaultLayout = Word;
    RDLCLayout = '50106ItemLable.rdl';
    WordLayout = '50106ItemLabel.docx';
    Caption = 'Inventory Rcpt Label';

    UseRequestPage = true;

    dataset
    {
        dataitem(ItemUOM; "Item Unit of Measure")
        {
            RequestFilterFields = "Item No.", "Code", "SIK-WMS No. Lables to Print";
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    ORDER(Ascending);
                column(CompName; CompInfo.Name)
                {
                }
                column(CompPicture; CompInfo.Picture)
                {
                }
                column(ItemNo; ItemUOM."Item No.")
                {
                }
                column(UOMCode; ItemUOM.Code)
                {
                }
                column(BarCodeNo; BarCode_Item_No.Picture)
                {
                }
                column(ItemDesc; Item.Description)
                {
                }
                column(ItemProdCode; Item."Item Category Code")
                {
                }
                column(LotNo; LotNo)
                {
                }
                column(SerialNo; SerialNo)
                {
                }
                column(ExpDate; ExpDate)
                {
                }
                column(ProdOrderNo; ProdOrderNo)
                {
                }
                column(ShelfNo; Item."Shelf No.")
                {
                }

                trigger OnPreDataItem();
                var
                    FilterNoCopies: Integer;
                begin
                    if NoCopies = 0 then
                        if Evaluate(FilterNoCopies, ItemUOM.GetFilter("SIK-WMS No. Lables to Print")) = false then
                            FilterNoCopies := 0;

                    if FilterNoCopies <> 0 then
                        NoCopies := FilterNoCopies;

                    if NoCopies = 0 then
                        NoCopies := 1;

                    CopyLoop.SETRANGE(Number, 1, NoCopies);
                end;
            }

            trigger OnAfterGetRecord();
            var
                BarCodeText: Text[250];
            begin
                Item.GET("Item No.");

                BarCodeText := Item."No.";

                BarCode_Item_No.Code39Barcode(BarCodeText, 0, 400, 70, false, false, false);

                LotNo := GetFilter("SIK-WMS Lot No. Filter");
                SerialNo := GetFilter("SIK-WMS Serial No. Filter");
                ProdOrderNo := GetFilter("SIK-WMS Prod Order No. filter");
                if Evaluate(ExpDate, GetFilter("SIK-WMS Exp Date Filter")) = false then
                    ExpDate := 0D;
                ShelfNo := item."Shelf No.";

            end;

            trigger OnPreDataItem();
            begin
                CompInfo.GET;
                CompInfo.CALCFIELDS(Picture);
            end;
        }
    }



    labels
    {
        EventIDCaption = 'Event #:'; ExecutionCaption = 'Execution:'; DashCaption = '-';
    }

    trigger OnInitReport();
    begin
        CurrReport.USEREQUESTPAGE(TRUE);
    end;

    var
        CompInfo: Record "Company Information";
        Item: Record Item;
        NoCopies: Integer;
        BarCode_Item_No: Record "SIK-WMS Barcode";
        LotNo: Code[50];
        SerialNo: Code[50];
        ExpDate: Date;
        ProdOrderNo: Code[50];
        ShelfNo: Code[50];
}